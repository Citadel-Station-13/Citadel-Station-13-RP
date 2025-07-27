//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/techweb_node
	/// name; used in everything
	var/name = "???"
	/// display name; used over name for player facing purposes if available
	var/display_name
	/// description
	var/description

#warn impl

	var/tmp/cached_base64_preview

/datum/prototype/techweb_node/proc/get_display_name()
	return display_name || name

/datum/prototype/techweb_node/proc/get_preview_appearance()
	#warn impl

/datum/prototype/techweb_node/proc/get_preview_appearance_as_base64()
	#warn impl

/datum/prototype/techweb_node/clone()
	var/datum/prototype/techweb_node/clone = new
	// TODO: serde/clone

/datum/prototype/techweb_node/serialize()
	. = list()
	// TODO: serde/clone

/datum/prototype/techweb_node/deserialize(list/data)
	// TODO: serde/clone

//* inbuilt *//

/**
 * designs go in here if they haven't been categorized. please don't put more designs in here.
 */
/datum/prototype/techweb_node/default_intrinsic

/**
 * shit everyone who's in space knows
 */
/datum/prototype/techweb_node/spacer_intrinsic
	abstract_type = /datum/prototype/techweb_node/spacer_intrinsic

/datum/prototype/techweb_node/spacer_intrinsic/power_tools
	name = "Power Tools"

/datum/prototype/techweb_node/faction_intrinsic
	abstract_type = /datum/prototype/techweb_node/faction_intrinsic

/**
 * shit nt knows
 * TODO: move to NT folder in content?
 */
/datum/prototype/techweb_node/faction_intrinsic/nanotrasen

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/magnetic_weapons
	name = "NT (Weapons): Magnetic Rifles"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/energy_weapons
	name = "NT (Weapons): Modular Lasers"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/ballistic_weapons
	name = "NT (Weapons): Expeditionary Kinetics"
