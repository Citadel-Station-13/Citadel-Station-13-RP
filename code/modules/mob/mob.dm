/mob/Destroy()//This makes sure that mobs withGLOB.clients/keys are not just deleted from the game.
	GLOB.mob_list -= src
	dead_mob_list -= src
	living_mob_list -= src
	unset_machine()
	qdel(hud_used)
	clear_fullscreen()
	if(client)
		for(var/obj/screen/movable/spell_master/spell_master in spell_masters)
			qdel(spell_master)
		remove_screen_obj_references()
		client.screen = list()
	if(mind && mind.current == src)
		spellremove(src)
	ghostize()
	QDEL_NULL(plane_holder)
	..()
	return QDEL_HINT_HARDDEL_NOW

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

/mob/Initialize(mapload)
	GLOB.mob_list += src
	set_focus(src)
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src
	hook_vr("mob_new",list(src)) //VOREStation Code
	update_transform() // Some mobs may start bigger or smaller than normal.
	return ..()

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

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
				if ((type & 1) && (sdisabilities & BLIND))
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
  * Reset the attached clients perspective (viewpoint)
  *
  * reset_perspective() set eye to common default : mob on turf, loc otherwise
  * reset_perspective(thing) set the eye to the thing (if it's equal to current default reset to mob perspective)
  */
/mob/proc/reset_perspective(atom/A)
	if(client)
		if(A)
			if(ismovable(A))
				//Set the the thing unless it's us
				if(A != src)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else if(isturf(A))
				//Set to the turf unless it's our current turf
				if(A != loc)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else
				//Do nothing
		else
			//Reset to common defaults: mob if on turf, otherwise current loc
			if(isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		return 1

// Returns an amount of power drawn from the object (-1 if it's not viable).
// If drain_check is set it will not actually drain power, just return a value.
// If surge is set, it will destroy/damage the recipient and not return any power.
// Not sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge, var/amount = 0)
	return -1

// Show a message to all mobs and objects in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
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

/mob/proc/Life()
//	if(organStructure)
//		organStructure.ProcessOrgans()
	return

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_blind()
	return ((sdisabilities & BLIND) || blinded || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_deaf()
	return ((sdisabilities & DEAF) || ear_deaf || incapacitated(INCAPACITATION_KNOCKOUT))

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

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
	return


/mob/proc/show_inv(mob/user as mob)
	return

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view()) //It used to be oview(12), but I can't really say why
	set name = "Examine"
	set category = "IC"

	if(isturf(A) && !(sight & SEE_TURFS) && !(A in view(client ? client.view : world.view, src)))
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return

	if(is_blind()) //blind people see things differently (through touch)
		return

	face_atom(A)
	if(!isobserver(src) && !isturf(A) && A != src)
		if(A.loc != src)
			for(var/mob/M in viewers(4, src))
				if(M == src || M.is_blind())
					continue
				if(M.client && M.client.is_preference_enabled(/datum/client_preference/examine_look))
					to_chat(M, "<span class='tinynotice'><b>\The [src]</b> looks at \the [A].</span>")

	var/list/result
	if(client)
		result = A.examine(src) // if a tree is examined but no client is there to see it, did the tree ever really exist?

	to_chat(src, result.Join("\n"))

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(src.loc)))
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
	P.pixel_x = A.pixel_x
	P.pixel_y = A.pixel_y
	QDEL_IN(P, 2 SECONDS)
	face_atom(A)
	return 1


/mob/proc/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	return

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	return

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

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
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)	//VOREStation Edit: separating out OOC notes

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
			return "<font color='blue'>[msg]</font>"
		else
			return "<font color='blue'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</font></a>"

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

/mob/verb/abandon_mob()
	set name = "Return to Menu"
	set category = "OOC"

	if(stat != DEAD || !SSticker)
		to_chat(usr, "<span class='notice'><B>You must be dead to use this!</B></span>")
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
	client.screen += client.void
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

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	getFiles(
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/map-pencil.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		SScharacter_setup.queue_preferences_save(prefs)
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "background-color=none;font-style=;")

