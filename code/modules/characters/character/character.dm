//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A character in the game.
 *
 * Represents humanoid actors.
 *
 * * AI / Cyborg support is rudimentary at this time.
 *
 * How this works:
 *
 * * Above all, /datum/character_status is allowed to arbitrarily restrain things.
 * * Basic things like name, label, flavor text, etc, are set independently of everything.
 *
 * Then,
 *
 * * Core intrinsics like species are set first.
 * * Character background generally only depends on species, but can depend on physiology too.
 * * Character physiology generally only depends on species, but can depend on background too.
 * * Character appearance generally depends on species, background, and physiology.
 *
 * Lastly,
 *
 * * Character loadout depends on everything else.
 * * Extraneous data depends on everything else.
 *
 * Notes;
 *
 * * Anything that is a character field and not a system field / reference field
 *   should be prefixed with 'c_'
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
	/// your main appearance
	var/datum/character_appearance/appearance_primary
	/// ordered appearance slots
	///
	/// * this list can be at most [CHARACTER_MAX_APPEARANCE_SLOTS] long, and at least 0 long.
	/// * this is basically a quirky lazy-list in that we only populate the later sections as it expands.
	var/list/datum/character_appearance/appearance_slots

	//* Background - Directly Serialized *//
	/// Your character's background
	var/datum/character_background/background

	//* Identity - Directly Serialized *//
	/// The character's true name.
	///
	/// * Can be overridden by appearance slots.
	var/c_name
	/// short notes field for the player
	///
	/// * this is for the entire character, not an appearance
	var/c_label
	/// the character's age
	var/c_age
	/// OOC notes
	var/c_ooc_notes

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

	// todo:
	// disabilities?
	// mirror?
	// special roles
	// event roles
	// communicator visibility?
	// ringtone?
	// records
	// skills
	// traits?
	// blood color
	// character dictory: (show/hide, tag, erptag, ad)
	// suit sensor prefs

	// todo: hellish crap to deal with:
	// pai: (name, description, role, ooc)
	// silicons: (name, flavortext, ooc notes override)
	// ignore list
	// media system prefs
	// vore prefs
	// render pixel scale or fuzzy? should we just drop it?
	// resleeving?
	// autohiss?
	// custom sayverbs??
	// nif

	// todo; notes:
	// underwear --> items as loadout
	// backpack --> backpack as loadout
	// pda --> pda as loadout

	// todo; things to drop / delete;
	// economic status

#warn impl

