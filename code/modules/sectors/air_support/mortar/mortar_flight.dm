//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mortar_flight
	var/obj/item/ammo_casing/mortar/shell
	/// target map struct
	var/datum/map/flight_map
	/// as virtual x
	var/flight_x
	/// as virtual y
	var/flight_y
	/// as struct z
	var/flight_z
	var/flight_duration
	var/turf/flight_origin

	var/fired = FALSE
	var/datum/event_args/actor/fired_firer
	var/fired_arrive_time

/datum/mortar_flight/New(obj/item/ammo_casing/mortar/shell)
	shell.moveToNullspace()
	src.shell = shell

/datum/mortar_flight/Destroy()
	QDEL_NULL(shell)
	flight_map = null
	fired_firer = null
	return ..()

/datum/mortar_flight/proc/set_origin(turf/origin)
	src.flight_origin = origin

/datum/mortar_flight/proc/set_target(datum/map/map, virtual_x, virtual_y, virtual_z)
	src.flight_map = map
	src.flight_x = virtual_x
	src.flight_y = virtual_y
	src.flight_z = virtual_z

/datum/mortar_flight/proc/set_duration(time)
	src.flight_duration = time

/datum/mortar_flight/proc/run(datum/event_args/actor/firer)
	log_mortar_shell(firer, "mortar flight started", shell.get_log_list())
	src.fired = TRUE
	src.fired_firer = firer
	src.fired_arrive_time = world.time + flight_duration
	var/flight_telegraph = min(shell.pre_impact_sound_duration * 2, shell.pre_impact_sound_telegraph)
	addtimer(CALLBACK(src, PROC_REF(impact_warning), flight_duration - flight_telegraph), flight_telegraph)
	addtimer(CALLBACK(src, PROC_REF(impact)), flight_duration)

/datum/mortar_flight/proc/get_players_in_radius_of_target(radius) as /list
	. = list()
	for(var/client/player in GLOB.clients)
		var/mob/their_mob = player.mob
		var/their_z = their_mob.z
		if(!their_z)
			continue
		var/datum/map/their_map = SSmapping.ordered_levels[their_z]?.map
		if(their_map != flight_map)
			continue
		var/list/their_coords = SSmapping.get_virtual_coords_x_y_z(their_mob)
		// TODO: multiz support because what if they're underneath the thing and get exploded?
		if(their_coords[3] != flight_z)
			continue
		if(max(abs(their_coords[1] - flight_x), abs(their_coords[2] - flight_y)) > radius)
			continue
		. += their_mob

/datum/mortar_flight/proc/get_target_turf() as /turf
	return SSmapping.get_virtual_turf(flight_map, flight_x, flight_y, flight_z)

/datum/mortar_flight/proc/impact_warning(duration)
	// this doesn't warn ais but they should use other ways of detection anyways
	var/list/mob/send_to = get_players_in_radius_of_target(15)
	var/dir_descriptor
	if(flight_origin)
		var/list/origin_vcoords = SSmapping.get_virtual_coords_x_y_z(flight_origin)
		var/origin_dir = NONE
		if(origin_vcoords[1] < flight_x)
			origin_dir |= WEST
		else if(origin_vcoords[1] > flight_x)
			origin_dir |= EAST
		if(origin_vcoords[2] < flight_y)
			origin_dir |= SOUTH
		else if(origin_vcoords[2] > flight_y)
			origin_dir |= NORTH
		dir_descriptor = "the [dir2text(origin_dir)]"
	else
		dir_descriptor = "somewhere"
	for(var/mob/victim as anything in send_to)
		victim.show_message(
			SPAN_BOLDWARNING("You see something flying towards your position from [dir_descriptor]!"),
			SAYCODE_TYPE_VISIBLE,
			SPAN_WARNING("You hear something flying towards your position from [dir_descriptor]!"),
			SAYCODE_TYPE_AUDIBLE,
		)
	#warn sound, msg

/datum/mortar_flight/proc/impact()
	var/turf/maybe_target_turf = get_target_turf()
	log_mortar_shell(fired_firer, "mortar flight impacting", shell.get_log_list())
	if(maybe_target_turf)
		shell.on_detonate(maybe_target_turf)
	qdel(src)
