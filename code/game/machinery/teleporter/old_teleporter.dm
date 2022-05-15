//Keeping this temporarily incase I forgot to add something.

/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	circuit = /obj/item/circuitboard/teleporter
	dir = 4
	var/obj/machinery/teleport/station/station = null
	var/obj/machinery/teleport/hub/hub = null
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/Initialize(mapload)
	id = "[rand(1000, 9999)]"
	. = ..()

	// Search surrounding turfs for the station, and then search the station's surrounding turfs for the hub.
	for(var/direction in GLOB.cardinal)
		station = locate(/obj/machinery/tele_projector, get_step(src, direction))
		if(station)
			for(direction in GLOB.cardinal)
				hub = locate(/obj/machinery/tele_pad, get_step(station, direction))
				if(hub)
					break
			break

	if(istype(station))
		station.com = hub
		station.setDir(dir)

	if(istype(hub))
		hub.com = src
		hub.setDir(dir)

/obj/machinery/computer/teleporter/examine(mob/user)
	. = ..()
	if(locked)
		var/turf/T = get_turf(locked)
		to_chat(user, SPAN_NOTICE("The console is locked on to \[[T.loc.name]\]."))


/obj/machinery/computer/teleporter/attackby(I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/card/data/))
		var/obj/item/card/data/C = I
		if(machine_stat & (NOPOWER|BROKEN) & (C.function != "teleporter"))
			attack_hand()

		var/obj/L = null

		for(var/atom/movable/landmark/sloc in GLOB.landmarks_list)
			if(sloc.name != C.data) continue
			if(locate(/mob/living) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype

		if(istype(L, /atom/movable/landmark/) && istype(L.loc, /turf))
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen, reminding the user that the nuclear authentication disk is not transportable via insecure means.")
			user.drop_item()
			qdel(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='warning'>Incoming bluespace portal detected, unable to lock in.</span>", 2)

				for(var/obj/machinery/teleport/hub/H in range(1))
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

/obj/machinery/teleport/station/attack_ai()
	attack_hand()

/obj/machinery/computer/teleporter/attack_hand(user as mob)
	if(..()) return

	/* Ghosts can't use this one because it's a direct selection */
	if(istype(user, /mob/observer/dead)) return

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

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L|null
	if(!desc)
		return
	if(get_dist(src, usr) > 1 && !issilicon(usr))
		return

	locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message(SPAN_NOTICE("Locked In"), 2)
	return

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

/proc/find_loc(obj/R as obj)
	if(!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE
	anchored = TRUE
	var/lockeddown = FALSE

/obj/machinery/teleport/hub
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "pad"
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_hub
	var/obj/machinery/computer/teleporter/com
	light_color = "#02d1c7"

/obj/machinery/teleport/hub/Initialize(mapload)
	. = ..()
	default_apply_parts()
	RefreshParts()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/teleport/hub/LateInitialize()
	. = ..()
	update_icon()

/obj/machinery/teleport/hub/on_update_icon()
	cut_overlays()
	if(com?.station?.engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		add_overlay(I)
		set_light(0.4, 1.2, 4, 10)
	else
		set_light(0)
		if (operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			add_overlay(I)

/obj/machinery/teleport/hub/Bumped(M as mob|obj)
	if(com?.station?.engaged)
		teleport(M)
		use_power_oneoff(5000)

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	if(!com)
		return
	if(!com.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_WARNING("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
		return
	do_teleport(M, com.locked)
	if(com.one_time_use) //Make one-time-use cards only usable one time!
		com.one_time_use = FALSE
		com.locked = null
		if(com.station)
			com.station.engaged = FALSE
		update_icon()
	return

/obj/machinery/teleport/hub/Destroy()
	com = null
	return ..()

/obj/machinery/teleport/station
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon_state = "station"
	var/engaged = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_station
	var/obj/machinery/teleport/hub/com

/obj/machinery/teleport/station/Initialize(mapload)
	. = ..()
	for(var/target_dir in GLOB.cardinal)
		var/obj/machinery/teleport/hub/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			setDir(get_dir(src, found_pad))
			break
	update_icon()

/obj/machinery/teleport/station/on_update_icon()
	. = ..()
	cut_overlays()
	if(engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
	else if(operable())
		var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
	default_apply_parts()
	RefreshParts()

/obj/machinery/teleport/station/attackby(var/obj/item/W)
	attack_hand()

/obj/machinery/teleport/station/attack_ai()
	attack_hand()

/obj/machinery/teleport/station/attack_hand()
	if(engaged)
		disengage()
	else
		engage()

/obj/machinery/teleport/station/proc/engage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = TRUE
	update_icon()
	if(com)
		hub.update_icon()
		use_power(5000)
		update_use_power(USE_POWER_ACTIVE)
		com.update_use_power(USE_POWER_ACTIVE)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter engaged!"), 2)
	add_fingerprint(usr)
	return

/obj/machinery/teleport/station/proc/disengage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = FALSE
	update_icon()
	if(com)
		hub.update_icon()
		com.update_use_power(USE_POWER_IDLE)
		update_use_power(USE_POWER_IDLE)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter disengaged!"), 2)
	add_fingerprint(usr)
	return

/atom/proc/laserhit(L as obj)
	return TRUE
