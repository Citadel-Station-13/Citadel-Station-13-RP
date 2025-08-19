//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * re-implementation of virgo's PAT module
 * TODO: mechanic to restrain this to certain accesses (shouldn't work on offmaps)
 * TODO: mechanic to disable this via networks / station mainframe
 * TODO: for now this only works on doors but this can be expanded, maybe.
 * TODO: intelligent screentips system should support this when that's made
 */
/obj/item/access_tunneler
	name = "access tunneler"
	desc = "Used by medical staff aboard some facilities to override access locks in times of need \
	with pre-encoded keys. This will alert the security team when used. "

	/// starting cell type
	var/starting_cell_type

	/// charge cost for overrides in kj
	var/energy_cost = 100 // 50 cell units

	/// allow door-likes
	var/allow_doors = TRUE

	/// weakref memory by expiration; recently overridden entities will not use more power
	/// * lazy list
	var/list/active_cache

#warn impl

/obj/item/access_tunneler/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// we check down below but let's type filter anyways
	if(allow_doors && istype(target, /obj/machinery/door))
		access_override(target, clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/access_tunneler/proc/access_override(atom/target, datum/event_args/actor/actor, silent)
	if(istype(target, /obj/machinery/door))
		return access_override_door(target, actor, silent)
	// TODO: probably emit a message if it's a machine instead of silently ignoring it
	return FALSE

/obj/item/access_tunneler/proc/access_override_door(obj/machinery/door/door, datum/event_args/actor/actor, silent)

/obj/item/access_tunneler/proc/has_energy_for(atom/target)

/obj/item/access_tunneler/proc/use_energy(amount)

/obj/item/access_tunneler/with_cell
	var/starting_cell_type = /obj/item/cell/device

#warn impl
