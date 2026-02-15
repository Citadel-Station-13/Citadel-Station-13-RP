//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Object system but for machines.
 */
/datum/machinery_system
	abstract_type = /datum/machinery_system

	/// owning object
	var/obj/machinery/parent

/datum/machinery_system/New(obj/machinery/parent)
	src.parent = parent

/datum/machinery_system/Destroy()
	parent = null
	return ..()
