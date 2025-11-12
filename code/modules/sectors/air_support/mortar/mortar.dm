//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/mortar
	name = "mortar"
	desc = "A mortar of some kind. What kind of insanity drove you to possess one?"

	#warn sprite

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
	/// time to collapse
	var/collapse_time = 7.5 SECONDS
	/// time to deploy
	var/deploy_time = 7.5 SECONDS

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

	//* Sounds *//
	var/pack_sound = 'sound/modules/sectors/air_support/mortar_unpack.ogg'
	var/pack_sound_volume = 75
	var/pack_sound_vary = FALSE
	var/unpack_sound = 'sound/modules/sectors/air_support/mortar_unpack.ogg'
	var/unpack_sound_volume = 75
	var/unpack_sound_vary = FALSE
	var/fire_sound = 'sound/modules/sectors/air_support/mortar_fire.ogg'
	var/fire_sound_volume = 75
	var/fire_sound_vary = FALSE
	var/load_sound = 'sound/modules/sectors/air_support/mortar_load.ogg'
	var/load_sound_volume = 75
	var/load_sound_vary = FALSE

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
	var/obj/item/mortar_kit/creating = move_into_collapsed(new_loc)
	return creating

/**
 * Creates collapsed
 * * Calling this multiple times is undefined behavior.
 */
/obj/machinery/mortar/proc/move_into_collapsed(atom/new_loc) as /obj/item/mortar_kit
	PROTECTED_PROC(TRUE)
	ASSERT(!istype(loc, /obj/item/mortar_kit))
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

/**
 * - Passing in a `shell` means losing ownership of its reference; please have unreferenced it before calling this proc.
 * @return `/datum/mortar_flight` success, null failure
 */
/obj/machinery/mortar/proc/launch(obj/item/ammo_casing/mortar/shell, x_offset, y_offset, travel_time, silent, suppressed)
	var/turf/where_at = get_turf(src)
	if(!where_at)
		qdel(shell)
		return null
	var/datum/map/where_map = SSmapping.ordered_levels[where_at.z].parent_map
	if(!where_map)
		qdel(shell)
		return null
	if(!silent)
		playsound(src, fire_sound, fire_sound_volume, fire_sound_vary, 3)
	if(!suppressed)
		// TODO: shake screen of those around
		visible_message(SPAN_BOLDWARNING("[chat_html_embed_rendered()] [src] fires!"))

	var/datum/mortar_flight/flight = new(shell)
	flight.set_duration(travel_time)
	flight.set_target(where_map, where_at.x + x_offset, where_at.y + y_offset, where_at.z)
	flight.run()
	return flight

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

	var/target_x
	var/target_y
	var/target_adjust_x
	var/target_adjust_y
	/// max you can do quick adjustments in any direction
	var/adjust_offset_max = 15

	var/adjust_time_major = 7 SECONDS
	var/adjust_time_minor = 1.5 SECONDS

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
	playsound(src, load_sound, load_sound_volume, load_sound_vary, 2)
	addtimer(CALLBACK(src, PROC_REF(fire_loaded_shell)), time_to_fire)

/obj/machinery/mortar/basic/proc/fire_loaded_shell()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return FALSE
	if(!firing_shell)
		return FALSE
	var/obj/item/ammo_casing/mortar/firing = firing_shell
	firing_shell = null

	var/x_offset = target_x - our_turf.x + target_adjust_x
	var/y_offset = target_y - our_turf.y + target_adjust_y
	return run_firing_cycle(firing, x_offset, y_offset)

/obj/machinery/mortar/basic/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/datum/event_args/actor/actor = new(usr)
	switch(action)
		if("setTarget")
			var/x = params["x"]
			var/y = params["y"]
			if(!attempt_user_adjust_doafter(actor, adjust_time_major, "making a major adjustment to"))
				return TRUE
			#warn log
			src.target_x = x
			src.target_y = y
			return TRUE
		if("setAdjust")
			var/x = params["x"]
			var/y = params["y"]
			if(!attempt_user_adjust_doafter(actor, adjust_time_minor, "making a minor adjustment to"))
				return TRUE
			#warn log
			src.target_adjust_x = x
			src.target_adjust_y = y
			return TRUE

/obj/machinery/mortar/basic/proc/attempt_user_adjust_doafter(datum/event_args/actor/actor, delay, phrase = "adjusting")
	#warn impl

/obj/machinery/mortar/basic/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/MortarBasic.tsx")
		ui.open()

/obj/machinery/mortar/basic/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["adjustMax"] = adjust_offset_max

/obj/machinery/mortar/basic/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["targetX"] = target_x
	.["targetY"] = target_y
	.["adjustX"] = target_adjust_x
	.["adjustY"] = target_adjust_y

/obj/machinery/mortar/basic/standard
	caliber = /datum/ammo_caliber/mortar
