/datum/interface_menu
	//! intrinsics
	/// id to use
	var/id = SKIN_MENU_ID_MAIN
	/// what category type to instantiate - we only instantiate subtypes of this
	var/category_type

	/// list of stuff to build for clients/windows
	var/list/entries = list()

/datum/interface_menu/New()
	build()

/datum/interface_menu/proc/build()
	if(type == /datum/interface_menu)
		CRASH("tried to build abstract root of menu types")

/datum/interface_menu/skin_id()
	return "[type]"

#warn oh god
