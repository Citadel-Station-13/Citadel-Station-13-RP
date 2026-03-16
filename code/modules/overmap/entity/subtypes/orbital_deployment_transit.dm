//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An in-transit orbital deployment zone.
 */
/obj/overmap/entity/orbital_deployment_transit
	name = "orbital base drop"
	desc = "A base someone launched at a planet. Is this safe?"
	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "orbital_deployment_transit"

	var/datum/orbital_deployment_zone/zone
	var/datum/orbital_deployment_transit/transit

/obj/overmap/entity/orbital_deployment_transit/Initialize(mapload, datum/overmap_location/location, datum/orbital_deployment_zone/zone, datum/orbital_deployment_transit/transit)
	src.zone = zone
	src.transit = transit
	// ! WARNING THIS MOVES US OUT OF THE ENTITY !
	if(istype(loc, /obj/overmap/entity))
		copy_physics_pos_vel(loc)
	return ..()

/**
 * we don't actually need to hit target to land as of right now
 * in the future we might but it's actually just a timer
 *
 * @params
 * * target - target to launch at (assuming we are already in the world and positioned relative to it)
 * * launch_speed - angleless speed in overmap units to fly at
 */
/obj/overmap/entity/orbital_deployment_transit/proc/launch(obj/overmap/entity/target, launch_speed = OVERMAP_PIXEL_TO_DIST(WORLD_ICON_SIZE * 0.5))
	// TODO: entity names can change we should probably have a UID system
	log_orbital_deployment(transit.launching_actor, "launched orbital transit at [target]")

	// automatically compensate for living planets and other EM shenanigans
	if(target.is_moving)
		launch_speed += target.get_abstracted_speed()

	var/list/computed = math__solve_intercept_trajectory(
		src.get_abstracted_position_v(),
		target.get_abstracted_position_v(),
		launch_speed,
		target.get_abstracted_velocity_v(),
	)

	// impossible unless the planet is moving
	// EDIT: impossible in general as we compensate for their speed now
	if(!computed)
		CRASH("failed to solve intercept trajectory for orbital launch; please don't launch at living planets!")
	var/use_angle = computed[1]
	// yeah nah always give a telegraph time
	var/use_time = max(computed[2], 10 SECONDS)
	var/use_telegraph_time = max(use_time - transit.c_telegraph_time, 0)

	addtimer(CALLBACK(src, PROC_REF(telegraph), use_time - use_telegraph_time), use_telegraph_time)
	addtimer(CALLBACK(src, PROC_REF(land)), use_time)
	// last line because cos/sin times something seems to break debugger (invalid opcode 387 byond 1667)
	set_velocity(cos(use_angle) * launch_speed, sin(use_angle) * launch_speed)

/obj/overmap/entity/orbital_deployment_transit/proc/land()
	transit.land()

/obj/overmap/entity/orbital_deployment_transit/proc/telegraph(landing_time)
	transit.telegraph(landing_time)
