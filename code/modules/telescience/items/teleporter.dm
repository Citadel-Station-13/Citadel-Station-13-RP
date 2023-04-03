/*
 * Hand-tele
 */
/obj/item/hand_tele
	name = "hand tele"
	desc = "A portable item using blue-space technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(MAT_STEEL = 10000)
	preserve_item = 1

/obj/item/hand_tele/attack_self(mob/user)
	. = ..()
	if(.)
		return
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location || (current_location.z in GLOB.using_map.admin_levels) || current_location.block_tele)//If turf was not found or they're on z level 2 or >7 which does not currently exist.
		to_chat(user, "<span class='notice'>\The [src] is malfunctioning.</span>")
		return
	var/list/L = list(  )
	for(var/obj/machinery/tele_pad/R in GLOB.machines)
		var/obj/machinery/computer/teleporter/com
		var/obj/machinery/tele_projector/station
		for(var/direction in GLOB.cardinal)
			station = locate(/obj/machinery/tele_projector, get_step(R, direction))
			if(station)
				for(direction in GLOB.cardinal)
					com = locate(/obj/machinery/computer/teleporter, get_step(station, direction))
					if(com)
						break
				break
		// if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
		// 	if(R.icon_state == "tele1")
		// 		L["[com.id] (Active)"] = com.locked
		// 	else
		// 		L["[com.id] (Inactive)"] = com.locked
	var/list/turfs = list(	)
	for(var/turf/T in orange(10))
		if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)	continue
		if(T.block_tele) continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if ((user.get_active_held_item() != src || user.stat || user.restrained()))
		return
	var/count = 0	//num of portals from this teleport in world
	for(var/obj/effect/portal/PO in GLOB.all_portals)
		if(PO.creator == src)	count++
	if(count >= 3)
		user.show_message("<span class='notice'>\The [src] is recharging!</span>")
		return
	var/T = L[t1]
	for(var/mob/O in hearers(user, null))
		O.show_message("<span class='notice'>Locked In.</span>", 2)
	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	src.add_fingerprint(user)
	return
