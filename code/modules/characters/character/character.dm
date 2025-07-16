//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A character in the game.
 *
 * Notes;
 *
 * * Anything that is a system field should be prefixed with 's_'
 * * Anything that is a character field and not a system field / reference field
 *   should be prefixed with 'c_'
 * * Any field that's a persistent field should be a 'p_'
 * * Ckey is intentionally not stored; characters don't belong to anyone,
 *   the backend determines who can access what (thus establishing ownership).
 */
/datum/character
	//*                             System                          *//
	//* -- Everything in here is handled by save / load backend. -- *//

	/// character ID in the table
	///
	/// * for savefile / legacy characters, this will **not be set.**
	/// * if this is null, no persistence can proceed as we are operating in legacy / savefile mode.
	var/s_character_id
	/// ISO 8601 timestamp of first creation
	var/s_created_time
	/// Filter string. This is used to do things like filtering out the characters
	/// that are actually relevant for a role.
	/// * ADMINS, DO NOT TOUCH THIS FOR THE LOVE OF GOD
	/// * The codebase reserves the right to edit this at any time for any reason.
	var/s_filter_string
	/// Current migrations applied, as a list.
	/// * ADMINS, DO NOT TOUCH THIS FOR THE LOVE OF GOD
	/// * The codebase reserves the right to edit this at any time for any reason.
	var/list/s_migrations_performed
	/// IC fluff ID. This is a system value because it's directly serialized to DB,
	/// and can be used for filtering. It should not be modified without using
	/// helper procs.
	var/s_employee_id
	/// Dirty / was modified
	var/s_dirty = FALSE

	//*             Character             *//

	/// Faction
	/// * Serialized as ID
	/// * Determines base role eligibility, as well as what species you can choose.
	#warn faction
	var/datum/c_faction
	/// Species
	/// * Serialized as ID
	/// * Determines the base attributes of this character.
	#warn species
	var/datum/species/c_species




#warn below

	//* Appearance - Directly serialized *//
	/// your main appearance
	var/datum/character_appearance/appearance_primary
	/// ordered appearance slots
	///
	/// * this list can be at most [CHARACTER_MAX_APPEARANCE_SLOTS] long, and at least 0 long.
	/// * this is basically a quirky lazy-list in that we only populate the later sections as it expands.
	var/list/datum/character_appearance/appearance_slots

	//* Background - Directly serialized *//
	/// Your character's background
	var/datum/character_background/background

	//* Identity - Directly serialized *//
	/// The character's true name.
	///
	/// * Can be overridden by appearance slots.
	var/c_name
	/// short notes field for the player
	///
	/// * this is for the entire character, not an appearance
	var/c_label

	//* Identity - Packed into data list *//
	/// the character's age
	var/c_age
	/// Flavor text. This goes before appearance-specific flavor texts.
	/// OOC notes
	var/c_ooc_notes

	//* Inventory - Directly serialized *//
	/// our inventory
	var/datum/character_inventory/inventory

	//* Loadout - Directly serialized *//
	/// ordered loadout slots
	///
	/// * this list can be at most [CHARACTER_MAX_LOADOUT_SLOTS] long, and at least 0 long.
	/// * this is basically a quirky lazy-list in that we only populate the later sections as it expands.
	var/list/datum/character_loadout/loadout_slots

	//* Records - Are not stored in here. *//
	/// Records are fetched from SScharacters.

	//* Roles - Packed into data list *//
	///

	//* Skills - Directly serialized *//
	/// our skills holder
	var/datum/character_skills/skills

	// todo:
	// disabilities?
	// mirror?
	// special roles
	// event roles
	// communicator visibility?
	// ringtone?
	// traits?
	// character dictory: (show/hide, tag, erptag, ad)
	// suit sensor prefs

	// todo: hellish crap to deal with:
	// pai: (name, description, role, ooc)
	// silicons: (name, flavortext, ooc notes override)
	// ignore list
	// media system prefs
	// vore prefs
	// resleeving?
	// autohiss?
	// custom sayverbs??
	// nif

	// todo; notes:
	// underwear --> items as loadout
	// backpack --> backpack as loadout
	// pda --> pda as loadout

#warn impl

