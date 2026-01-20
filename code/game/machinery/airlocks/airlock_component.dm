//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * gasnet connected machinery
 */
/obj/machinery/airlock_component
	armor_type = /datum/armor/object/heavy

	/// conencted gasnet
	var/datum/airlock_gasnet/network
	/// connected interconnect
	var/obj/structure/airlock_interconnect/interconnect

/obj/machinery/airlock_component/Initialize(mapload)
	. = ..()
	join_interconnect()

/obj/machinery/airlock_component/Destroy()
	leave_interconnect()
	return ..()

/**
 * Called by the network when we join it.
 */
/obj/machinery/airlock_component/proc/on_connect(datum/airlock_gasnet/network)
	return

/**
 * Called by the network when we leave it.
 */
/obj/machinery/airlock_component/proc/on_disconnect(datum/airlock_gasnet/network)
	return

/obj/machinery/airlock_component/Moved(atom/old_loc, direction, forced, list/old_locs, momentum_change)
	..()
	if(loc == old_loc)
		return
	recheck_interconnect()

/obj/machinery/airlock_component/proc/join_interconnect()
	if(src.interconnect)
		return
	var/obj/structure/airlock_interconnect/maybe_int = locate() in loc
	if(!maybe_int)
		return
	maybe_int.connect_component(src)

/obj/machinery/airlock_component/proc/leave_interconnect()
	if(!interconnect)
		return
	interconnect.disconnect_component(src)

/obj/machinery/airlock_component/proc/recheck_interconnect()
	var/obj/structure/airlock_interconnect/maybe_int = locate() in loc
	if(maybe_int == src.interconnect)
		return
	if(src.interconnect)
		leave_interconnect()
	if(maybe_int)
		maybe_int.connect_component(src)

