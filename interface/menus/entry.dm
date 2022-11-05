GLOBAL_LIST_EMPTY(menu_entry_by_type)

/**
 * must be singleton
 */
/datum/interface_menu_entry
	//! intrinsics
	var/name
	var/command
	var/checked
	var/checkbox
	var/group
	var/index

	//! automatically set - don't touch these
	var/parent

/datum/interface_menu_entry/New()

/datum/interface_menu_entry/Destroy()


/datum/interface_menu_entry/skin_id()
	return "[type]"

/datum/interface_menu_entry/proc/pressed(client/C)

/client/verb/menu_entry_pressed(id as text)
	set name = ".menu_entry_pressed"
	set hidden = TRUE
