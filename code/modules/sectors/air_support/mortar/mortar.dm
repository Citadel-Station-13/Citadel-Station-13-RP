//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/mortar
	name = "mortar"
	desc = "A mortar of some kind. What kind of insanity drove you to possess one?"
	icon = 'icons/modules/sectors/air_support/mortar.dmi'
	icon_state = "mortar-jungle"
	base_icon_state = "mortar-jungle"
	anchored = TRUE
	density = TRUE
	armor_type = /datum/armor/object/heavy

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

	var/flight_time_minimum = 4 SECONDS
	var/flight_time_per_tile = 0.1 SECONDS
	var/flight_time_maximum = 20 SECONDS
	var/maximum_range = 300

	/// apply standard error?
	var/use_standard_error = TRUE
	/// in degrees std-dev
	var/standard_azimuth_error = 2.5
	/// in degrees, to add or subtract, going clockwise
	var/standard_azimuth_error_static = 0
	var/standard_distance_error = 2.5
	/// added / subtracted
	var/standard_distance_error_static = 0

	//* Sounds *//
	var/pack_sound = 'sound/modules/sectors/air_support/mortar_unpack.ogg'
	var/pack_sound_volume = 75
	var/pack_sound_vary = FALSE
	var/unpack_sound = 'sound/modules/sectors/air_support/mortar_unpack.ogg'
	var/unpack_sound_volume = 75
	var/unpack_sound_vary = FALSE
	var/fire_sound = 'sound/modules/sectors/air_support/mortar_fire.ogg'
	var/fire_sound_volume = 100
	var/fire_sound_vary = FALSE
	var/load_sound = 'sound/modules/sectors/air_support/mortar_reload.ogg'
	var/load_sound_volume = 75
	var/load_sound_vary = FALSE

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
			user_collapse(e_args)
			return TRUE

/obj/machinery/mortar/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["maxDistance"] = maximum_range

// TODO: rework machinery power so this doesn't need to be overridden
/obj/machinery/mortar/power_change()
	return

/obj/machinery/mortar/proc/user_collapse(datum/event_args/actor/actor, delay_mod = 1, put_in_hands = TRUE) as /obj/item/mortar_kit
	var/delay = collapse_time * delay_mod
	if(delay > 0)
		if(delay > 0.5 SECONDS)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = span_warning("[actor.performer] collapsing [src]..."),
				audible = span_warning("You hear heavy machinery being taken apart."),
				otherwise_self = span_warning("You start deploying [src]!"),
			)
		if(!do_after(actor.performer, delay, src))
			return null
	actor.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = span_warning("[actor.performer] collapses [src]!"),
		audible = span_warning("You hear heavy machinery being packed."),
		otherwise_self = span_warning("You collapse [src]!"),
	)
	var/atom/drop_loc = drop_location()
	var/obj/item/mortar_kit/drop_result
	if(put_in_hands)
		drop_result = collapse(actor.performer)
		actor.performer.inventory.put_in_hands_or_drop(drop_result)
	else if(drop_loc)
		drop_result = collapse(drop_location())
	else
		return null
	return drop_result

/obj/machinery/mortar/proc/collapse(atom/new_loc) as /obj/item/mortar_kit
	var/obj/item/mortar_kit/creating = move_into_collapsed(new_loc)
	creating.update_icon()
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

/obj/machinery/mortar/proc/run_firing_cycle(obj/item/ammo_casing/mortar/shell, x_offset, y_offset) as /datum/mortar_flight
	// clockwise from north
	var/k_azimuth = arctan(y_offset, x_offset)
	var/k_distance = sqrt(x_offset ** 2 + y_offset ** 2)
	var/k_travel_time = get_flight_time(shell, k_distance, x_offset, y_offset)

	var/list/k_inaccurate = run_firing_kinematics(k_azimuth, k_distance, k_travel_time)

	k_azimuth = k_inaccurate[1]
	k_distance = k_inaccurate[2]
	k_travel_time = k_inaccurate[3]

	var/final_dx = round(sin(k_azimuth) * k_distance, 1)
	var/final_dy = round(cos(k_azimuth) * k_distance, 1)

	return launch(shell, final_dx, final_dy, k_travel_time)

/obj/machinery/mortar/proc/get_flight_time(obj/item/ammo_casing/mortar/shell, distance, x_offset, y_offset)
	return clamp(distance * flight_time_per_tile, flight_time_minimum, flight_time_maximum)

/**
 * @return list(azimuth, distance, travel_time)
 */
/obj/machinery/mortar/proc/run_firing_kinematics(azimuth, distance, travel_time)
	if(use_standard_error)
		azimuth += gaussian(0, standard_azimuth_error)
		azimuth += standard_azimuth_error_static
		distance += gaussian(0, standard_distance_error)
		distance += standard_distance_error_static
	return list(azimuth, distance, travel_time)

/**
 * - Passing in a `shell` means losing ownership of its reference; please have unreferenced it before calling this proc.
 * @return `/datum/mortar_flight` success, null failure
 */
