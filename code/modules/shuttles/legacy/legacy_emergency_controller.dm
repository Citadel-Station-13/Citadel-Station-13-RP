GLOBAL_DATUM(legacy_emergency_shuttle_controller, /datum/shuttle_controller/ferry/emergency)

/datum/shuttle_controller/ferry/emergency
	var/round_end_armed = FALSE

/datum/shuttle_controller/ferry/emergency/on_transit_begin(obj/shuttle_dock/dock, redirected)
	. = ..()
	SSemergencyshuttle.launch_time = world.time

/datum/shuttle_controller/ferry/emergency/on_begin_transit_to_home()
	. = ..()

	if(!round_end_armed)
		return

	spawn(0)
			SSemergencyshuttle.departed = 1
			var/estimated_time = round(SSemergencyshuttle.estimate_arrival_time()/60,1)

			if (SSemergencyshuttle.evac)
				priority_announcement.Announce(replacetext(replacetext((LEGACY_MAP_DATUM).emergency_shuttle_leaving_dock, "%dock_name%", "[(LEGACY_MAP_DATUM).dock_name]"),  "%ETA%", "[estimated_time] minute\s"))
			else
				priority_announcement.Announce(replacetext(replacetext((LEGACY_MAP_DATUM).shuttle_leaving_dock, "%dock_name%", "[(LEGACY_MAP_DATUM).dock_name]"),  "%ETA%", "[estimated_time] minute\s"))

// /datum/shuttle_controller/ferry/emergency/on_successful_transit_to_away()
// 	. = ..()

// 	if(!round_end_armed)
// 		return

// 	SSemergencyshuttle.shuttle_arrived()

// /datum/shuttle_controller/ferry/emergency/on_successful_transit_to_home()
// 	. = ..()

// 	if(!round_end_armed)
// 		return

// #warn impl

// Formerly /datum/shuttle/autodock/ferry/emergency
// /datum/shuttle/autodock/ferry/emergency

// /datum/shuttle/autodock/ferry/emergency/can_launch(var/user)
// 	if (istype(user, /obj/machinery/computer/shuttle_control))
// 		var/obj/machinery/computer/shuttle_control/C = user
// 		if (!C.has_authorization())
// 			return 0
// 	return ..()

// /datum/shuttle/autodock/ferry/emergency/can_force(var/user)
// 	if (istype(user, /obj/machinery/computer/shuttle_control))
// 		var/obj/machinery/computer/shuttle_control/C = user

// 		// Initiating or cancelling a launch ALWAYS requires authorization, but if we are already set to launch anyways than forcing does not.
// 		// This is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
// 		if (!(process_state == WAIT_LAUNCH || C.has_authorization()))
// 			return 0
// 	return ..()

// /datum/shuttle/autodock/ferry/emergency/can_cancel(var/user)
// 	if (istype(user, /obj/machinery/computer/shuttle_control))
// 		var/obj/machinery/computer/shuttle_control/C = user
// 		if (!C.has_authorization())
// 			return 0
// 	return ..()

// /datum/shuttle/autodock/ferry/emergency/launch(var/user)
// 	if (!can_launch(user)) return

// 	if (istype(user, /obj/machinery/computer/shuttle_control))	// If we were given a command by an emergency shuttle console
// 		if (SSemergencyshuttle.autopilot)
// 			SSemergencyshuttle.autopilot = 0
// 			to_chat(world, "<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Launch sequence initiated!</b></span>")

// 	if(usr)
// 		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and activated the launch sequence.")
// 		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and activated the launch sequence.")

// 	..(user)

// /datum/shuttle/autodock/ferry/emergency/force_launch(var/user)
// 	if (!can_force(user)) return

// 	if (istype(user, /obj/machinery/computer/shuttle_control))	// If we were given a command by an emergency shuttle console
// 		if (SSemergencyshuttle.autopilot)
// 			SSemergencyshuttle.autopilot = 0
// 			to_chat(world, "<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!</b></span>")

// 	if(usr)
// 		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and forced immediate launch.")
// 		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and forced immediate launch.")

// 	..(user)

// /datum/shuttle/autodock/ferry/emergency/cancel_launch(var/user)
// 	if (!can_cancel(user)) return

// 	if (istype(user, /obj/machinery/computer/shuttle_control))	// If we were given a command by an emergency shuttle console
// 		if (SSemergencyshuttle.autopilot)
// 			SSemergencyshuttle.autopilot = 0
// 			to_chat(world, "<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Launch sequence aborted!</b></span>")

// 	if(usr)
// 		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and cancelled the launch sequence.")
// 		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and cancelled the launch sequence.")

// 	..(user)



// /obj/machinery/computer/shuttle
// 	name = "Shuttle"
// 	desc = "For shuttle control."
// 	icon_keyboard = "tech_key"
// 	icon_screen = "shuttle"
// 	light_color = "#00ffff"
// 	var/auth_need = 3
// 	var/list/authorized = list(  )

// #warn deal with this wtf

