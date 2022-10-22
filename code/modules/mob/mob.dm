
/**
 * Intialize a mob
 *
 * Adds to global lists
 * * GLOB.mob_list
 * * dead_mob_list - if mob is dead
 * * living_mob_list - if the mob is alive
 *
 * Other stuff:
 * * Sets the mob focus to itself
 * * Generates huds
 * * If there are any global alternate apperances apply them to this mob
 * * Intialize the transform of the mob
 */
/mob/Initialize(mapload)
	GLOB.mob_list += src
	set_focus(src)
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src
	prepare_huds()
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)
	init_rendering()
	hook_vr("mob_new",list(src))
	// resize
	update_transform()
	// offset
	reset_pixel_offsets()
	. = ..()
	update_config_movespeed()
	update_movespeed(TRUE)
	initialize_actionspeed()

/**
 * Delete a mob
 *
 * Removes mob from the following global lists
 * * GLOB.mob_list
 * * dead_mob_list
 * * living_mob_list
 *
 * Unsets the focus var
 *
 * Clears alerts for this mob
 *
 * Resets all the observers perspectives to the tile this mob is on
 *
 * qdels any client colours in place on this mob
 *
 * Ghostizes the client attached to this mob
 *
 * Parent call
 *
 * Returns QDEL_HINT_HARDDEL (don't change this)
 */
/mob/Destroy()//This makes sure that mobs with GLOB.clients/keys are not just deleted from the game.
	GLOB.mob_list -= src
	dead_mob_list -= src
	living_mob_list -= src
	unset_machine()
	movespeed_modification = null
	actionspeed_modification = null
	for(var/alert in alerts)
		clear_alert(alert)
	if(client)
		for(var/atom/movable/screen/movable/spell_master/spell_master in spell_masters)
			qdel(spell_master)
		remove_screen_obj_references()
		client.screen = list()
	if(mind && mind.current == src)
		spellremove(src)
	// this kicks out client
	ghostize()
	if(hud_used)
		QDEL_NULL(hud_used)
	dispose_rendering()
	if(plane_holder)
		QDEL_NULL(plane_holder)
	// with no client, we can safely remove perspective this way snow-flakily
	if(using_perspective)
		using_perspective.RemoveMob(src)
		using_perspective = null
	..()
	return QDEL_HINT_HARDDEL

/**
 * Generate the tag for this mob
 *
 * This is simply "mob_"+ a global incrementing counter that goes up for every mob
 */
/mob/GenerateTag()
	tag = "mob_[++next_mob_id]"

/**
 * Prepare the huds for this atom
 *
 * Goes through hud_possible list and adds the images to the hud_list variable (if not already
 * cached)
 */
/atom/proc/prepare_huds()
	hud_list = list()
	for(var/hud in hud_possible)
		var/hint = hud_possible[hud]
		switch(hint)
			if(HUD_LIST_LIST)
				hud_list[hud] = list()
			else
				var/image/I = image(GLOB.hud_icon_files[hud] || 'icons/screen/atom_hud/misc.dmi', src, "")
				I.plane = FLOAT_PLANE
				I.layer = FLOAT_LAYER + 100 + (GLOB.hud_icon_layers[hud] || 0)
				I.appearance_flags = RESET_COLOR|RESET_TRANSFORM
				hud_list[hud] = I

/mob/proc/remove_screen_obj_references()
	hands = null
	pullin = null
	purged = null
	internals = null
	oxygen = null
	i_select = null
	m_select = null
	toxin = null
	fire = null
	bodytemp = null
	healths = null
	throw_icon = null
	nutrition_icon = null
	pressure = null
	pain = null
	item_use_icon = null
	gun_move_icon = null
	gun_setting_icon = null
	spell_masters = null
	zone_sel = null

/// Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
/mob/proc/show_message(msg, type, alt, alt_type)

	if(!client && !teleop)	return

	if (type)
		if((type & 1) && (is_blind() || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if ((type & 2) && is_deaf())//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1) && (sdisabilities & SDISABILITY_NERVOUS))
					return
	// Added voice muffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src,"<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src,msg)
		if(teleop)
			to_chat(teleop, create_text_tag("body", "BODY:", teleop) + "[msg]")
	return

/**
 * Show a message to all mobs in earshot of this one
 *
 * This would be for audible actions by the src mob
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * self_message (optional) is what the src mob hears.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 */
/mob/audible_message(var/message, var/deaf_message, var/hearing_distance, var/self_message)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]

	for(var/obj in hearing_objs)
		var/obj/O = obj
		O.show_message(message, 2, deaf_message, 1)

	for(var/mob in hearing_mobs)
		var/mob/M = mob
		var/msg = message
		if(self_message && M==src)
			msg = self_message
		M.show_message(msg, 2, deaf_message, 1)

/mob/proc/findname(msg)
	for(var/mob/M in GLOB.mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2

/mob/proc/is_buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_blind()
	return ((sdisabilities & SDISABILITY_NERVOUS) || blinded || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_deaf()
	return ((sdisabilities & SDISABILITY_DEAF) || ear_deaf || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_STUNNED) && stunned)
		return 1

	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (weakened || resting))
		return 1

	if ((incapacitation_flags & INCAPACITATION_KNOCKOUT) && (stat || paralysis || sleeping || (status_flags & FAKEDEATH)))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

///Is the mob restrained
/mob/proc/restrained()
	return

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/A as mob|obj|turf in view(get_turf(src))) //It used to be oview(12), but I can't really say why
	set name = "Examine"
	set category = "IC"

	if(isturf(A) && !(sight & SEE_TURFS) && !(A in view(client ? client.view : world.view, src)))
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return

	if(is_blind()) //blind people see things differently (through touch)
		to_chat(src, SPAN_WARNING("Something is there but you can't see it!"))
		return

	face_atom(A)
	if(!isobserver(src) && !isturf(A) && (get_top_level_atom(A) != src) && get_turf(A))
		for(var/mob/M in viewers(4, src))
			if(M == src || M.is_blind())
				continue
			if(M.client && M.client.is_preference_enabled(/datum/client_preference/examine_look))
				to_chat(M, SPAN_TINYNOTICE("<b>\The [src]</b> looks at \the [A]."))

	var/list/result
	if(client)
		result = A.examine(src) // if a tree is examined but no client is there to see it, did the tree ever really exist?

	to_chat(src, "<blockquote class='info'>[result.Join("\n")]</blockquote>")
	SEND_SIGNAL(src, COMSIG_MOB_EXAMINATE, A)

/**
 * Point at an atom
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/pointed()
 *
 * note: ghosts can point, this is intended
 *
 * visible_message will handle invisibility properly
 *
 * overridden here and in /mob/dead/observer for different point span classes and sanity checks
 */
/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(14, src)))
		return 0
	if(istype(A, /obj/effect/decal/point))
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	var/obj/P = new /obj/effect/decal/point(tile)
	P.invisibility = invisibility
	P.plane = ABOVE_PLANE
	P.layer = FLY_LAYER
	P.pixel_x = A.pixel_x + world.icon_size * (x - A.x)
	P.pixel_y = A.pixel_y + world.icon_size * (y - A.y)
	animate(P, pixel_x = A.pixel_x, pixel_y = A.pixel_y, time = 0.5 SECONDS, easing = QUAD_EASING)
	QDEL_IN(P, 2 SECONDS)
	face_atom(A)
	log_emote("POINTED --> at [A] ([COORD(A)]).", src)
	return 1

/mob/verb/set_self_relative_layer()
	set name = "Set relative layer"
	set desc = "Set your relative layer to other mobs on the same layer as yourself"
	set src = usr
	set category = "IC"

	var/new_layer = input(src, "What do you want to shift your layer to? (-100 to 100)", "Set Relative Layer", clamp(relative_layer, -100, 100))
	new_layer = clamp(new_layer, -100, 100)
	set_relative_layer(new_layer)

/mob/verb/shift_relative_behind(mob/M as mob in get_relative_shift_targets())
	set name = "Move Behind"
	set desc = "Move behind of a mob with the same base layer as yourself"
	set src = usr
	set category = "IC"

	set_relative_layer(M.relative_layer - 1)

/mob/verb/shift_relative_infront(mob/M as mob in get_relative_shift_targets())
	set name = "Move Infront"
	set desc = "Move infront of a mob with the same base layer as yourself"
	set src = usr
	set category = "IC"

	set_relative_layer(M.relative_layer + 1)

/mob/proc/get_relative_shift_targets()
	. = list()
	var/us = isnull(base_layer)? layer : base_layer
	for(var/mob/M in range(1, src))
		if(M.plane != plane)
			continue
		if(us == (isnull(M.base_layer)? M.layer : M.base_layer))
			. += M
	. -= src

