//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/airlock_component
	name = "airlock component"
	desc = "A detached component for a modular airlock."
	#warn impl all
	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = WEIGHT_VOLUME_SMALL

	var/machine_type = /obj/machinery/airlock_component

/obj/item/airlock_component/Initialize(mapload, set_dir, obj/machinery/airlock_component/from_machine)
	if(set_dir)
		setDir(set_dir)
	return ..()

/obj/item/airlock_component/proc/create_machine(atom/location) as /obj/machinery/airlock_component
	return new machine_type(location, src.dir, src)

/**
 * gasnet connected machinery
 */
/obj/machinery/airlock_component
	armor_type = /datum/armor/object/heavy

	/// conencted gasnet
	var/datum/airlock_gasnet/network
	/// connected interconnect
	var/obj/structure/airlock_interconnect/interconnect
	/// item type
	#warn impl all
	var/detached_item_type = /obj/item/airlock_component

/obj/machinery/airlock_component/Initialize(mapload, set_dir, obj/item/airlock_component/from_item)
	if(set_dir)
		setDir(set_dir)
	. = ..()
	join_interconnect()

/obj/machinery/airlock_component/Destroy()
	leave_interconnect()
	return ..()

/obj/machinery/airlock_component/proc/create_detached(atom/location) as /obj/item
	return new detached_item_type(location, src.dir, src)

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

#warn detaches/reattaches; disallow detaching INDESTRUCTIBLE ones for now
