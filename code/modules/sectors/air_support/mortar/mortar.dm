//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
		.["collapse"] = create_context_menu_tuple("Collapse", image(src), 1, MOBILITY_CAN_USE)

/obj/machinery/mortar/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("collapse")
			try_collapse(e_args)
			return TRUE

/obj/machinery/mortar/proc/try_collapse(datum/event_args/actor/actor)
	#warn impl

/obj/machinery/mortar/proc/collapse(atom/new_loc) as /obj/item/mortar_kit
	var/obj/item/mortar_kit/creating = new /obj/item/mortar_kit(new_loc, TRUE)
	creating.mortar = src
	forceMove(creating)
	return creating

/obj/machinery/mortar/proc/run_firing_cycle(obj/item/ammo_casing/mortar/shell, x_offset, y_offset)
	// clockwise from north
	var/k_azimuth = arctan(y_offset, x_offset)

	var/k_distance = sqrt(x_offset ** 2 + y_offset ** 2)
	var/k_velocity = launch_velocity

	var/gravity_on_target_planet = 9.8

	var/list/k_optimal = math__solve_kinematic_trajectory(null, k_velocity, k_distance, 0, gravity_on_target_planet)
	var/list/k_inaccurate = run_firing_kinematics(k_azimuth, k_optimal[1], k_velocity)
	var/list/k_final = math__solve_kinematic_trajectory(k_inaccurate[2], k_inaccurate[3], null, 0, gravity_on_target_planet)

	var/final_distance = k_final[3]

	var/final_dx = round(sin(k_azimuth) * final_distance, 1)
	var/final_dy = round(cos(k_azimuth) * final_distance, 1)

	launch(shell, final_dx, final_dy, k_final[4])

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

	/// loaded shell about to be fired
	var/obj/item/ammo_casing/mortar/firing_shell

	var/target_offset_x
	var/target_offset_y
	var/target_adjust_x
	var/target_adjust_y
	/// max you can do quick adjustments in any direction
	var/adjust_offset_max = 15

/obj/machinery/mortar/basic/proc/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/ammo_casing/mortar))
		var/obj/item/ammo_casing/mortar/shell = using
		try_load_shell(shell, clickchain)
		return . | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/machinery/mortar/basic/proc/try_load_shell(obj/item/ammo_casing/mortar/shell, datum/event_args/actor/actor, silent, instant)
	#warn impl

/obj/machinery/mortar/basic/proc/on_shell_loaded(obj/item/ammo_casing/mortar/shell)
	addtimer(CALLBACK(src, PROC_REF(fire_loaded_shell)), time_to_fire)

/obj/machinery/mortar/basic/proc/fire_loaded_shell()
	if(!firing_shell)
		return
	var/obj/item/ammo_casing/mortar/firing = firing_shell
	firing_shell = null
	run_firing_cycle(firing, x_offset, y_offset)

/obj/machinery/mortar/basic/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("setTarget")
		if("setAdjust")

/obj/machinery/mortar/basic/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "")
		ui.open()

/obj/machinery/mortar/basic/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["adjustMax"] = adjust_offset_max

/obj/machinery/mortar/basic/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["targetX"] = target_offset_x
	.["targetY"] = target_offset_y
	.["adjustX"] = target_adjust_x
	.["adjustY"] = target_adjust_y

/obj/machinery/mortar/basic/standard
	caliber = /datum/ammo_caliber/mortar
