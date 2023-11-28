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
	// todo: currently unused
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

/datum/object_system/cell_slot/proc/accepts_cell(obj/item/cell/cell)
	return legacy_use_device_cells? istype(cell, /obj/item/cell/device) : TRUE

/datum/object_system/cell_slot/proc/remove_cell(atom/new_loc)
	if(isnull(cell))
		return
	. = cell
	if(cell.loc != new_loc)
		cell.forceMove(new_loc)
	cell = null
	parent.object_cell_slot_removed(., src)

/datum/object_system/cell_slot/proc/insert_cell(obj/item/cell/cell)
	if(!isnull(cell))
		. = remove_cell(parent.drop_location())
	src.cell = cell
	if(cell.loc != parent)
		cell.forceMove(parent)
	parent.object_cell_slot_inserted(cell, src)

/datum/object_system/cell_slot/proc/interaction_active(mob/user)
	return parent.object_cell_slot_mutable(user, src)

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
