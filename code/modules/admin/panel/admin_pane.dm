//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * A pane used in a panel.
 *
 * This is a top-level element and its own 'topic'
 *
 * Examples:
 *
 * * shuttles is its own pane under game panel as it's a self-contained component
 * * controls is its own pane under game panel, but has nested components like 'round finales', etc.
 */
/datum/admin_pane
	/// our name
	var/name = "???"
	/// sections; set to list of typepaths to init.
	/// set to null to not use section system.
	var/list/datum/admin_section/sections

#warn *SCREAM
