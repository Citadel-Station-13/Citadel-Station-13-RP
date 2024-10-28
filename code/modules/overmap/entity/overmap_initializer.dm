//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * bidirectional bindings between /obj/overmap/entity and its physical location
 *
 * * base /datum/overmap_initializer has the data to init an overmap entity and its properties.
 *   this is not fired if we're being called from an already initialized entity
 * * subtypes of /datum/overmap_initializer has the data to init the physical locations of entities.
 *   that is not fired if we're being called from an already initialized map
 * * the bidirectional-ness is that both an entity and a map can use this API to init
 * * this is done so we can avoid having to make two datums, one to init locations, and one to init entities.
 * * this keeps /datum/overmap_location simple as it doesn't have any init logic at all.
 */
/datum/overmap_initializer
	//! LEGACY
	/// the entity name while not scanned
	var/unknown_name = "unknown sector"
	/// the entity icon state when not scanned
	var/unknown_state = "unknown"
	/// the entity name when scanned
	var/known_name = "map object"
	/// the entity icon state when scanned
	var/known_state = "generic"
	/// can it be scanned?
	var/scannable = TRUE
	/// description on a scanner printout
	var/scanner_desc = "<hr><center><h1>No data available.</h1></center><hr>"
	//! END


#warn impl
