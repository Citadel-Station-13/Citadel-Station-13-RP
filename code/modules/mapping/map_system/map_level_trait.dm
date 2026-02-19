//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/map_level_trait
	/// our enum
	var/id
	/// desc
	var/desc = "Some kind of trait."
	/// allow admin editing
	var/allow_edit = FALSE

/datum/map_level_trait/proc/ui_serialize()
	return list(
		"id" = initial(id),
		"desc" = initial(desc),
		"allowEdit" = initial(allow_edit),
	)


/datum/map_level_trait/reserved
	id = "system-reserved"
	desc = "Reserved by the maploader. Do not touch."

/datum/map_level_trait/gravity
	id = "innate-gravity"
	desc = "This level inherently has gravity"
	allow_edit = TRUE

/datum/map_level_trait/minimap
	id = "generate-minimaps"
	desc = "Generate a minimap for this level."
	allow_edit = TRUE

//! below are all pending deprecation. !//

/datum/map_level_trait/legacy_station
	id = "legacy-station"
	desc = "Legacy: Considered station."
	allow_edit = TRUE

/datum/map_level_trait/legacy_admin
	id = "legacy-admin"
	desc = "Legacy: Considered an admin level."
	allow_edit = TRUE

/datum/map_level_trait/legacy_facility_safety
	id = "legacy-facility_safety"
	desc = "Legacy: Block exploration pinned weapons."
	allow_edit = TRUE

/datum/map_level_trait/legacy_xenoarch_exempt
	id = "legacy-xenoarch_exempt"
	desc = "Legacy: Do not spawn anomalies here."
	allow_edit = TRUE

/datum/map_level_trait/legacy_station
	id = "legacy-no-wallhack"
	desc = "Legacy: Block mesons, materials, thermals, and sonar scanners."
	allow_edit = TRUE