/mob/proc/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	return

/**
 * Verb to activate the object in your held hand
 *
 * Calls attack self on the item and updates the inventory hud for hands
 */
/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	return

/**
 * Get the notes of this mob
 *
 * This actually gets the mind datums notes
 */
/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/**
 * Add a note to the mind datum
 */
/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if((length(memory) + length(msg)) > MAX_MESSAGE_LEN)
		return

	if (length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if (popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)

	if(msg != null)
		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, "<span class='alert'>Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a></span>")

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return "<font color=#4F49AF>[msg]</font>"
		else
			return "<font color=#4F49AF>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</font></a>"

/*
/mob/verb/help()
	set name = "Help"
	src << browse('html/help.html', "window=help")
	return
*/

/mob/proc/set_respawn_timer(var/time)
	// Try to figure out what time to use

	// Special cases, can never respawn
	if(SSticker?.mode?.deny_respawn)
		time = -1
	else if(!config_legacy.abandon_allowed)
		time = -1
	else if(!config_legacy.respawn)
		time = -1

	// Special case for observing before game start
	else if(SSticker?.current_state <= GAME_STATE_SETTING_UP)
		time = 1 MINUTE

	// Wasn't given a time, use the config time
	else if(!time)
		time = config_legacy.respawn_time

	var/keytouse = ckey
	// Try harder to find a key to use
	if(!keytouse && key)
		keytouse = ckey(key)
	else if(!keytouse && mind?.key)
		keytouse = ckey(mind.key)

	GLOB.respawn_timers[keytouse] = world.time + time

/mob/observer/dead/set_respawn_timer()
	if(config_legacy.antag_hud_restricted && has_enabled_antagHUD)
		..(-1)
	else
		return 	// Don't set it, no need

/**
 * Allows you to respawn, abandoning your current mob
 *
 * This sends you back to the lobby creating a new dead mob
 *
 * Only works if flag/norespawn is allowed in config
 */
/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"
	set desc = "Return to the lobby."

	if(stat != DEAD)
		to_chat(usr, SPAN_BOLDNOTICE("You must be dead to use this!"))
		return

	// Final chance to abort "respawning"
	if(mind && timeofdeath)	// They had spawned before
		var/choice = alert(usr, "Returning to the menu will prevent your character from being revived in-round. Are you sure?", "Confirmation", "No, wait", "Yes, leave")
		if(choice == "No, wait")
			return

	// Beyond this point, you're going to respawn
	to_chat(usr, config_legacy.respawn_message)

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.mob.reload_rendering()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	announce_ghost_joinleave(client, 0)

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.mind)
		M.mind.reset()
	return

/**
 * Allows you to respawn, abandoning your current mob
 *
 * This sends you back to the lobby creating a new dead mob
 *
 * Doesn't require the config to be set.
 */
/mob/verb/return_to_menu()
	set name = "Return to Menu"
	set category = "OOC"
	set desc = "Return to the lobby."
	return abandon_mob()

