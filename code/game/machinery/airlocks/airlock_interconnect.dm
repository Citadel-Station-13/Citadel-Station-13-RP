//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/item/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	#warn sprite

/obj/item/airlock_interconnect/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = list()
	.[TOOL_WRENCH] = list(
		"install",
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/item/airlock_interconnect/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/obj/item/airlock_interconnect/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return

#warn impl

/obj/structure/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	#warn sprite

	/// our pipenet
	var/datum/airlock_gasnet/network
	/// components; lazy list
	var/list/obj/machinery/airlock_component/components
	/// rebuild queued
	var/rebuild_queued = FALSE
	/// connected directions
	/// * built during network build
	/// * cleared on network destruction
	/// * update icon only fires off on network build to save CPU
	var/connected_dirs

/obj/structure/airlock_interconnect/Initialize(mapload)
	. = ..()
	queue_rebuild()
	join_all_components_on_tile()

/obj/structure/airlock_interconnect/Destroy()
	qdel(network)
	for(var/obj/machinery/airlock_component/component as anything in components)
		disconnect_component(component)
	return ..()

/obj/structure/airlock_interconnect/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(loc == old_loc)
		return
	for(var/obj/machinery/airlock_component/component as anything in components)
		disconnect_component(component)
	qdel(network)
	join_all_components_on_tile()
	queue_rebuild()

/obj/structure/airlock_interconnect/proc/rebuild()
	rebuild_queued = FALSE
	if(QDELETED(src))
		return
	qdel(network)
	new /datum/airlock_gasnet(src)

/obj/structure/airlock_interconnect/proc/rebuild_if_needed()
	rebuild_queued = FALSE
	if(network)
		return
	rebuild()

/obj/structure/airlock_interconnect/proc/queue_rebuild()
	if(rebuild_queued)
		return
	rebuild_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(rebuild_if_needed)), 0)

/obj/structure/airlock_interconnect/proc/join_all_components_on_tile()
	for(var/obj/machinery/airlock_component/component in loc)
		if(!component.interconnect)
			connect_component(component)

/obj/structure/airlock_interconnect/proc/connect_component(obj/machinery/airlock_component/component)
	if(component.interconnect)
		component.interconnect.disconnect_component(component)
	#warn impl

/obj/structure/airlock_interconnect/proc/disconnect_component(obj/machinery/airlock_component/component)
	#warn impl

/obj/structure/airlock_interconnect/proc/get_adjacent_interconnects()
	. = list()
	for(var/obj/structure/airlock_interconnect/int in loc)
		if(int == src)
			continue
		. += int
	for(var/dir in GLOB.cardinal)
		var/turf/int_t = get_step(src, dir)
		if(!int_t)
			continue
		for(var/obj/structure/airlock_interconnect/int in int_t)
			. += int
