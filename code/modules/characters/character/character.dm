//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A character in the game.
 *
 * Represents humanoid actors.
 *
 * * AI / Cyborg support is rudimentary at this time.
 */
/datum/character
	//*                             System                          *//
	//* -- Everything in here is handled by save / load backend. -- *//
	/// character ID in the table
	///
	/// * for savefile / legacy characters, this will **not be set.**
	/// * if this is null, no persistence can proceed as we are operating in legacy / savefile mode.
	var/character_id
	/// current character status; used for anything from faction locking to persistence
	///
	/// * this is saved / loaded in legacy mode
	var/datum/character_status

	//* Appearance - Directly Serialized *//
	/// ordered appearance slots
	///
	/// * this list can be at most [CHARACTER_MAX_APPEARANCE_SLOTS] long, and at least 0 long.
	/// * this is basically a quirky lazy-list in that we only populate the later sections as it expands.
	var/list/datum/character_appearance/appearance_slots

	//* Identity - Directly Serialized *//
	/// The character's true name.
	///
	/// * Can be overridden by appearance slots.
	var/name
	/// short notes field for the player
	var/label

	//* Flavor Text - Packed into data list *//
	/// The character's general flavor text
	var/flavor_text_general
	/// The character's per-zone flavor text
	///
	/// * Lazy list
	var/list/flavor_text_zones

	//* Inventory - Directly Serialized *//
	/// our inventory
	var/datum/character_inventory/inventory

	//* Loadout - Directly Serialized *//
	/// ordered loadout slots
	///
	/// * this list can be at most [CHARACTER_MAX_LOADOUT_SLOTS] long, and at least 0 long.
	/// * this is basically a quirky lazy-list in that we only populate the later sections as it expands.
	var/list/datum/character_loadout/loadout_slots

	//* Roles - Packed into data list *//
	///

#warn impl