/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || istype(src, /mob/new_player))
		to_chat(usr, "<font color='blue'>You must be observing to use this!</font>")
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
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

	for(var/mob/M in sortList(GLOB.mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = input("Please, select a player!", ok, null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)

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
		GLOB.exploit_warn_spam_prevention = world.time + 10

/mob/verb/DisDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".dblclick"
	set hidden = TRUE
	set category = null
	if(GLOB.exploit_warn_spam_prevention < world.time)
		var/msg = "[key_name_admin(src)]([ADMIN_KICK(src)]) attempted to use the .dblclick macro!"
		log_admin(msg)
		message_admins(msg)
		GLOB.exploit_warn_spam_prevention = world.time + 10


/mob/Topic(href, href_list)
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

/mob/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(usr.incapacitated(INCAPACITATION_STUNNED | INCAPACITATION_FORCELYING | INCAPACITATION_KNOCKOUT | INCAPACITATION_RESTRAINED)) return //Incapacitated.
	if(istype(M,/mob/living/silicon/ai)) return
	show_inv(usr)

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Cyborg" || mind.assigned_role == "AI"))
		return 1
	return istype(src, /mob/living/silicon) || get_species() == "Machine"

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

/mob/Stat()
	..()

	//This is only called from client/Stat(), let's assume client exists.

	if(statpanel("Status"))
		//var/list/L = list()
		stat("Ping", "[round(client.lastping,1)]ms (Avg: [round(client.avgping,1)]ms)")
		//L += SSmapping.stat_map_name
		//L += "Round ID: [GLOB.round_id || "NULL"]"
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
			//GLOB.cameranet.stat_entry()
		if(statpanel("Tickets"))
			GLOB.ahelp_tickets.stat_entry()
		if(length(GLOB.sdql2_queries))
			if(statpanel("SDQL2"))
				stat("Access Global SDQL2 List", GLOB.sdql2_vv_statobj)
				for(var/i in GLOB.sdql2_queries)
					var/datum/SDQL2_query/Q = i
					Q.generate_stat()


// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()
	return canmove

//This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_canmove()	//can you guess what this does yet?
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Confuse(amount)
	confused = max(max(confused,amount),0)
	return

/mob/proc/SetConfused(amount)
	confused = max(amount,0)
	return

/mob/proc/AdjustConfused(amount)
	confused = max(confused + amount,0)
	return

/mob/proc/Blind(amount)
	eye_blind = max(max(eye_blind,amount),0)
	return

/mob/proc/SetBlinded(amount)
	eye_blind = max(amount,0)
	return

/mob/proc/AdjustBlinded(amount)
	eye_blind = max(eye_blind + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	update_canmove()
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	update_canmove()
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	update_canmove()
	return

/mob/proc/AdjustLosebreath(amount)
	losebreath = clamp(0, losebreath + amount, 25)

/mob/proc/SetLosebreath(amount)
	losebreath = clamp(0, amount, 25)

/mob/proc/get_species()
	return ""

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

mob/proc/yank_out_object()
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

//Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple_mob/animal/borer))
			return I

	return 0

/mob/proc/updateicon()
	return

/mob/verb/face_direction()

	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/mob/proc/set_face_dir(var/newdir)
	if(newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		setDir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		setDir(dir)
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

/mob/verb/eastshift()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_x <= 16)
		pixel_x++
		is_shifted = TRUE

/mob/verb/westshift()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_x >= -16)
		pixel_x--
		is_shifted = TRUE

/mob/verb/northshift()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_y <= 16)
		pixel_y++
		is_shifted = TRUE

/mob/verb/southshift()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_y >= -16)
		pixel_y--
		is_shifted = TRUE

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

// Set client view distance (size of client's screen). Returns TRUE if anything changed.
/mob/proc/set_viewsize(var/new_view = world.view)
	if (client && new_view != client.view)
		client.view = new_view
		return TRUE
	return FALSE

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon) //in case we don't have the HUD and we use the hotkey
		src.throw_icon.icon_state = "act_throw_off"

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

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
	return mob && mob.hud_used && istype(mob.zone_sel, /obj/screen/zone_sel)

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
	var/obj/screen/zone_sel/selector = mob.zone_sel
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

//Throwing stuff
/mob/proc/throw_item(atom/target)
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
