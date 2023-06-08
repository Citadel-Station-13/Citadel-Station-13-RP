/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation Pad and Projector."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	circuit = /obj/item/circuitboard/teleporter
	var/obj/machinery/tele_projector/projector = null
	var/obj/machinery/tele_pad/pad = null
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/Initialize(mapload)
	id = "[rand(1000, 9999)]"
	. = ..()

	// Search surrounding turfs for the projector, and then search the projector's surrounding turfs for the pad.
	for(var/direction in GLOB.cardinal)
		projector = locate(/obj/machinery/tele_projector, get_step(src, direction))
		if(projector)
			for(direction in GLOB.cardinal)
				pad = locate(/obj/machinery/tele_pad, get_step(projector, direction))
				if(pad)
					break
			break

	if(istype(projector))
		projector.pad = pad
		projector.setDir(dir)

	if(istype(pad))
		pad.com = src
		pad.setDir(dir)

/obj/machinery/computer/teleporter/examine(mob/user)
	. = ..()
	if(locked)
		var/turf/T = get_turf(locked)
		to_chat(user, SPAN_NOTICE("The console is locked on to \[[T.loc.name]\]."))

/obj/machinery/computer/teleporter/attackby(I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/card/data))
		var/obj/item/card/data/C = I
		if(machine_stat & (NOPOWER|BROKEN) & (C.function != "teleporter"))
			attack_hand()

		var/obj/L = null

		for(var/obj/landmark/sloc in GLOB.landmarks_list)
			if(sloc.name != C.data) continue
			if(locate(/mob/living) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype

		if(istype(L, /obj/landmark) && istype(L.loc, /turf))
			if(!user.attempt_consume_item_for_construction(I))
				return
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen, reminding the user that the nuclear authentication disk is not transportable via insecure means.")

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='warning'>Incoming bluespace portal detected, unable to lock in.</span>", 2)

				for(var/obj/machinery/tele_pad/H in range(1))
					var/amount = rand(2,5)
					for(var/i=0;i<amount;i++)
						new /mob/living/simple_mob/animal/space/carp(get_turf(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_message(SPAN_NOTICE("Locked In"), 2)
				locked = L
				one_time_use = TRUE

			add_fingerprint(usr)
	else
		..()

	return

/obj/machinery/computer/teleporter/attack_hand(mob/user, list/params)
	ui_interact(user)

/obj/machinery/computer/teleporter/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TeleporterConsole", name) // 500, 800
		ui.open()

/obj/machinery/computer/teleporter/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = list()
	var/list/vis_destinations = list()
	for(var/A in generate_telebeacon_list())
		vis_destinations += A

	data["disabled"] = is_disabled()
	data["locked"] = locked?.loc.loc.name || "None!"
	data["teleporterid"] = id
	data["projector_charge"] = projector?.current_joules || 0
	data["projector_charge_max"] = projector?.power_capacity || 0
	data["projector_recharge_rate"] = projector?.recharge_rate || 0
	data["projector_recharge_max"] = projector?.recharge_capacity || 0
	data["valid_destinations"] = vis_destinations
	return data

/obj/machinery/computer/teleporter/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("set_destination")
			for(var/obj/item/T in generate_telebeacon_list())
				if (T.name == params["new_locked"])
					set_destination(T)

		if("set_recharge")
			var/target = params["target"]
			projector?.recharge_rate = target
			projector?.recharge_rate = clamp(projector?.recharge_rate, 0, projector?.recharge_capacity)
	. = ..()

/obj/machinery/computer/teleporter/proc/is_disabled()
	if (!(pad||projector))
		return TRUE
	return FALSE

/obj/machinery/computer/teleporter/proc/generate_telebeacon_list()

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/radio/beacon/R in GLOB.all_beacons)
		var/turf/T = get_turf(R)
		if(!T)
			continue
		if(!(T.z in GLOB.using_map.player_levels))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/obj/item/implant/tracking/I in GLOB.all_tracking_implants)
		if(!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if(M.stat == 2)
				if(M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = get_turf(M)
			if(!T)
				continue
			if(!(T.z in GLOB.using_map.player_levels))
				continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I
	return L

/obj/machinery/computer/teleporter/proc/set_destination(var/obj/destination)
	if(get_dist(src, usr) > 1 && !issilicon(usr))
		return

	locked = destination
	for(var/mob/O in hearers(src, null))
		O.show_message(SPAN_NOTICE("Locked In"), 2)

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(machine_stat & (NOPOWER|BROKEN) || !istype(usr,/mob/living))
		return
	if(t)
		id = t
	return

/proc/find_loc(obj/R)
	if(!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T
