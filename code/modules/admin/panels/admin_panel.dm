//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_INIT(admin_panels, init_admin_panels())

/proc/init_admin_panels()
	. = list()
	GLOB.admin_panels = .
	#warn impl

/**
 * Unified admin panel implementation.
 */
/datum/admin_panel
	/// our name
	var/name = "Admin Panel"

#warn *SCREAM
