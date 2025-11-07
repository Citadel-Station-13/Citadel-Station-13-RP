//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * cell slot
 */
/datum/object_system/cell_slot
	/// held cell
	var/obj/item/cell/cell
	/// reserved - cell type accepted enum, for when we do large/medium/small/etc cells later.
	var/cell_type

	/// considered primary? if so, we get returned on get_cell()
	var/primary = TRUE

	/// allow inducer?
	var/receive_inducer = FALSE
	/// allow EMPs to hit?
	var/receive_emp = FALSE
	/// allow explosions to hit cell?
	// todo: currently unused; probably kill this eventually
	var/recieve_explosion = FALSE

	/// allow quick removal by clicking with hand?
	var/remove_yank_offhand = FALSE
	/// allow context menu removal?
	var/remove_yank_context = FALSE
	/// allow quick removal by using in hand?
	var/remove_yank_inhand = FALSE
	/// no-tool time for removal, if any
	var/remove_yank_time = 0
	/// tool behavior for removal, if any

	var/remove_tool_behavior = null
	/// tool time for removal, if any
	var/remove_tool_time = 0

	/// removal / insertion is discrete or loud
	var/remove_is_discrete = TRUE

	/// legacy
	// todo: kill this
	var/legacy_use_device_cells = FALSE

/**
 * returns TRUE if slot accepts this type of cell
 */
/datum/object_system/cell_slot/proc/accepts_cell(obj/item/cell/cell)
	return legacy_use_device_cells? istype(cell, /obj/item/cell/device) : TRUE

// TODO: user_remove_cell && user_insert_cell
// TODO: play sound please & visible message

/**
 * removes cell from the system and drops it at new_loc
 */
/datum/object_system/cell_slot/proc/remove_cell(atom/new_loc)
	if(isnull(cell))
		return
	. = cell
	if(cell.loc != new_loc)
		cell.forceMove(new_loc)
	cell = null
	parent.object_cell_slot_removed(., src)

/**
 * helper to have a mob yank a cell
 *
 * * this does not check adjacency!
 * * puts the cell in their hand if possible, otherwise drops it on them
 */
/datum/object_system/cell_slot/proc/mob_yank_cell(mob/user)
	var/obj/item/cell/removed = remove_cell(user)
	if(!removed)
		return
	user.put_in_hands_or_drop(removed)
	return removed

/**
 * replaces the existing cell with the inserted cell, dropping the old cell
 */
/datum/object_system/cell_slot/proc/insert_cell(obj/item/cell/cell)
	if(!isnull(cell))
		. = remove_cell(parent.drop_location())
	src.cell = cell
	if(cell.loc != parent)
		cell.forceMove(parent)
	parent.object_cell_slot_inserted(cell, src)

/**
 * returns TRUE if the cell slot is mutable
 */
/datum/object_system/cell_slot/proc/interaction_active(mob/user)
	return parent.object_cell_slot_mutable(user, src)

/**
 * returns TRUE if the slot has a cell
 */
/datum/object_system/cell_slot/proc/has_cell()
	return !isnull(cell)

//? Hooks

/**
 * hook called on cell slot removal
 */
/obj/proc/object_cell_slot_removed(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	return

/**
 * hook called on cell slot insertion
 */
/obj/proc/object_cell_slot_inserted(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	return

/**
 * hook called to check if cell slot removal behavior is active
 */
/obj/proc/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return TRUE

//? Lazy wrappers for init

/obj/proc/init_cell_slot(initial_cell_path)
	RETURN_TYPE(/datum/object_system/cell_slot)
	ASSERT(isnull(obj_cell_slot))
	obj_cell_slot = new(src)
	if(initial_cell_path)
		// The first cell intentionally doesn't call wrappers.
		obj_cell_slot.cell = new initial_cell_path
	return obj_cell_slot

/obj/proc/init_cell_slot_easy_tool(initial_cell_path, offhand_removal = TRUE, inhand_removal = FALSE)
	RETURN_TYPE(/datum/object_system/cell_slot)
	if(isnull(init_cell_slot(initial_cell_path)))
		return
	if(offhand_removal)
		obj_cell_slot.remove_yank_offhand = TRUE
	if(inhand_removal)
		obj_cell_slot.remove_yank_inhand = FALSE
	obj_cell_slot.remove_yank_context = TRUE
	obj_cell_slot.remove_yank_time = 0
	obj_cell_slot.legacy_use_device_cells = TRUE
	return obj_cell_slot

//? Wrappers for cell.dm functions
//+ These exist to sanely perform cell functions through the obj_cell_slot system. These break safely if no cell exists.

/**
 * cell function wrapper - returns the rating of the cell inside or 0 if null
 */
/datum/object_system/cell_slot/proc/get_rating()
	return cell?.get_rating() || 0

/**
 * cell function wrapper - returns the cell src or FALSE if null
 */
/datum/object_system/cell_slot/proc/get_cell(inducer)
	return cell?.get_cell(inducer) || FALSE

/**
 * cell function passthrough - consumes energy using *universal units*
 *
 * *Uses universal units.*
 *
 * @params
 * - actor - thing draining, can be null
 * - amount - amount to drain in kilojoules
 * - flags
 *
 * @return Amount drained
 */
/datum/object_system/cell_slot/proc/drain_energy(datum/actor, amount, flags)
	return cell?.drain_energy(actor, amount, flags) || 0

/**
 * cell function wrapper - returns % charge of the cell or 0 if null
 */
/datum/object_system/cell_slot/proc/percent()
	return cell?.percent() || 0

/**
 * cell function wrapper - checks if cell is fully charged
 * returns TRUE or FALSE. returns FALSE if cell is null
 */
/datum/object_system/cell_slot/proc/fully_charged()
	return cell?.fully_charged() ? TRUE : FALSE

/**
 * cell function wrapper - returns true if cell can provide specified amount
 * returns 0 if null
 */
/datum/object_system/cell_slot/proc/check_charge(var/amount)
	return cell?.check_charge(amount) || 0

/**
 * cell function wrapper - returns how much charge is missing from the cell or 0 if null
 */
/datum/object_system/cell_slot/proc/amount_missing()
	return cell?.amount_missing() || 0

/**
 * cell function wrapper - attempts to use power from cell, returns the amount actually used or 0 if null
 */
/datum/object_system/cell_slot/proc/use(var/amount)
	return cell?.use(amount) || 0

/**
 * cell function wrapper - checks if the specified amount can be provided. If it can, it removes the amount from the cell and returns TRUE otherwise does nothing and returns FALSE
 * returns FALSE if cell is null
 */
/datum/object_system/cell_slot/proc/checked_use(amount, reserve)
	return cell?.checked_use(amount, reserve) ? TRUE : FALSE

/**
 * cell function wrapper - recharge the cell by x amount returns the amount consumed or 0 if cell is null
 */
/datum/object_system/cell_slot/proc/give(var/amount)
	return cell?.give(amount) || 0
//? End wrappers for cell.dm functions
