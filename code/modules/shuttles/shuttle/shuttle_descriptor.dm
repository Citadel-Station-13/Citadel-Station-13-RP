//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * while /datum/shuttle_template describes the physical shuttle, this describes features
 * like mass.
 */
/datum/shuttle_descriptor
	//* Flight (overmaps / web)
	/// mass in kilotons
	//  todo: in-game mass calculations? only really relevant for drone tbh
	var/mass = 5
	/// if set to false, this is absolute-ly unable to land on a planet
	var/allow_atmospheric_landing = TRUE

	//* Jumps (ferry & moving to/from overmaps)
	/// engine charging time when starting a move
	//  todo: should have support for being based on in game machinery (?)
	var/jump_charging_time = 10 SECONDS
	/// time spent in transit when performing a move
	var/jump_move_time = 10 SECONDS

/datum/shuttle_descriptor/clone(include_contents)
	var/datum/shuttle_descriptor/clone = ..()
	
	clone.mass = mass
	clone.allow_atmospheric_landing = allow_atmospheric_landing

	clone.jump_charging_time = jump_charging_time
	clone.jump_move_time = jump_move_time
