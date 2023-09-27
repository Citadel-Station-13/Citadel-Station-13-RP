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
	#warn hook below
	/// allow inducer?
	var/receive_inducer = FALSE
	/// allow EMPs to hit?
	var/receive_emp = FALSE
	/// allow quick removal by clicking with hand?
	var/remove_yank_offhand = FALSE
	/// allow context menu removal?
	var/remove_yank_context = FALSE
	/// no-tool time for removal, if any
	var/remove_yank_time = 0
	/// tool behavior for removal, if any
	var/remove_tool_behavior = null
	/// tool time for removal, if any
	var/remove_tool_time = 0
	#warn hook above
	/// allow explosions to hit cell?
	// todo: currently unused
	var/recieve_explosion = FALSE
	/// legacy
	// todo: kill this
	var/legacy_use_device_cells = FALSE

/datum/object_system/cell_slot/proc/accepts_cell(obj/item/cell/cell)
	return legacy_use_device_cells? istype(cell, /obj/item/cell/device) : TRUE

/datum/object_system/cell_slot/proc/remove_cell(atom/new_loc)
	if(isnull(cell))
		return
	. = cell
	cell = null
	if(cell.loc != new_loc)
		cell.forceMove(new_loc)
	parent.object_cell_slot_removed(., src)

/datum/object_system/cell_slot/proc/insert_cell(obj/item/cell/cell)
	if(!isnull(cell))
		. = remove_cell(parent.drop_location())
	src.cell = cell
	if(cell.loc != parent)
		cell.forceMove(parent)
	parent.object_cell_slot_inserted(cell, src)

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

//? Lazy wrappers for init

/obj/proc/init_cell_slot_easy_tool(offhand_removal = TRUE)
	ASSERT(isnull(object_cell_slot))
	object_cell_slot = new(src)
	if(offhand_removal)
		object_cell_slot.remove_yank_offhand = TRUE
	object_cell_slot.remove_yank_context = TRUE
	object_cell_slot.remove_yank_time = 0
	object_cell_slot.legacy_use_device_cells = TRUE
