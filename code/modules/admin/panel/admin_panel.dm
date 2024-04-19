//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Unified admin panel implementation.
 */
/datum/admin_panel
	/// our name
	var/name = "Admin Panel"
	/// panes; set to list of typepaths to init.
	var/list/datum/admin_pane/panes = list()

#warn *SCREAM
