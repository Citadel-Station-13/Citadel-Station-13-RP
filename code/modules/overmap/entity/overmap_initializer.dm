//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Descriptor sturct used to create an /obj/overmap/entity for a physical location.
 *
 * * base /datum/overmap_initializer has the data to init an overmap entity and its properties.
 * * subtypes of /datum/overmap_initializer has the data to init the physical locations of entities.
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

	/**
	 * You might have noticed that no entity typepath variable is included.
	 *
	 * This is intentional. You are not allowed to subtype
	 * /obj/overmap/entity for your map.
	 *
	 * The initializer system is meant to encapsulate all possible modifiers and
	 * entity data to inject into an entity. You are not to make subtypes of
	 * entity to do that as that would defeat the purpose of going out of our way
	 * to make initializers.
	 *
	 * This way, we can have data-driven overmap entities and avoid any weird
	 * hardcoded behavior. If you really need hardcoded behavior, make a
	 * component for your map and inject that into the entity with the initializer system.
	 *
	 * If you need to do something with the initializer and cannot, the issue is that
	 * the initializer system needs to be upgraded, not that you should be subtyping
	 * entity.
	 */

#warn impl
