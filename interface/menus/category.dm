/**
 * must be
 */
/datum/interface_menu_category
	//! intrinsics
	var/name
	var/entry_type

	//! automatically set; don't touch these
	var/parent

/datum/interface_menu_category/skin_id()
	return "[type]"
