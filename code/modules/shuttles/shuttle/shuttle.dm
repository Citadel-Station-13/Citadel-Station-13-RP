//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * the shuttle datum
 */
/datum/shuttle
	/// real / code name
	var/name = "Unnamed Shuttle"

	/// our shuttle controller
	var/datum/shuttle_controller/controller
	/// our physical shuttle object
	var/obj/shuttle_anchor/master/anchor
	/// our physical shuttle port objects
	var/list/obj/shuttle_anchor/port/ports
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	/// are we mid-delete? controls whether we, and our components are immune to deletion.
	var/being_deleted = FALSE

#warn impl all
