/client/proc/looc_wrapper()
	var/message = input("","looc (text)") as text|null
	if(message)
		looc(message)

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = VERB_CATEGORY_OOC

	if(!reject_on_initialization_block())
		return
	if(!reject_age_unverified())
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	if(SSbans.t_is_role_banned_ckey(ckey, role = BAN_ROLE_OOC) && IS_DEAD(mob))
		to_chat(src, SPAN_WARNING("You are banned from typing in LOOC while dead, and deadchat."))
		return

	// -- HTML ENCODE HERE --
	msg = sanitize_input_ooc(msg)
	// -- END --

	if(!msg)
		return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/looc))
		to_chat(src, "<span class='danger'>You have LOOC muted.</span>")
		return

	if(!holder)
		if(!config_legacy.looc_allowed)
			to_chat(src, "<span class='danger'>LOOC is globally muted.</span>")
			return
		if(!config_legacy.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(msg)
		handle_spam_prevention(MUTE_OOC)

	var/mob/source = mob.get_looc_source()
	var/turf/T = get_turf(source)
	if(!T)
		return
	var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
	var/list/m_viewers = in_range["mobs"]

	var/list/receivers = list() //Clients, not mobs.
	var/list/r_receivers = list()

	var/display_name = get_public_key()
	if(mob.stat != DEAD)
		display_name = mob.name
	// Resleeving shenanigan prevention.
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.original_player && H.original_player != H.ckey) //In a body not their own
			display_name = "[H.mind.name] (as [H.name])"

	// Everyone in normal viewing range of the LOOC
	for(var/mob/viewer in m_viewers)
		if(viewer.client && viewer.client.get_preference_toggle(/datum/game_preference_toggle/chat/looc))
			receivers |= viewer.client
		else if(istype(viewer,/mob/observer/eye)) // For AI eyes and the like
			var/mob/observer/eye/E = viewer
			if(E.owner && E.owner.client)
				receivers |= E.owner.client

	// Admins with RLOOC displayed who weren't already in
	for(var/client/admin in GLOB.admins)
		if(!(admin in receivers) && admin.get_preference_toggle(/datum/game_preference_toggle/admin/global_looc))
			r_receivers |= admin

	msg = emoji_parse(msg)

	if(persistent.ligma)
		to_chat(src, "<span class='looc'>" +  "LOOC: " + "<EM>[display_name]: </EM><span class='message'><span class='linkify'>[msg]</span></span></span>")
		log_shadowban("[key_name(src)] LOOC: [msg]")
		return

	log_looc(msg,src)

	// Send a message
	for(var/client/target in receivers)
		var/admin_stuff = ""

		if(target in GLOB.admins)
			admin_stuff += "/([key])"

		to_chat(target, "<span class='looc'>" +  "LOOC: " + "<EM>[display_name][admin_stuff]: </EM><span class='message'><span class='linkify'>[msg]</span></span></span>")

	for(var/client/target in r_receivers)
		var/admin_stuff = "/([key])([admin_jump_link(mob, target.holder)])"

		to_chat(target, "<span class='looc'>" + "LOOC: " + " <span class='prefix'>(R)</span><EM>[display_name][admin_stuff]: </EM> <span class='message'><span class='linkify'>[msg]</span></span></span>")

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src
