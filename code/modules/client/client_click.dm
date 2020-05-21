/client/Click(atom/object, atom/location, control, params)
	var/ab = FALSE
	var/list/L = params2list(params)
	if (object && object == middragatom && L["left"])
		ab = max(0, 5 SECONDS-(world.time-middragtime)*0.1)
	var/mcl = config_legacy.minute_click_limit		//CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0
		clicklimiter[MINUTE_COUNT] += 1+(ab)
		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				if (ab)
					log_game("[key_name(src)] is using the middle click aimbot exploit")
					message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] is using the middle click aimbot exploit</span>")
					add_system_note("aimbot", "Is using the middle click aimbot exploit")

				log_game("[key_name(src)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
				message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/scl = config_legacy.second_click_limit		//CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0
		clicklimiter[SECOND_COUNT] += 1+(!!ab)
		if (clicklimiter[SECOND_COUNT] > scl)
			to_chat(src, "<span class='danger'>Your previous click was ignored because you've done too many in a second</span>")
			return

	if(ab) //Citadel edit, things with stuff.
		return


	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, null, "input.background-color=[COLOR_INPUT_DISABLED]")

	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED]")

	return ..()
