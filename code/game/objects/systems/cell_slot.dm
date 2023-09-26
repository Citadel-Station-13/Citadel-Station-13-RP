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
	var/inducer = FALSE

#warn impl all