// /obj/machinery/computer/shuttle/attackby(obj/item/card/W, mob/user)
// 	if(machine_stat & (BROKEN|NOPOWER))
// 		return
// 	if((!( istype(W, /obj/item/card) ) || !( SSticker ) || SSemergencyshuttle.location() || !( user )))
// 		return
// 	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
// 		if(istype(W, /obj/item/pda))
// 			var/obj/item/pda/pda = W
// 			W = pda.id
// 		if(!W:access) //no access
// 			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
// 			return

// 		var/list/cardaccess = W:access
// 		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
// 			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
// 			return

// 		if(!(ACCESS_COMMAND_BRIDGE in W:access)) //doesn't have this access
// 			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
// 			return 0

// 		var/choice = alert(user, "Would you like to (un)authorize a shortened launch time? [auth_need - authorized.len] authorization\s are still needed. Use abort to cancel all authorizations.", "Shuttle Launch", "Authorize", "Repeal", "Abort")
// 		if(SSemergencyshuttle.location() && user.get_active_held_item() != W)
// 			return 0
// 		switch(choice)
// 			if("Authorize")
// 				src.authorized -= W:registered_name
// 				src.authorized += W:registered_name
// 				if (src.auth_need - src.authorized.len > 0)
// 					message_admins("[key_name_admin(user)] has authorized early shuttle launch")
// 					log_game("[user.ckey] has authorized early shuttle launch")
// 					to_chat(world, "<span class='notice'><b>Alert: [auth_need - authorized.len] authorizations needed until shuttle is launched early</b></span>")
// 				else
// 					message_admins("[key_name_admin(user)] has launched the shuttle")
// 					log_game("[user.ckey] has launched the shuttle early")
// 					to_chat(world, "<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
// 					SSemergencyshuttle.set_launch_countdown(10 SECONDS)
// 					//src.authorized = null
// 					qdel(src.authorized)
// 					src.authorized = list(  )

// 			if("Repeal")
// 				src.authorized -= W:registered_name
// 				to_chat(world, SPAN_BOLDNOTICE("Alert: [auth_need - authorized.len] authorizations needed until shuttle is launched early"))

// 			if("Abort")
// 				to_chat(world, "<span class='notice'><b>All authorizations to shortening time for shuttle launch have been revoked!</b></span>")
// 				src.authorized.len = 0
// 				src.authorized = list(  )

// 	else if (istype(W, /obj/item/card/emag) && !emagged)
// 		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")

// 		if(!emagged && !SSemergencyshuttle.location() && user.get_active_held_item() == W)
// 			switch(choice)
// 				if("Launch")
// 					to_chat(world, "<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
// 					SSemergencyshuttle.set_launch_countdown(10 SECONDS)
// 					emagged = 1
// 				if("Cancel")
// 					return
// 	return

// /obj/machinery/computer/shuttle_control
// 	shuttle_tag = "Escape"
// 	var/debug = 0
// 	var/req_authorizations = 2
// 	var/list/authorized = list()

// /obj/machinery/computer/shuttle_control/proc/has_authorization()
// 	return (authorized.len >= req_authorizations || emagged)

// /obj/machinery/computer/shuttle_control/proc/reset_authorization()
// 	// No need to reset emagged status. If they really want to go back to the station they can.
// 	authorized = initial(authorized)

// // Returns 1 if the ID was accepted and a new authorization was added, 0 otherwise
// /obj/machinery/computer/shuttle_control/proc/read_authorization(var/obj/item/ident)
// 	if (!ident || !istype(ident))
// 		return 0
// 	if (authorized.len >= req_authorizations)
// 		return 0	// Don't need any more

// 	var/list/access
// 	var/auth_name
// 	var/dna_hash

// 	var/obj/item/card/id/ID = ident.GetID()

// 	if(!ID)
// 		return

// 	access = ID.access
// 	auth_name = "[ID.registered_name] ([ID.assignment])"
// 	dna_hash = ID.dna_hash

// 	if (!access || !istype(access))
// 		return 0	// Not an ID

// 	if (dna_hash in authorized)
// 		src.visible_message("\The [src] buzzes. That ID has already been scanned.")
// 		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
// 		return 0

// 	if (!(ACCESS_COMMAND_BRIDGE in access))
// 		src.visible_message("\The [src] buzzes, rejecting [ident].")
// 		playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
// 		return 0

// 	src.visible_message("\The [src] beeps as it scans [ident].")
// 	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
// 	authorized[dna_hash] = auth_name
// 	if (req_authorizations - authorized.len)
// 		to_chat(world, "<span class='notice'><b>Alert: [req_authorizations - authorized.len] authorization\s needed to override the shuttle autopilot.</b></span>") //TODO- Belsima, make this an announcement instead of magic.

// 	if(usr)
// 		log_admin("[key_name(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")
// 		message_admins("[key_name_admin(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")

// 	return 1

// /obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user)
// 	if (!emagged)
// 		to_chat(user, "<span class='notice'>You short out \the [src]'s authorization protocols.</span>")
// 		emagged = 1
// 		return 1

// /obj/machinery/computer/shuttle_control/attackby(obj/item/W as obj, mob/user as mob)
// 	read_authorization(W)
// 	..()
