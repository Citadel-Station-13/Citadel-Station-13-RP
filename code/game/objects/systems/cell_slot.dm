//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * cell slot
 */
/datum/object_system/cell_slot
	//* State *//
	/// held cell
	var/obj/item/cell/cell

	//* Config - Interaction *//

	/// allow insertion via context menu
	var/insert_via_context = FALSE
	/// allow insertion via click
	var/insert_via_usage = FALSE
	/// insertion time
	//  TODO: impl
	var/insert_time = 0

	/// allow quick removal by clicking with hand?
	var/remove_yank_offhand = FALSE
	/// allow context menu removal?
	var/remove_yank_context = FALSE
	/// allow quick removal by using in hand?
	var/remove_yank_inhand = FALSE
	/// no-tool time for removal, if any
	//  TODO: impl
	var/remove_yank_time = 0

	/// tool behavior for removal, if any
	var/remove_tool_behavior = null
	/// tool time for removal, if any
	var/remove_tool_time = 0
	/// allow remove hooks in tool act
	var/remove_tool_usage = FALSE
	/// allow remove hooks in context menu for tooled removal
	var/remove_tool_context = FALSE

	/// removal / insertion is discrete or loud
	var/remove_is_discrete = TRUE

	//* Config - Defense *//
	/// allow EMPs to hit?
	var/receive_emp = FALSE
	/// allow explosions to hit cell?
	// todo: currently unused
	var/recieve_explosion = FALSE

	//* Config - Integration *//
	/// allow inducer?
	var/receive_inducer = FALSE
	/// considered primary? if so, we get returned on get_cell()
	var/primary = TRUE

	//* Config - Cell Accept *//
	/// cell types accepted
	var/cell_type = NONE

	//* Config - Sound *//
	var/insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/insert_sound_vol = 55
	var/insert_sound_vary = FALSE
	var/remove_sound = 'sound/weapons/empty.ogg'
	var/remove_sound_vol = 55
	var/remove_sound_vary = FALSE

/datum/object_system/cell_slot/Destroy()
	QDEL_NULL(cell)
	return ..()

/**
 * returns TRUE if slot accepts this type of cell
 */
/datum/object_system/cell_slot/proc/accepts_cell(obj/item/cell/cell)
	. = cell.cell_type & cell_type
	. = parent.object_cell_slot_accepts(cell, src, ., null, null)

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
 * @return TRUE success, FALSE otherwise
 */
/datum/object_system/cell_slot/proc/insert_cell(obj/item/cell/cell)
	if(!isnull(src.cell))
		remove_cell(parent.drop_location())
		ASSERT(!src.cell)
	src.cell = cell
	if(cell.loc != parent)
		cell.forceMove(parent)
	parent.object_cell_slot_inserted(cell, src)
	return TRUE

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

//* Interaction Wrappers *//

/datum/object_system/cell_slot/proc/user_insert_cell(obj/item/cell/cell, mob/user, silent, datum/event_args/actor/actor)
	. = insert_cell(cell)
	if(!.)
		return
	on_user_insert_cell(cell, user, silent, actor)

/datum/object_system/cell_slot/proc/user_remove_cell(atom/newloc, mob/user, silent, datum/event_args/actor/actor) as /obj/item/cell
	. = remove_cell(newloc)
	if(!.)
		return
	on_user_remove_cell(., user, silent, actor)

/datum/object_system/cell_slot/proc/on_user_insert_cell(obj/item/cell, mob/user, silent, datum/event_args/actor/actor)
	if(!silent)
		if(insert_sound)
			playsound(parent, insert_sound, insert_sound_vol, insert_sound_vary)

/datum/object_system/cell_slot/proc/on_user_remove_cell(obj/item/cell, mob/user, silent, datum/event_args/actor/actor)
	if(!silent)
		if(remove_sound)
			playsound(parent, remove_sound, remove_sound_vol, remove_sound_vary)

//? Hooks

/**
 * hook called on cell slot removal
 *
 * @params
 * * cell - the cell
 * * slot - the cell slot
 * * silent - (optional) don't emit messages / sounds
 * * actor - (optional) who's doing it
 */
/obj/proc/object_cell_slot_removed(obj/item/cell/cell, datum/object_system/cell_slot/slot, silent, datum/event_args/actor/actor)
	return

/**
 * hook called on cell slot insertion
 *
 * @params
 * * cell - the cell
 * * slot - the cell slot
 * * silent - (optional) don't emit messages / sounds
 * * actor - (optional) who's doing it
 */