/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"

	if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified))
		return
	else if(stat != DEAD || istype(src, /mob/new_player))
		to_chat(usr, "<font color=#4F49AF>You must be observing to use this!</font>")
		return

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	/*for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/singularity))
			var/name = "Singularity"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O
	*/

	for(var/mob/M in sortList(GLOB.mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	var/eye_name = null

	eye_name = input("Please, select a player!", "Observe", null, null) as null | anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	reset_perspective(mob_eye.get_perspective())

GLOBAL_VAR_INIT(exploit_warn_spam_prevention, 0)

//suppress the .click/dblclick macros so people can't use them to identify the location of items or aimbot
/mob/verb/DisClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".click"
	set hidden = TRUE
	set category = null
	if(GLOB.exploit_warn_spam_prevention < world.time)
		var/msg = "[key_name_admin(src)]([ADMIN_KICK(src)]) attempted to use the .click macro!"
		log_admin(msg)
		message_admins(msg)
		log_click("DROPPED: .click macro from [ckey] at [argu], [sec], [number1]. [number2]")
		GLOB.exploit_warn_spam_prevention = world.time + 10

/mob/verb/DisDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".dblclick"
	set hidden = TRUE
	set category = null
	if(GLOB.exploit_warn_spam_prevention < world.time)
		var/msg = "[key_name_admin(src)]([ADMIN_KICK(src)]) attempted to use the .dblclick macro!"
		log_admin(msg)
		message_admins(msg)
		log_click("DROPPED: .dblclick macro from [ckey] at [argu], [sec], [number1]. [number2]")
		GLOB.exploit_warn_spam_prevention = world.time + 10

/**
 * Topic call back for any mob
 *
 * * Unset machines if "mach_close" sent
 * * refresh the inventory of machines in range if "refresh" sent
 * * handles the strip panel equip and unequip as well if "item" sent
 */
/mob/Topic(href, href_list)
	if(href_list["strip"])
		var/op = href_list["strip"]
		handle_strip_topic(usr, href_list, op)
		return
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, replacetext(flavor_text, "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
//	..()
	return


/mob/proc/pull_damage()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.health - H.halloss <= config_legacy.health_threshold_softcrit)
			for(var/name in H.organs_by_name)
				var/obj/item/organ/external/e = H.organs_by_name[name]
				if(e && H.lying)
					if((e.status & ORGAN_BROKEN && (!e.splinted || (e.splinted && (e.splinted in e.contents) && prob(30))) || e.status & ORGAN_BLEEDING) && (H.getBruteLoss() + H.getFireLoss() >= 100))
						return 1
	return 0

/mob/OnMouseDrop(atom/over, mob/user, proximity, params)
	. = ..()
	if(over != user)
		return
	. |= mouse_drop_strip_interaction(user)

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Cyborg" || mind.assigned_role == "AI"))
		return 1
	return istype(src, /mob/living/silicon) || get_species_name() == "Machine"

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/get_gender()
	return gender

/mob/proc/get_visible_gender()
	return gender

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src, message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/**
 * Output an update to the stat panel for the client
 *
 * calculates client ping, round id, server time, time dilation and other data about the round
 * and puts it in the mob status panel on a regular loop
 */
/mob/Stat()
	..()

	//This is only called from client/Stat(), let's assume client exists.

	if(statpanel("Status"))
		//var/list/L = list()
		stat("Ping", "[round(client.lastping,1)]ms (Avg: [round(client.avgping,1)]ms)")
		//L += SSmapping.stat_map_name
		stat("Round ID", "[GLOB.round_id || "ERROR"]")
		// VIRGO START
		stat("Station Time", stationtime2text())
		stat("Station Date", stationdate2text())
		stat("Round Duration", roundduration2text())
		// VIRGO END
		stat("Time dilation", SStime_track.stat_time_text)
		//L += SSshuttle.emergency_shuttle_stat_text
		//stat(null, "[L.Join("\n\n")]")

	if(listed_turf && client)
		if(!TurfAdjacent(listed_turf))
			listed_turf = null
		else
			statpanel(listed_turf.name, null, listed_turf)
			var/list/overrides = list()
			for(var/image/I in client.images)
				if(I.loc && I.loc.loc == listed_turf && I.override)
					overrides += I.loc
			for(var/atom/A in listed_turf)
				if(!A.mouse_opacity)
					continue
				if(A.invisibility > see_invisible)
					continue
				if(overrides.len && (A in overrides))
					continue
/*
				if(A.IsObscured())
					continue
*/
				statpanel(listed_turf.name, null, A)

	if(client.holder)
		if(statpanel("MC"))
			var/turf/T = get_turf(client.eye)
			stat("Location:", COORD(T))
			stat("CPU:", "[world.cpu]")
			stat("Instances:", "[num2text(world.contents.len, 10)]")
			stat("World Time:", "[world.time]")
			stat("Real time of day:", REALTIMEOFDAY)
			GLOB.stat_entry()
			config.stat_entry()
			stat(null)
			if(Master)
				Master.stat_entry()
			else
				stat("Master Controller:", "ERROR")
			if(Failsafe)
				Failsafe.stat_entry()
			else
				stat("Failsafe Controller:", "ERROR")
			if(Master)
				stat(null)
				for(var/datum/controller/subsystem/SS in Master.subsystems)
					SS.stat_entry()
			//GLOB.GLOB.cameranet.stat_entry()
		if(statpanel("Tickets"))
			GLOB.ahelp_tickets.stat_entry()
		if(length(GLOB.sdql2_queries))
			if(statpanel("SDQL2"))
				stat("Access Global SDQL2 List", GLOB.sdql2_vv_statobj)
				for(var/i in GLOB.sdql2_queries)
					var/datum/SDQL2_query/Q = i
					Q.generate_stat()


/// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

/// This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return 0



/mob/proc/AdjustLosebreath(amount)
	losebreath = clamp(0, losebreath + amount, 25)

/mob/proc/SetLosebreath(amount)
	losebreath = clamp(0, amount, 25)

/mob/proc/get_species_name()
	return ""

/**
 * DO NOT USE THIS
 *
 * this should be phased out for get_species_id().
 */
/mob/proc/get_true_species_name()
	return ""

// todo: species vs subspecies
// /mob/proc/get_species_id()
// 	return

/mob/proc/flash_weak_pain()
	flick("weak_pain",pain)

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants(0)
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>")

	if(!do_after(U, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body.</b></span>","<span class='warning'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body.</b></span>")
	valid_objects = get_visible_implants(0)
	if(valid_objects.len == 1) //Yanking out last object - removing verb.
		src.verbs -= /mob/proc/yank_out_object

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/affected

		for(var/obj/item/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		H.shock_stage+=20
		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")

		if(prob(selection.w_class * 5) && (affected.robotic < ORGAN_ROBOT)) //I'M SO ANEMIC I COULD JUST -DIE-.
			var/datum/wound/internal_bleeding/I = new (min(selection.w_class * 5, 15))
			affected.wounds += I
			H.custom_pain("Something tears wetly in your [affected] as [selection] is pulled free!", 50)

		if (ishuman(U))
			var/mob/living/carbon/human/human_user = U
			human_user.bloody_hands(H)

	else if(issilicon(src))
		var/mob/living/silicon/robot/R = src
		R.embedded -= selection
		R.adjustBruteLoss(5)
		R.adjustFireLoss(10)

	selection.forceMove(get_turf(src))
	U.put_in_hands(selection)

	for(var/obj/item/O in pinned)
		if(O == selection)
			pinned -= O
		if(!pinned.len)
			anchored = 0
	return 1

/// Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple_mob/animal/borer))
			return I

	return 0

/mob/proc/updateicon()
	return

/// Please always use this proc, never just set the var directly.
/mob/proc/set_stat(var/new_stat)
	. = (stat != new_stat)
	stat = new_stat

/mob/verb/face_direction()

	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/mob/proc/set_face_dir(newdir)
	if(newdir)
		if(newdir == facing_dir)
			facing_dir = null
		else
			facing_dir = newdir
			setDir(newdir)
	else
		if(facing_dir)
			facing_dir = null
		else
			facing_dir = dir

/mob/setDir()
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

/mob/proc/isSynthetic()
	return 0

/mob/proc/is_muzzled()
	return 0

//Exploitable Info Update

/mob/proc/amend_exploitable(var/obj/item/I)
	if(istype(I))
		exploit_addons |= I
		var/exploitmsg = html_decode("\n" + "Has " + I.name + ".")
		exploit_record += exploitmsg

/client/proc/check_has_body_select()
	return mob && mob.hud_used && istype(mob.zone_sel, /atom/movable/screen/zone_sel)

/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1
	toggle_zone_sel(list(BP_HEAD, O_EYES, O_MOUTH))

/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_R_ARM,BP_R_HAND))

/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_L_ARM,BP_L_HAND))

/client/verb/body_chest()
	set name = "body-chest"
	set hidden = 1
	toggle_zone_sel(list(BP_TORSO))

/client/verb/body_groin()
	set name = "body-groin"
	set hidden = 1
	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_R_LEG,BP_R_FOOT))

