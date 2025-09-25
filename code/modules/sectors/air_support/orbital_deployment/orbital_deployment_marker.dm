//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * 4 corners = auto create zone
 * * corners are on the outside, meaning everything *inside* the corners is the zone
 * * The lower left marker is responsible for building the zone
 */
/obj/orbital_deployment_marker
	name = "orbital deployment zone marker"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_MAP_HELPERS
	invisibility = INVISIBILITY_MAP_HELPER

	#warn sprite

	var/tmp/bit = 0
	var/tmp/d1 = NONE
	var/tmp/d2 = NONE
	var/tmp/zone_built = FALSE
	var/tmp/datum/orbital_deployment_zone/zone

/obj/orbital_deployment_marker/Destroy()
	if(zone)
		QDEL_NULL(zone)
	return ..()

/obj/orbital_deployment_marker/lower_left
	bit = (1<<0)
	d1 = EAST
	d2 = NORTH

/obj/orbital_deployment_marker/lower_left/Initialize(mapload)
	. = ..()
	build_zone_or_throw()

/obj/orbital_deployment_marker/lower_left/proc/build_zone_or_throw()
	var/obj/orbital_deployment_marker/lower_left/lower_left = src
	var/obj/orbital_deployment_marker/lower_right/lower_right
	var/obj/orbital_deployment_marker/upper_left/upper_left
	var/obj/orbital_deployment_marker/upper_right/upper_right


	#warn impl

	if(!lower_left || !lower_right || !upper_left || !upper_right)
		CRASH("failed to build zone; didn't find atleast one corner: [!!lower_left] [!!lower_right] [!!upper_left] [!!upper_right]")
	new /datum/orbital_deployment_zone(lower_left, lower_right, upper_right, upper_left)

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

// TODO: set an ID
/obj/orbital_deployment_marker/zone_tagger
	name = "orbital deployment zone tagger"
	#warn sprite

	/// id to set
	var/id

/obj/orbital_deployment_marker/zone_tagger/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/orbital_deployment_marker/zone_tagger/LateInitialize()
	#warn impl
