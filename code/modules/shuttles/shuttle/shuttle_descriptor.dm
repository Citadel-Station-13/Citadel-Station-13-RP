//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * while /datum/shuttle_template describes the physical shuttle, this describes features
 * like mass.
 *
 * * When a shuttle template is loaded, this is cloned into the shuttle datum.
 */
/datum/shuttle_descriptor
	//* Flight (overmaps / web) *//
	/// mass in tons
	//  todo: in-game mass calculations? only really relevant for drone tbh
	var/mass = 10000
	/// if set to false, this is absolute-ly unable to land on a planet
	var/allow_atmospheric_landing = TRUE
	/// preferred flight orientation
	///
	/// * null = use orientation at takeoff
	var/preferred_orientation

	//* Jumps (ferry & moving to/from overmaps) *//
	/// engine charging time when starting a move
	//  todo: should have support for being based on in game machinery (?)
	var/jump_charging_time = 5 SECONDS
	/// time spent in transit when performing a move
	var/jump_move_time = 5 SECONDS

	//* Overmaps *//
	#warn impl all
	var/overmap_icon
	var/overmap_icon_state
	var/overmap_icon_color = "#4cad73" //Greyish green
	#warn impl
	// legacy because sensor update will change how this works
	var/overmap_legacy_start_unknown = TRUE
	// Legacy because sensor update will get rid of hard-coded names.
	var/overmap_legacy_name
	// Legacy because sensor update will get rid of hard-coded scan results.
	#warn is this desc?
	var/overmap_legacy_desc
	// Legacy because sensor update will get rid of hard-coded scan results
	// * defaults to name
	var/overmap_legacy_scan_name
	// Legacy because sensor update will get rid of hard-coded scan results
	// * defaults to desc
	var/overmap_legacy_scan_desc

/datum/shuttle_descriptor/clone()
	var/datum/shuttle_descriptor/clone = ..()

	clone.mass = mass
	clone.allow_atmospheric_landing = allow_atmospheric_landing
	clone.preferred_orientation = preferred_orientation

	clone.jump_charging_time = jump_charging_time
	clone.jump_move_time = jump_move_time

	return clone
