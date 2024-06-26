/client/proc/age_verification()
	set waitfor = FALSE
	age_verification_impl()

/client/proc/age_verification_impl()
	if(!SSdbcore.Connect())
		return TRUE
	if(!player.block_on_available(10 SECONDS))
		message_admins("FATAL: player data unavailable during age verification.")
		. = TRUE
		CRASH("player data was not available during age verification")
	if(is_staff())
		set_age_verified()
		return TRUE
	if(is_age_verified())
		return TRUE

	prompt_age_verification()

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

/client/proc/prompt_age_verification()
	var/list/dat = list("<center>")
	dat += "Enter your date of birth here, to confirm that you are over 18.<BR>"
	dat += "<b>Your date of birth is not saved, only the fact that you are over/under 18 is.</b><BR>"
	dat += "</center>"

	dat += "<form action='?src=[REF(src)]'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += HrefTokenFormField()
	dat += "<select name = 'month'>"
	var/monthList = list("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12)
	for(var/month in monthList)
		dat += "<option value = [monthList[month]]>[month]</option>"
	dat += "</select>"
	dat += "<select name = 'year' style = 'float:right'>"
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

/client/proc/handle_age_gate(player_month, player_year)
	player_month = text2num(player_month)
	player_year = text2num(player_year)

	if(usr.client.is_age_verified())
		return TRUE

	if(isnull(player_month) || isnull(player_year))
		return TRUE

	var/current_time = world.realtime
	var/current_month = text2num(time2text(current_time, "MM"))
	var/current_year = text2num(time2text(current_time, "YYYY"))

	var/player_total_months = (player_year * 12) + player_month

	var/current_total_months = (current_year * 12) + current_month

	var/months_in_eighteen_years = 18 * 12

	var/month_difference = current_total_months - player_total_months
	if(month_difference > months_in_eighteen_years)
		usr.client.age_gate_internal_succeeded()
	else
		if(month_difference < months_in_eighteen_years)
			usr.client.age_gate_internal_failed()
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
			var/player_day = input("Enter the day of the month you were born on.", "Age Verification", src) as num|null
			if(isnull(player_day))
				return TRUE
			if(player_day <= current_day)
				//their birthday has passed
				usr.client.age_gate_internal_succeeded()
			else
				//it has NOT been their 18th birthday yet
				usr.client.age_gate_internal_failed()
	return TRUE

/client/proc/age_gate_internal_failed()
	if(CONFIG_GET(flag/age_verification_autoban))
		security_ban("Age verification failed. Appeal this on the Discord after you are 18 years of age or older.")
	else
		security_kick("Age verification failed. This server is for 18+ only.", TRUE)

/client/proc/age_gate_internal_succeeded()
	set_age_verified()
	src << browse(null, "window=age_gate")
