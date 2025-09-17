//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * 4 corners = auto create zone
 * * corners are on the outside, meaning everything *inside* the corners is the zone
 */
/obj/orbital_deployment_marker
	plane = DEBUG_PLANE
	layer = DEBUG_
	invisibility = INVISIBILITY_MAP_HELPER

	var/tmp/bit = 0
	var/tmp/d1 = NONE
	var/tmp/d2 = NONE
	var/tmp/zone_built = FALSE

/obj/orbital_deployment_marker/lower_left
	bit = (1<<0)
	d1 = EAST
	d2 = NORTH

/obj/orbital_deployment_marker/lower_left/Initialize(mapload)
	. = ..()

/obj/orbital_deployment_marker/upper_right
	bit = (1<<1)
	d1 = SOUTH
	d2 = WEST

/obj/orbital_deployment_marker/lower_right
	bit = (1<<2)
	d1 = NORTH
	d2 = WEST

/obj/orbital_deployment_marker/upper_left
	bit = (1<<3)
	d1 = SOUTH
	d2 = EAST

#warn impl

// TODO: set an ID
/obj/orbital_deployment_marker/zone_tagger
