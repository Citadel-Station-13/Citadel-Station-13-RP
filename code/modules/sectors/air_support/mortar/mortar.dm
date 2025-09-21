//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: finish this file

/obj/machinery/mortar
	name = "mortar"
	desc = "A mortar of some kind. What kind of insanity drove you to possess one?"
	// TODO: sprite

	use_power = USE_POWER_OFF
	active_power_usage = 0
	idle_power_usage = 0

	/// caliber to use
	/// * can be a string id, a typepath, or an instance
	var/caliber

	/// collapses into kit type
	var/collapsible_kit_type = /obj/item/mortar_kit
	/// can collapse
	var/collapsible = TRUE

	/// launch velocity in m/s
	/// * this should be on the shell but idgaf lol
	var/launch_velocity = 73

	/// in degrees std-dev
	var/standard_azimuth_error = 3.5
	/// in degrees, to add or subtract, going clockwise
	var/standard_azimuth_error_static = 0
	/// in degrees std-dev
	var/standard_altitude_error = 3.5
	/// in degrees, to add or subtract, going upwards towards the zenith
	var/standard_altitude_error_static = 0
	/// in m/s std-dev
	var/standard_velocity_error = 0
	/// in m/s to add/subtract
	var/standard_velocity_error_static = 0

	/// apply standard error?
	var/use_standard_error = TRUE

	#warn time to dest, inaccuracy

/obj/machinery/mortar/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(collapsible)
		.["collapse"] = create_context_menu_tuple()
		#warn tuple

/obj/machinery/mortar/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("collapse")
			#warn impl

/obj/machinery/mortar/proc/collapse(atom/new_loc) as /obj/item/mortar_kit

/obj/machinery/mortar/proc/expand(obj/item/mortar_kit/from_kit)

/obj/machinery/mortar/proc/run_firing_cycle(obj/item/ammo_casing/mortar/shell, x_offset, y_offset)
	// clockwise from north
	var/k_azimuth
	#warn azimuth

	var/k_distance = sqrt(x_offset ** 2 + y_offset ** 2)
	var/k_velocity = launch_velocity

	var/gravity_on_target_planet = 9.8

	var/list/k_optimal = math__solve_kinematic_trajectory(null, k_velocity, k_distance, 0, gravity_on_target_planet)
	var/list/k_inaccurate = run_firing_kinematics(k_azimuth, k_optimal[1], k_velocity)
	var/list/k_final = math__solve_kinematic_trajectory(k_inaccurate[2], k_inaccurate[3], null, 0, gravity_on_target_planet)

	var/final_distance = k_final[3]

	var/final_dx
	var/final_dy
	#warn solve dx/dy

	launch(shell, dx, dy, k_final[4])

/**
 * @return list(azimuth, altitude, velocity)
 */
/obj/machinery/mortar/proc/run_firing_kinematics(azimuth, altitude, velocity)
	if(use_standard_error)
		azimuth += gaussian(0, standard_azimuth_error)
		azimuth += standard_azimuth_error_static
		altitude += gaussian(0, standard_altitude_error)
		altitude += standard_altitude_error_static
		velocity += gaussian(0, standard_velocity_error)
		velocity += standard_velocity_error_static
	return list(azimuth, altitude, velocity)

/obj/machinery/mortar/proc/launch(obj/item/ammo_casing/mortar/shell, x_offset, y_offset, travel_time, silent)

	if(!silent)
		#warn play sound

#warn impl

/**
 * "but why is this not the base type"
 * * because auto-mortars should be a thing, not every mortar
 *   is an irl single-load military mortar.
 */
/obj/machinery/mortar/basic
	collapsible_kit_type = /obj/item/mortar_kit/basic

	/// time to load a shell which is then fired
	var/time_to_load = 3.85 SECONDS
	/// fire delay after shell loads
	var/time_to_fire = 1 SECONDS



/obj/machinery/mortar/basic/proc/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()




/obj/machinery/mortar/basic/standard
	caliber = /datum/ammo_caliber/mortar
