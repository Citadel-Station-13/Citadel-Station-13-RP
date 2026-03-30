//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * while /datum/shuttle_template describes the physical shuttle, this describes features
 * like mass.
 *
 * * When a shuttle template is loaded, this is cloned into the shuttle datum.
 */
/datum/shuttle_descriptor
	//* Identity *//
	/// The name used on areas and other player-facing things.
	/// * Defaults to shuttle name if unset.
	var/display_name

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

	clone.display_name = src.display_name

	clone.mass = src.mass
	clone.allow_atmospheric_landing = src.allow_atmospheric_landing
	clone.preferred_orientation = src.preferred_orientation

	clone.jump_charging_time = src.jump_charging_time
	clone.jump_move_time = src.jump_move_time

	clone.overmap_icon = src.overmap_icon
	clone.overmap_icon_state = src.overmap_icon_state
	clone.overmap_icon_color = src.overmap_icon_color
	clone.overmap_legacy_start_unknown = src.overmap_legacy_start_unknown
	clone.overmap_legacy_name = src.overmap_legacy_name
	clone.overmap_legacy_desc = src.overmap_legacy_desc
	clone.overmap_legacy_scan_name = src.overmap_legacy_scan_name
	clone.overmap_legacy_scan_desc = src.overmap_legacy_scan_desc

	return clone

/datum/shuttle_descriptor/merge_from(datum/shuttle_descriptor/other)
	if(!isnull(other.display_name))
		src.display_name = other.display_name

	if(!isnull(other.mass))
		src.mass = other.mass
	if(!isnull(other.allow_atmospheric_landing))
		src.allow_atmospheric_landing = other.allow_atmospheric_landing
	if(!isnull(other.preferred_orientation))
		src.preferred_orientation = other.preferred_orientation

	if(!isnull(other.jump_charging_time))
		src.jump_charging_time = other.jump_charging_time
	if(!isnull(other.jump_move_time))
		src.jump_move_time = other.jump_move_time

	if(!isnull(other.overmap_icon))
		src.overmap_icon = other.overmap_icon
	if(!isnull(other.overmap_icon_state))
		src.overmap_icon_state = other.overmap_icon_state
	if(!isnull(other.overmap_icon_color))
		src.overmap_icon_color = other.overmap_icon_color
	if(!isnull(other.overmap_legacy_start_unknown))
		src.overmap_legacy_start_unknown = other.overmap_legacy_start_unknown
	if(!isnull(other.overmap_legacy_name))
		src.overmap_legacy_name = other.overmap_legacy_name
	if(!isnull(other.overmap_legacy_desc))
		src.overmap_legacy_desc = other.overmap_legacy_desc
	if(!isnull(other.overmap_legacy_scan_name))
		src.overmap_legacy_scan_name = other.overmap_legacy_scan_name
	if(!isnull(other.overmap_legacy_scan_desc))
		src.overmap_legacy_scan_desc = other.overmap_legacy_scan_desc