/obj/proc/object_cell_slot_inserted(obj/item/cell/cell, datum/object_system/cell_slot/slot, silent, datum/event_args/actor/actor)
	return

/**
 * hook called to check if cell slot removal behavior is active
 *
 * @params
 * * cell - the cell
 * * slot - the cell slot
 * * silent - (optional) don't emit messages / sounds
 * * actor - (optional) who's doing it
 *
 * @return truthy/falsy value (not necessarily 0 / 1)
 */
/obj/proc/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot, silent, datum/event_args/actor/actor)
	return TRUE

/**
 * @params
 * * cell - the cell
 * * slot - (optional) the cell slot
 * * slot_opinion - (optional) what default checks returned
 * * silent - (optional) don't emit messages / sounds
 * * actor - (optional) who's doing it
 *
 * @return truthy/falsy value (not necessarily 0 / 1)
 */
/obj/proc/object_cell_slot_accepts(obj/item/cell/cell, datum/object_system/cell_slot/slot, slot_opinion, silent, datum/event_args/actor/actor)
	return slot_opinion

//? Lazy wrappers for init

/**
 * Creates a cell slot
 *
 * * This proc will error if it cannot detect a cell type, nor a preload to detect it from.
 * * Also sets the cell slot as primary.
 *
 * @params
 * * preload_path - (optional) cell typepath to start with
 * * cell_type - (optional) CELL_TYPE_* bitfield, of cell types to accept; defaults to preload_path's type if it exists and this isn't provided.
 */
/obj/proc/init_cell_slot(preload_path, cell_type)
	RETURN_TYPE(/datum/object_system/cell_slot)
	ASSERT(isnull(obj_cell_slot))
	obj_cell_slot = new(src)
	if(preload_path)
		obj_cell_slot.cell = new preload_path
		if(isnull(cell_type))
			cell_type = obj_cell_slot.cell_type
	else if(isnull(cell_type))
		stack_trace("failed to provide a cell type accept bitfield, and didn't provide a preload path to autodetect from")
	obj_cell_slot.cell_type = cell_type
	obj_cell_slot.primary = TRUE
	return obj_cell_slot

/**
 * Wrapper for lazily initializing a cell slot for tools.
 * * Also sets the cell slot as primary.
 */
/obj/proc/init_cell_slot_easy_tool(preload_path, cell_type = CELL_TYPE_SMALL | CELL_TYPE_MEDIUM, offhand_removal = TRUE, inhand_removal = FALSE) as /datum/object_system/cell_slot
	if(isnull(init_cell_slot(preload_path, cell_type)))
		return
	obj_cell_slot.insert_via_context = TRUE
	obj_cell_slot.insert_via_usage = TRUE
	if(offhand_removal)
		obj_cell_slot.remove_yank_offhand = TRUE
	if(inhand_removal)
		obj_cell_slot.remove_yank_inhand = FALSE
	obj_cell_slot.remove_yank_context = TRUE
	obj_cell_slot.remove_yank_time = 0
	return obj_cell_slot

/**
 * Wrapper for lazily initializing a cell slot for machines.
 * * Also sets the cell slot as primary.
 *
 * @params
 * * skip_interactions - do not automatically handle interactions
 * * require_remove_tool - tool behavior required for removal; defaults to none (context menu works)
 * * require_context_menu - require context menu interaction even if we require a tool behavior.
 *                          useful to not collide with other tool behaviors.
 */
/obj/proc/init_cell_slot_easy_machine(
	preload_path,
	cell_type = CELL_TYPE_SMALL | CELL_TYPE_WEAPON | CELL_TYPE_MEDIUM,
	skip_interactions,
	require_remove_tool,
	require_context_menu,
) as /datum/object_system/cell_slot
	if(isnull(init_cell_slot(preload_path, cell_type)))
		return
	if(!skip_interactions)
		// insertion
		if(!require_context_menu)
			obj_cell_slot.insert_via_usage = TRUE
		obj_cell_slot.insert_via_context = TRUE
		// removal
		if(require_remove_tool)
			obj_cell_slot.remove_tool_behavior = require_remove_tool
			if(!require_context_menu)
				obj_cell_slot.remove_tool_usage = TRUE
			obj_cell_slot.remove_tool_context = TRUE
		else
			obj_cell_slot.remove_yank_context = TRUE
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
