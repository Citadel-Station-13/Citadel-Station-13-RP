//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/techweb_node
	/// name; used in everything
	var/name = "???"
	/// display name; used over name for player facing purposes if available
	/// * nullable
	var/display_name
	/// description, if any
	/// * nullable
	var/description

	var/tmp/cached_base64_preview

/datum/prototype/techweb_node/proc/get_display_name()
	return display_name || name

/**
 * @return appearance (image, mutable apeparance, even atom) or null
 */
/datum/prototype/techweb_node/proc/get_preview_appearance()
	// TODO: preview
	return null

/**
 * @return base64 or null
 */
/datum/prototype/techweb_node/proc/get_preview_appearance_as_base64()
	// TODO: preview
	return null

/datum/prototype/techweb_node/clone()
	var/datum/prototype/techweb_node/clone = new
	clone.name = name
	clone.display_name = display_name
	clone.description = description
	return clone

/datum/prototype/techweb_node/serialize()
	. = list()
	.["name"] = name
	.["name-display"] = display_name
	.["desc"] = description

/datum/prototype/techweb_node/deserialize(list/data)
	name = data["name"] || "???"
	display_name = data["name-display"] || null
	description = data["description"] || null

//* inbuilt *//

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

/**
 * designs go in here if they haven't been categorized. please don't put more designs in here.
 */
/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/legacy

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/magnetic_weapons
	name = "NT (Weapons): Magnetic Rifles"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/energy_weapons
	name = "NT (Weapons): Modular Lasers"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/ballistic_weapons
	name = "NT (Weapons): Expeditionary Kinetics"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/guncrafting_basic_particle_array
	name = "NT (Weapon Components): Particle Arrays"

/datum/prototype/techweb_node/faction_intrinsic/nanotrasen/guncrafting_divide_by
	name = "NT (Weapon Components): Linear Particle Splitters"
