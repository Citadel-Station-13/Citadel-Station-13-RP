/client/proc/age_verification()
	if(is_staff())
		set_age_verified()
		return TRUE
	if(is_age_verified())
		return TRUE
	#warn content
	return TRUE

/client/proc/set_age_verified()
	if(player.player_flags & PLAYER_FLAG_AGE_VERIFIED)
		return TRUE
	player.player_flags |= PLAYER_FLAG_AGE_VERIFIED
	player.save()
	return TRUE

/client/proc/is_age_verified()
	SHOULD_NOT_SLEEP(TRUE)
	return !CONFIG_GET(flag/age_verification) || (player.player_flags & PLAYER_FLAG_AGE_VERIFIED) || is_staff()

/client/proc/reject_age_unverified()
	SHOULD_NOT_SLEEP(TRUE)
	. = is_age_verified()
	if(!.)
		to_chat(src, SPAN_DANGER("Age verification must be completed before doing that."))

#warn below

/mob/new_player/proc/age_gate()
	var/list/dat = list("<center>")
	dat += "Enter your date of birth here, to confirm that you are over 18.<BR>"
	dat += "<b>Your date of birth is not saved, only the fact that you are over/under 18 is.</b><BR>"
	dat += "</center>"

	dat += "<form action='?src=[REF(src)]'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<select name = 'Month'>"
	var/monthList = list("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12)
	for(var/month in monthList)
		dat += "<option value = [monthList[month]]>[month]</option>"
	dat += "</select>"
	dat += "<select name = 'Year' style = 'float:right'>"
	var/current_year = text2num(time2text(world.realtime, "YYYY"))
	var/start_year = 1920
	for(var/year in start_year to current_year)
		var/reverse_year = 1920 + (current_year - year)
		dat += "<option value = [reverse_year]>[reverse_year]</option>"
	dat += "</select>"
	dat += "<center><input type='submit' value='Submit information'></center>"
	dat += "</form>"

	winshow(src, "age_gate", TRUE)
	var/datum/browser/popup = new(src, "age_gate", "<div align='center'>Age Gate</div>", 400, 250)
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(src, "age_gate")

	while(age_gate_result == null)
		stoplag(1)

	popup.close()

	return age_gate_result

/mob/new_player/proc/verifyage()
	UNTIL(client.prefs.initialized)	// fuck this stupid ass broken piece of shit age gate
	if(client.holder)		// they're an admin
		client.set_preference(/datum/client_preference/debug/age_verified, 1)
		return TRUE
	if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified)) //make sure they are verified
		if(!client.prefs)
			message_admins("Blocked [src] from new player panel because age gate could not access client preferences.")
			return FALSE
		else
			var/hasverified = client.is_preference_enabled(/datum/client_preference/debug/age_verified)
			if(!hasverified) //they have not completed age gate
				var/verify = age_gate()
				if(verify == FALSE)
					client.add_system_note("Automated-Age-Gate", "Failed automatic age gate process")
					//ban them and kick them
					to_chat(src, "You have failed the initial age verification check. \nIf you believe this was in error, you MUST submit to additional verification on the forums at citadel-station.net/forum/")
					if(client)
						AddBan(ckey, computer_id, "Failed initial age verification check. Appeal at citadel-station.net/forum/", "SYSTEM", 0, 0)
						Logout()
					return FALSE
				else
					//they claim to be of age, so allow them to continue and update their flags
					client.set_preference(/datum/client_preference/debug/age_verified, 1)
					SScharacters.queue_preferences_save(client.prefs)
					//log this
					message_admins("[ckey] has joined through the automated age gate process.")
					return TRUE
	return TRUE

/mob/new_player/Topic()

	//don't let people get to this unless they are specifically not verified
	if(href_list["Month"] && !client.is_preference_enabled(/datum/client_preference/debug/age_verified))
		var/player_month = text2num(href_list["Month"])
		var/player_year = text2num(href_list["Year"])

		var/current_time = world.realtime
		var/current_month = text2num(time2text(current_time, "MM"))
		var/current_year = text2num(time2text(current_time, "YYYY"))

		var/player_total_months = (player_year * 12) + player_month

		var/current_total_months = (current_year * 12) + current_month

		var/months_in_eighteen_years = 18 * 12

		var/month_difference = current_total_months - player_total_months
		if(month_difference > months_in_eighteen_years)
			age_gate_result = TRUE // they're fine
		else
			if(month_difference < months_in_eighteen_years)
				age_gate_result = FALSE
			else
				//they could be 17 or 18 depending on the /day/ they were born in
				var/current_day = text2num(time2text(current_time, "DD"))
				var/days_in_months = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
				if((player_year % 4) == 0) // leap year so february actually has 29 days
					days_in_months[2] = 29
				var/total_days_in_player_month = days_in_months[player_month]
				var/list/days = list()
				for(var/number in 1 to total_days_in_player_month)
					days += number
				var/player_day = input(src, "What day of [player_month] were you born in.") as anything in days
				if(player_day <= current_day)
					//their birthday has passed
					age_gate_result = TRUE
				else
					//it has NOT been their 18th birthday yet
					age_gate_result = FALSE

	if(!verifyage())
		return
