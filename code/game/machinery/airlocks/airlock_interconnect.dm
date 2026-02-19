//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// todo: buildable

/obj/item/stack/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	icon = 'icons/machinery/airlocks/airlock_interconnect.dmi'
	icon_state = "conduit-item"
	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = WEIGHT_VOLUME_SMALL
	max_amount = 30

/obj/item/stack/airlock_interconnect/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = list()
	.[TOOL_WRENCH] = list(
		"install",
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/item/stack/airlock_interconnect/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(isturf(target))
		if(amount <= 1 && clickchain.performer.transfer_item_to_loc(src, target))
			clickchain.chat_feedback(SPAN_NOTICE("You place down [src]."), target = src)
		else if(amount > 1 && split(1, target))
			clickchain.chat_feedback(SPAN_NOTICE("You place down [src]."), target = src)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/stack/airlock_interconnect/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	if(!isturf(loc))
		e_args.chat_feedback(
			SPAN_WARNING("[src] must be on the floor to be attached."),
			target = src,
		)
		return TRUE
	if(locate(/obj/structure/airlock_interconnect) in loc)
		e_args.chat_feedback(
			SPAN_WARNING("There's already another interconnect on [loc]."),
			target = src,
		)
		return TRUE
	if(!use_wrench(I, e_args, flags, 0, 1, TOOL_USAGE_BUILDING_FRAMEWORK | TOOL_USAGE_CONSTRUCT))
		return TRUE
	if(!isturf(loc))
		e_args.chat_feedback(
			SPAN_WARNING("[src] must be on the floor to be attached."),
			target = src,
		)
		return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] wrenches down [src]."),
		otherwise_self = SPAN_NOTICE("You wrench down [src]."),
	)
	log_construction(e_args, src, "secured at [COORD(loc)]")
	new /obj/structure/airlock_interconnect(loc)
	use(1)

/obj/structure/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	icon = 'icons/machinery/airlocks/airlock_interconnect.dmi'
	icon_state = "conduit-map"

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
	/// hardmapped?
	/// * hardmapped interconnects may not connect to non-hardmapped interconnects.
	var/hardmapped = FALSE

/obj/structure/airlock_interconnect/Initialize(mapload)
	. = ..()
	queue_rebuild()
	join_all_components_on_tile()

/obj/structure/airlock_interconnect/Destroy()
	qdel(network)
	for(var/obj/machinery/airlock_component/component as anything in components)
		disconnect_component(component)
	return ..()

/obj/structure/airlock_interconnect/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = list()
	.[TOOL_WRENCH] = list(
		"uninstall",
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/structure/airlock_interconnect/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	if(hardmapped)
		e_args.chat_feedback(
			SPAN_WARNING("[src] cannot be deconstructed; it is hard-wired into the floor."),
			target = src,
		)
		return TRUE

	if(!use_wrench(I, e_args, flags, 2 SECONDS, 1, TOOL_USAGE_BUILDING_FRAMEWORK | TOOL_USAGE_DECONSTRUCT))
		return FALSE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] detaches [src] from the floor."),
		otherwise_self = SPAN_NOTICE("You detach [src] from the floor."),
	)

	log_construction(e_args, src, "deconstructed")
	new /obj/item/stack/airlock_interconnect(loc)
	qdel(src)

/obj/structure/airlock_interconnect/update_icon()
	. = ..()
	icon_state = "conduit-[connected_dirs]"

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
	LAZYADD(components, component)
	network?.add_machine(component)

/obj/structure/airlock_interconnect/proc/disconnect_component(obj/machinery/airlock_component/component)
	LAZYREMOVE(components, component)
	network?.remove_machine(component)

/obj/structure/airlock_interconnect/proc/get_adjacent_interconnects()
	. = list()
	for(var/obj/structure/airlock_interconnect/int in loc)
		if(int == src)
			continue
		if(hardmapped != int.hardmapped)
			continue
		. += int
	var/new_connected_dirs = NONE
	for(var/dir in GLOB.cardinal)
		var/turf/int_t = get_step(src, dir)
		if(!int_t)
			continue
		for(var/obj/structure/airlock_interconnect/int in int_t)
			if(hardmapped != int.hardmapped)
				continue
			. += int
			new_connected_dirs |= dir
	if(new_connected_dirs != connected_dirs)
		connected_dirs = new_connected_dirs
		update_icon()

/obj/structure/airlock_interconnect/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