/obj/machinery/mortar/proc/launch(obj/item/ammo_casing/mortar/shell, x_offset, y_offset, travel_time, silent, suppressed)
	var/turf/where_at = get_turf(src)
	if(!where_at)
		qdel(shell)
		return null
	var/datum/map_level/where_level = SSmapping.ordered_levels[where_at.z]
	if(!where_level.is_in_struct())
		return null
	var/datum/map/where_map = where_level.parent_map
	if(!where_map)
		qdel(shell)
		return null
	if(!silent)
		playsound(src, fire_sound, fire_sound_volume, fire_sound_vary, 3)
	flick(src, "[base_icon_state]-fire")
	if(!suppressed)
		shake_camera_of_nearby_players(src, 9, strength = WORLD_ICON_SIZE * 0.5, iterations = 1)
		visible_message(span_boldwarning("[chat_html_embed_rendered()] [src] fires!"))

	var/datum/mortar_flight/flight = new(shell)
	flight.set_origin(where_at)
	flight.set_duration(travel_time)
	var/list/where_at_coords = SSmapping.get_virtual_coords_x_y_z(where_at)
	flight.set_target(where_map, where_at_coords[1] + x_offset, where_at_coords[2] + y_offset, where_at_coords[3])
	flight.execute()
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

	var/target_x = 0
	var/target_y = 0
	var/target_adjust_x = 0
	var/target_adjust_y = 0
	/// max you can do quick adjustments in any direction
	var/adjust_offset_max = 15

	var/adjust_time_major = 7 SECONDS
	var/adjust_time_minor = 1.5 SECONDS

/obj/machinery/mortar/basic/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/ammo_casing/mortar))
		var/obj/item/ammo_casing/mortar/shell = using
		try_load_shell(shell, clickchain)
		return . | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/machinery/mortar/basic/proc/try_load_shell(obj/item/ammo_casing/mortar/shell, datum/event_args/actor/actor, instant, silent, suppressed)
	if(!actor.performer.can_unequip(shell))
		if(!silent)
			actor.chat_feedback(
				span_warning("[shell] is stuck to your hand!"),
				target = src,
			)
		return FALSE
	if(!instant)
		if(!suppressed)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = span_warning("[actor.performer] starts loading [shell] into [src]..."),
				audible = span_warning("You hear someone loading something..."),
			)
		if(!do_after(actor.performer, time_to_load, src))
			return FALSE
	if(!suppressed)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = span_warning("[actor.performer] loads [shell] into [src]!"),
			audible = span_warning("You hear someone load something into a machine!"),
		)
	if(!actor.performer.transfer_item_to_loc(shell, src))
		if(!silent)
			actor.chat_feedback(
				span_warning("[shell] is stuck to your hand!"),
				target = src,
			)
		return FALSE
	on_shell_loaded(shell)
	return TRUE

/obj/machinery/mortar/basic/proc/on_shell_loaded(obj/item/ammo_casing/mortar/shell)
	if(firing_shell)
		if(shell.loc == src)
			shell.forceMove(drop_location())
		return
	playsound(src, load_sound, load_sound_volume, load_sound_vary, 2)
	firing_shell = shell
	addtimer(CALLBACK(src, PROC_REF(fire_loaded_shell)), time_to_fire)

/obj/machinery/mortar/basic/proc/fire_loaded_shell()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return FALSE
	if(!firing_shell)
		return FALSE
	var/obj/item/ammo_casing/mortar/firing = firing_shell
	firing_shell = null

	var/list/our_turf_coords = SSmapping.get_virtual_coords_x_y(our_turf)
	var/x_offset = abs((target_x + target_adjust_x) - our_turf_coords[1])
	var/y_offset = abs((target_y + target_adjust_y) - our_turf_coords[2])
	var/datum/mortar_flight/flight = run_firing_cycle(firing, x_offset, y_offset)
	if(!flight)
		if(firing.loc == src)
			visible_message(span_warning("A hiss is heard from [src] as [firing] falls out of it, having failed to fire."))
			firing.forceMove(drop_location())

/obj/machinery/mortar/basic/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("setTarget")
			var/x = params["x"]
			var/y = params["y"]
			if(!attempt_user_adjust_doafter(actor, adjust_time_major, "recalibrating", "recalibrates"))
				return TRUE
			log_mortar(actor, "set (major) to [x]/[y]")
			src.target_x = x
			src.target_y = y
			return TRUE
		if("setAdjust")
			var/x = params["x"]
			var/y = params["y"]
			if(!attempt_user_adjust_doafter(actor, adjust_time_minor, "making a spot adjustment to", "makes a spot adjustment to"))
				return TRUE
			log_mortar(actor, "adjust (minor) to [x]/[y]")
			src.target_adjust_x = x
			src.target_adjust_y = y
			return TRUE

/obj/machinery/mortar/basic/proc/attempt_user_adjust_doafter(datum/event_args/actor/actor, delay, phrase = "adjusting", done_phrase = "adjusted")
	if(delay > 0)
		if(delay > 0.5 SECONDS)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = span_warning("[actor.performer] starts [phrase] [src]..."),
				audible = span_warning("You hear someone reconfiguring heavy machinery."),
			)
		if(!do_after(actor.performer, delay, src))
			return FALSE
	actor.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = span_warning("[actor.performer] [done_phrase] [src]!"),
		audible = span_warning("You hear heavy machinery being reconfigured."),
	)
	return TRUE

/obj/machinery/mortar/basic/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/MortarBasic")
		ui.set_autoupdate(TRUE)
		ui.open()

/obj/machinery/mortar/basic/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["adjustMax"] = adjust_offset_max
	var/list/our_coords = SSmapping.get_virtual_coords_x_y(get_turf(src))
	.["ourX"] = our_coords[1]
	.["ourY"] = our_coords[2]

/obj/machinery/mortar/basic/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["targetX"] = target_x
	.["targetY"] = target_y
	.["adjustX"] = target_adjust_x
	.["adjustY"] = target_adjust_y

/obj/machinery/mortar/basic/standard
	caliber = /datum/ammo_caliber/mortar
