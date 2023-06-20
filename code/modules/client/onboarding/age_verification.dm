/client/proc/age_verification()
	if(is_staff())
		set_age_verified()
		return TRUE
	if(is_age_verified())
		return TRUE
	age_gate_window()
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

//* This is an important thing, so, we don't use TGUI *//

/client/proc/age_gate_window()
	var/list/dat = list("<center>")
	dat += "Enter your date of birth here, to confirm that you are over 18.<BR>"
	dat += "<b>Your date of birth is not saved, only the fact that you are over/under 18 is.</b><BR>"
	dat += "</center>"

	dat += "<form action='?src=[REF(src)]'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<input type='hidden' name='client_age_verify' value='1"
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

	var/datum/browser/popup = new(src, "age_gate", "<div align='center'>Age Gate</div>", 400, 250)
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/client/proc/age_gate_topic(list/href_list)
	// ensure they're not verified
	if(is_age_verified())
		return TRUE

	if(!href_list["Month"])
		// how??
		return TRUE

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
		age_gate_internal_succeeded()
	else
		if(month_difference < months_in_eighteen_years)
			age_gate_internal_failed()
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
				age_gate_internal_succeeded()
			else
				//it has NOT been their 18th birthday yet
				age_gate_internal_failed()
	return TRUE

/client/proc/age_gate_internal_failed()
	src << browse(null, "window=age_gate")
	security_ban("Age verification failed. Appeal this on the Discord after you are 18 years of age or older.")

/client/proc/age_gate_internal_succeeded()
	src << browse(null, "window=age_gate")
	set_age_verified()
