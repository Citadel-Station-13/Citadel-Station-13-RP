//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/airlock_component
	name = "airlock component"
	desc = "A detached component for a modular airlock."
	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = WEIGHT_VOLUME_SMALL

	var/machine_type = /obj/machinery/airlock_component

/obj/item/airlock_component/Initialize(mapload, set_dir, obj/machinery/airlock_component/from_machine)
	if(set_dir)
		setDir(set_dir)
	return ..()

/obj/item/airlock_component/proc/create_machine(atom/location) as /obj/machinery/airlock_component
	return new machine_type(location, src.dir, src)

/obj/item/airlock_component/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = list()
	.[TOOL_WRENCH] = list(
		"install",
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/item/airlock_component/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(isturf(target))
		if(clickchain.performer.transfer_item_to_loc(src, target))
			clickchain.chat_feedback(SPAN_NOTICE("You place down [src]."), target = src)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/airlock_component/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	if(!isturf(loc))
		e_args.chat_feedback(
			SPAN_WARNING("[src] must be on the floor to be attached."),
			target = src,
		)
		return TRUE
	for(var/obj/machinery/airlock_component/comp in loc)
		if(istype(comp, machine_type))
			e_args.chat_feedback(
				SPAN_WARNING("There's already another component of the same type on [loc]."),
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
	for(var/obj/machinery/airlock_component/comp in loc)
		if(istype(comp, machine_type))
			e_args.chat_feedback(
				SPAN_WARNING("There's already another component of the same type on [loc]."),
				target = src,
			)
			return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] wrenches down [src]."),
		otherwise_self = SPAN_NOTICE("You wrench down [src]."),
	)
	var/obj/machinery/airlock_component/comp = new machine_type(loc, dir, src)
	log_construction(e_args, src, "secured at [COORD(loc)] into [ref(comp)]")
	qdel(src)

/**
 * gasnet connected machinery
 */
/obj/machinery/airlock_component
	armor_type = /datum/armor/object/heavy
	hides_underfloor = OBJ_UNDERFLOOR_UNLESS_PLACED_ONTOP

	/// conencted gasnet
	var/datum/airlock_gasnet/network
	/// connected interconnect
	var/obj/structure/airlock_interconnect/interconnect
	/// item type
	var/detached_item_type = /obj/item/airlock_component
	/// hardmapped?
	var/hardmapped = FALSE

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

/obj/machinery/airlock_component/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = list()
	.[TOOL_WRENCH] = list(
		"uninstall",
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/machinery/airlock_component/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
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

	var/obj/item/airlock_component/detached = new detached_item_type(loc, dir, src)
	log_construction(e_args, src, "detached into [ref(detached)]")
	qdel(src)
