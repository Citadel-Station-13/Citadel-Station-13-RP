//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An in-transit orbital deployment zone.
 */
/obj/overmap/entity/orbital_deployment_transit
	name = "orbital base drop"
	desc = "A base someone launched at a planet. Is this safe?"
	#warn sprite

	var/datum/orbital_deployment_zone/zone
	var/datum/orbital_deployment_transit/transit

/obj/overmap/entity/orbital_deployment_transit/Initialize(mapload, datum/orbital_deployment_zone/zone, datum/orbital_deployment_transit/transit)
	src.zone = zone
	src.transit = transit
	if(istype(loc, /obj/overmap/entity))
		copy_physics_pos_vel(loc)
	return ..()

/**
 * we don't actually need to hit target to land as of right now
 * in the future we might but it's actually just a timer
 */
/obj/overmap/entity/orbital_deployment_transit/proc/launch(obj/overmap/entity/target, velocity = OVERMAP_PIXEL_TO_DIST(WORLD_ICON_SIZE * 0.5))
	// TODO: entity names can change we should probably have a UID system
	log_orbital_deployment(transit.launching_actor, "launched orbital transit at [target]")
	addtimer(src, CALLBACK(PROC_REF(land)), predicted_time)

/obj/overmap/entity/orbital_deployment_transit/proc/land()
	transit.land()

#warn impl
