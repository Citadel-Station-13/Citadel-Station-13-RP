//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Descriptor sturct used to create an /obj/overmap/entity for a physical location.
 *
 * * base /datum/overmap_initializer has the data to init an overmap entity and its properties.
 * * subtypes of /datum/overmap_initializer has the data to init the physical locations of entities.
 */
/datum/overmap_initializer
	//* Positioning *//

	/// force preferred position?
	///
	/// * this will make it spawn there even if there's a hazard there
	/// * this will not allow it to overlap another entity.
	/// * this is called strong suggestion because the overmaps backend reserves the right
	///   to entirely ignore your request if it doesn't make sense or violates overmaps
	///   generation invariants.
	var/manual_position_is_strong_suggestion = FALSE
	/// preferred position x
	var/manual_position_x
	/// preferred position y
	var/manual_position_y

	//! LEGACY
	/// the entity name while not scanned
	// var/unknown_name = "unknown sector"
	/// the entity icon state when not scanned
	// var/unknown_state = "unknown"
	/// the entity name when scanned
	// var/known_name = "map object"
	/// the entity icon state when scanned
	// var/known_state = "generic"
	/// start known?
	// var/start_known = TRUE
	/// can it be scanned?
	// var/scannable = TRUE
	/// description on a scanner printout
	// var/scanner_desc = "<hr><center><h1>No data available.</h1></center><hr>"
	/// type to make
	var/legacy_entity_type = /obj/overmap/entity
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

/**
 * Initializes our overmap entity.
 *
 * * `from_source_location` should be typecasted on subtypes as the same type as
 *    `assemble_location`'s `from_source` argument.
 *
 * @params
 * * from_source_location - source location to make the entity for
 */
/datum/overmap_initializer/proc/initialize(from_source_location)
	var/datum/overmap_location/location = assemble_location(from_source_location)
	if(!location)
		CRASH("failed to assemble location during overmap entity initialization")
	var/datum/overmap/place_on = SSovermaps.get_or_load_default_overmap()
	var/turf/place_at
	if(manual_position_x && manual_position_y)
		place_at = place_on.query_closest_reasonable_open_space(locate(manual_position_x, manual_position_y, place_on.reservation.bottom_left_coords[3]), manual_position_is_strong_suggestion)
	else
		place_at = place_on.query_random_placement_location()
	return create_overmap_entity(location, place_at)

/**
 * Creates our location
 *
 * * from_source should be typecasted on subtypes as the same type as `initialize`'s
 *   `from_source_location` argument.
 */
/datum/overmap_initializer/proc/assemble_location(from_source) as /datum/overmap_location
	CRASH("unimplemented proc called")

/**
 * Creates our overmap object
 */
/datum/overmap_initializer/proc/create_overmap_entity(datum/overmap_location/from_location, turf/initial_placement) as /obj/overmap/entity
	var/obj/overmap/entity/creating = new legacy_entity_type(null)
	creating.set_location(from_location)
	creating.forceMove(initial_placement)
	return creating
