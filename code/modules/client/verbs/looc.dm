GLOBAL_VAR_INIT(LOOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_looc_colour, "#6699CC")

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(src, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	if(!msg)
		return

	if(!is_preference_enabled(/datum/client_preference/show_looc))
		to_chat(src, "<span class='danger'>You have LOOC muted.</span>")
		return

	if(!holder)
		if(!config_legacy.looc_allowed)
			to_chat(src, "<span class='danger'>LOOC is globally muted.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return
		if(handle_spam_prevention(MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(mob.stat)
			to_chat(src, "<span class='danger'>You cannot salt in LOOC while unconscious or dead.</span>")
			return
		if(istype(mob, /mob/dead))
			to_chat(src, "<span class='danger'>You cannot use LOOC while ghosting.</span>")
			return
		if(!config_legacy.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return

	msg = emoji_parse(msg)

	log_looc(msg,src)

	var/list/heard = get_hearers_in_view(7, src.mob) //get_top_level_mob(
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in GLOB.admins)
			continue //they are handled after that

		if (isobserver(M))
			continue //Also handled later.

		if(C.is_preference_enabled(/datum/client_preference/show_looc)) //prefs.toggles & CHAT_OOC)
			if(GLOB.LOOC_COLOR)
				to_chat(C, "<font color='[GLOB.LOOC_COLOR]'><b><span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>")
			else
				to_chat(C, "<span class='looc'><span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></span>")


	for(var/client/C in GLOB.admins)
		if(C.is_preference_enabled(/datum/client_preference/holder/show_rlooc)) //prefs.toggles & CHAT_OOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			if(GLOB.LOOC_COLOR)
				to_chat(C, "<font color='[GLOB.LOOC_COLOR]'><b>[ADMIN_FLW(usr)] <span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>")
			else
				to_chat(C, "<span class='looc'>[ADMIN_FLW(usr)] <span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></span>")
