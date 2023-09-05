/client/verb/regenerate_cached_character_appearance()
	set name = "Regenerate Cached Profile Appearance"
	set category = "OOC"
	set desc = "Regenerates the cached appearance of your character in their profile."

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
	if(world.time < usr.next_move)
		to_chat(usr, "<span class='warning'>Don't spam appearance refreshes.</span>")
		return
	usr.setClickCooldown(10)

	if (usr.name in GLOB.cached_previews)
		GLOB.cached_previews[usr.name] = get_flat_icon_simple(usr)
		to_chat(usr, SPAN_NOTICE("Your cached appearance has been regenerated."))
	else
		to_chat(usr, SPAN_BOLDWARNING("Your current mob was not found in the appearance cache."))
