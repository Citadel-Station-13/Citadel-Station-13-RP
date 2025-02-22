//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * while /datum/shuttle_template describes the physical shuttle, this describes features
 * like mass.
 */
/datum/shuttle_descriptor
	//* Flight (overmaps / web) *//
	/// mass in kilotons
	//  todo: in-game mass calculations? only really relevant for drone tbh
	var/mass = 5
	/// if set to false, this is absolute-ly unable to land on a planet
	var/allow_atmospheric_landing = TRUE
	/// preferred flight orientation
	///
	/// * null = use orientation at takeoff
	var/preferred_orientation

	//* Jumps (ferry & moving to/from overmaps) *//
	/// engine charging time when starting a move
	//  todo: should have support for being based on in game machinery (?)
	var/jump_charging_time = 10 SECONDS
	/// time spent in transit when performing a move
	var/jump_move_time = 10 SECONDS

/datum/shuttle_descriptor/clone()
	var/datum/shuttle_descriptor/clone = ..()

	clone.mass = mass
	clone.allow_atmospheric_landing = allow_atmospheric_landing
	clone.preferred_orientation = preferred_orientation

	clone.jump_charging_time = jump_charging_time
	clone.jump_move_time = jump_move_time