/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_L_LEG,BP_L_FOOT))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(next_list_item(mob.zone_sel.selecting,zones))

// This handles setting the client's color variable, which makes everything look a specific color.
// This proc is here so it can be called without needing to check if the client exists, or if the client relogs.
// This is for inheritence since /mob/living will serve most cases. If you need ghosts to use this you'll have to implement that yourself.
/mob/proc/update_client_color()
	if(client && client.color)
		animate(client, color = null, time = 10)
	return

/mob/proc/swap_hand()
	return

/mob/proc/will_show_tooltip()
	if(alpha <= EFFECTIVE_INVIS)
		return FALSE
	return TRUE

/mob/MouseEntered(location, control, params)
	if(usr != src && usr.is_preference_enabled(/datum/client_preference/mob_tooltips) && src.will_show_tooltip())
		openToolTip(user = usr, tip_src = src, params = params, title = get_nametag_name(usr), content = get_nametag_desc(usr))

	..()

/mob/MouseDown()
	closeToolTip(usr) //No reason not to, really

	..()

/mob/MouseExited()
	closeToolTip(usr) //No reason not to, really

	..()

// Manages a global list of mobs with clients attached, indexed by z-level.
/mob/proc/update_client_z(new_z) // +1 to register, null to unregister.
	if(registered_z != new_z)
		if(registered_z)
			GLOB.players_by_zlevel[registered_z] -= src
		if(client)
			if(new_z)
				GLOB.players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/onTransitZ(old_z, new_z)
	..()
	update_client_z(new_z)

