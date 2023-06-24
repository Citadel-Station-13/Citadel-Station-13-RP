/client/proc/age_verification()
	if(!player.block_on_available(10 SECONDS))
		message_admins("FATAL: player data unavailable during age verification.")
		. = TRUE
		CRASH("player data was not available during age verification")
	if(is_staff())
		set_age_verified()
		return TRUE
	if(is_age_verified())
		return TRUE
	GLOB.age_verify_menu.ui_interact(mob)
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

GLOBAL_DATUM_INIT(age_verify_menu, /datum/age_verify_menu, new)

/datum/age_verify_menu

/datum/age_verify_menu/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AgeVerifyMenu")
		ui.open()

/datum/age_verify_menu/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	return UI_INTERACTIVE

/datum/age_verify_menu/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	if(usr.client.is_age_verified())
		return TRUE

	var/player_month = text2num(params["month"])
	var/player_year = text2num(params["year"])

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
			var/player_day = text2num(params["day"])
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
	var/datum/tgui/found = SStgui.get_open_ui(usr, GLOB.age_verify_menu)
	if(!isnull(found))
		found.close()
	security_ban("Age verification failed. Appeal this on the Discord after you are 18 years of age or older.")

/client/proc/age_gate_internal_succeeded()
	var/datum/tgui/found = SStgui.get_open_ui(usr, GLOB.age_verify_menu)
	if(!isnull(found))
		found.close()
	set_age_verified()