/mob/verb/local_diceroll(n as num)
	set name = "diceroll"
	set category = "OOC"
	set desc = "Roll a random number between 1 and a chosen number."

	n = round(n)		// why are you putting in floats??
	if(n < 2)
		to_chat(src, "<span class='warning'>[n] must be 2 or above, otherwise why are you rolling?</span>")
		return

	to_chat(src, "<span class='notice'>Diceroll result: <b>[rand(1, n)]</b></span>")

/**
 * Checks for anti magic sources.
 *
 * @params
 * - magic - wizard-type magic
 * - holy - cult-type magic, stuff chaplains/nullrods/similar should be countering
 * - chargecost - charges to remove from antimagic if applicable/not a permanent source
 * - self - check if the antimagic is ourselves
 *
 * @return The datum source of the antimagic
 */
/mob/proc/anti_magic_check(magic = TRUE, holy = FALSE, chargecost = 1, self = FALSE)
	if(!magic && !holy)
		return
	var/list/protection_sources = list()
	if(SEND_SIGNAL(src, COMSIG_MOB_RECEIVE_MAGIC, src, magic, holy, chargecost, self, protection_sources) & COMPONENT_MAGIC_BLOCKED)
		if(protection_sources.len)
			return pick(protection_sources)
		else
			return src
	if((magic && HAS_TRAIT(src, TRAIT_ANTIMAGIC)) || (holy && HAS_TRAIT(src, TRAIT_HOLY)))
		return src

/mob/drop_location()
	if(temporary_form)
		return temporary_form.drop_location()
	return ..()

/**
 * Returns whether or not we should be allowed to examine a target
 */
/mob/proc/allow_examine(atom/A)
	return client && (client.eye == src)

/// Checks for slots that are currently obscured by other garments.
/mob/proc/check_obscured_slots()
	return

//! Pixel Offsets
/mob/proc/get_buckled_pixel_x_offset()
	if(!buckled)
		return 0
	return buckled.get_centering_pixel_x_offset(NONE, src) - get_centering_pixel_x_offset() + buckled.buckle_pixel_x

/mob/proc/get_buckled_pixel_y_offset()
	if(!buckled)
		return 0
	return buckled.get_centering_pixel_y_offset(NONE, src) - get_centering_pixel_y_offset() + buckled.buckle_pixel_y

/mob/get_managed_pixel_x()
	return ..() + shift_pixel_x + get_buckled_pixel_x_offset()

/mob/get_managed_pixel_y()
	return ..() + shift_pixel_y + get_buckled_pixel_y_offset()

/mob/get_centering_pixel_x_offset(dir, atom/aligning)
	. = ..()
	. += shift_pixel_x

/mob/get_centering_pixel_y_offset(dir, atom/aligning)
	. = ..()
	. += shift_pixel_y

/mob/proc/reset_pixel_shifting()
	if(!shifted_pixels)
		return
	shifted_pixels = FALSE
	pixel_x -= shift_pixel_x
	pixel_y -= shift_pixel_y
	shift_pixel_x = 0
	shift_pixel_y = 0
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/set_pixel_shift_x(val)
	if(!val)
		return
	shifted_pixels = TRUE
	pixel_x += (val - shift_pixel_x)
	shift_pixel_x = val
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/set_pixel_shift_y(val)
	if(!val)
		return
	shifted_pixels = TRUE
	pixel_y += (val - shift_pixel_y)
	shift_pixel_y = val
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/adjust_pixel_shift_x(val)
	if(!val)
		return
	shifted_pixels = TRUE
	shift_pixel_x += val
	pixel_x += val
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/adjust_pixel_shift_y(val)
	if(!val)
		return
	shifted_pixels = TRUE
	shift_pixel_y += val
	pixel_y += val
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

//! Reachability
/mob/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE

/mob/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE
