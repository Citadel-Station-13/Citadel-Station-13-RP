//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_transit
	var/turf/target_lower_left
	var/target_dir_from_north

	var/datum/map_reservation/reservation
	var/area/structural_area

	// Person who initiated the launch.
	// * This is only referenced like so because transit is short-lived.
	//   If this becomes a long-lived entity, in the future we'll want to have
	//   actor be able to return a snapshot with weakrefs and ckeys
	//   as to not block GC.
	var/datum/event_args/actor/launching_actor

	var/c_impact_obj_dmg_base
	var/c_impact_obj_dmg_sides
	var/c_impact_obj_dmg_cnt
	var/c_impact_mob_dmg_base
	var/c_impact_mob_dmg_sides
	var/c_impact_mob_dmg_cnt
	var/c_impact_mob_dmg_sides_for_those_without_plot_armor
	var/c_landing_obj_dmg_base
	var/c_landing_obj_dmg_sides
	var/c_landing_obj_dmg_cnt
	var/c_landing_mob_dmg_base
	var/c_landing_mob_dmg_sides
	var/c_landing_mob_dmg_cnt

	var/landing = FALSE

/datum/orbital_deployment_transit/New(datum/orbital_deployment_zone/zone)
	src.c_impact_obj_dmg_base = zone.c_impact_obj_dmg_base
	src.c_impact_obj_dmg_sides = zone.c_impact_obj_dmg_sides
	src.c_impact_obj_dmg_cnt = zone.c_impact_obj_dmg_cnt
	src.c_impact_mob_dmg_base = zone.c_impact_mob_dmg_base
	src.c_impact_mob_dmg_sides = zone.c_impact_mob_dmg_sides
	src.c_impact_mob_dmg_cnt = zone.c_impact_mob_dmg_cnt
	src.c_landing_obj_dmg_base = zone.c_landing_obj_dmg_base
	src.c_landing_obj_dmg_sides = zone.c_landing_obj_dmg_sides
	src.c_landing_obj_dmg_cnt = zone.c_landing_obj_dmg_cnt
	src.c_landing_mob_dmg_base = zone.c_landing_mob_dmg_base
	src.c_landing_mob_dmg_sides = zone.c_landing_mob_dmg_sides
	src.c_landing_mob_dmg_cnt = zone.c_landing_mob_dmg_cnt

/datum/orbital_deployment_transit/Destroy()
	QDEL_NULL(reservation)
	return ..()

/**
 * @return TRUE / FALSE
 */
/datum/orbital_deployment_transit/proc/allocate_and_package(turf/lower_left, turf/upper_right, area/zone_area)
	// allocate package
	ASSERT(upper_right.x >= lower_left.x && upper_right.y >= lower_left.y)
	var/width = upper_right.x - lower_left.x + 1
	var/height = upper_right.y - lower_left.y + 1
	var/border = 2

	var/datum/map_reservation/allocating = SSmapping.request_block_reservation(
		width + border * 2,
		height + border * 2,
		/datum/map_reservation,
		/turf/space,
		/area/space,
	)
	if(!allocating)
		. = FALSE
		CRASH("failed to reserve map level")
	reservation = allocating
	structural_area = zone_area

	// move into
	var/list/src_ordered = SSgrids.get_ordered_turfs(
		lower_left.x,
		upper_right.x,
		lower_left.y,
		upper_right.y,
		lower_left.z,
		NORTH,
	)

	var/target_x
	var/target_y =
	var/target_z = allocating.bottom_left_coords[3]
	var/list/dst_ordered = SSgrids.get_ordered_turfs(
		,
		,
		,
		,
		allocating.bottom_left_coords[3],
		NORTH,
	)
	#warn impl

	log_orbital_deployment(launching_actor, "allocating/packaging a [width]x[height] area")

	SSgrids.translate(
		src_ordered,
		dst_ordered,
		NORTH,
		NORTH,
		GRID_MOVE_AREA | GRID_MOVE_MOVABLES | GRID_MOVE_TURF,
		/turf/baseturf_skipover/orbital_deployment_zone,
		/area/space,
	)

/datum/orbital_deployment_transit/proc/land()
	if(landing)
		CRASH("already landing")
	landing = TRUE
	var/datum/orbital_deployment_translation/landing = new(src)
	// 1. yeet zone
	perform_chunk_translation_to_landing(landing)

	// 2. gather remaining
	var/list/atom/movable/remaining = list()
	for(var/T in reservation.unordered_inner_turfs())
		for(var/atom/movable/AM as anything in T)
			if(AM.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
				continue
			remaining += AM
	landing.falling_out_of_the_sky += remaining

	// 3. perform landing
	landing.run_aftereffects(structural_area)

	// 4. qdel self; anything left is getting deleted. byebye!!
	qdel(src)

/datum/orbital_deployment_transit/proc/perform_chunk_translation_to_landing(datum/orbital_deployment_translation/translation)
	#warn impl

	var/wanted_dir = math__angle_to_dir_exact_or_throw(rotation_degrees)

	var/list/measured = measure_current_dimensions()
	var/width = measured[1]
	var/height = measured[2]

	if(target_lower_left.x < 1)

	#warn impl
	calculate_entity_motion_with_respect_to_moving_point()
	var/list/destination_turfs = SSgrids.get_ordered_turfs(
		target_lower_left.x,
		target_lower_left.x + width - 1,
		target_lower_left.y,
		target_lower_left.y + height - 1,
		target_lower_left.z,
	)

	var/list/out_motion_flags = list()
	var/list/out_moved_atoms = list()

	var/datum/orbital_deployment_translation/translation = new

	var/datum/bound_proc/turf_overlap_handler = BOUND_PROC(translation, TYPE_PROC_REF(/datum/orbital_deployment_translation, on_turf_overlap))
	var/datum/bound_proc/movable_overlap_handler = BOUND_PROC(translation, TYPE_PROC_REF(/datum/orbital_deployment_translation, on_movable_overlap))

	SSgrids.translate(
		from_turfs,
		to_turfs,
		NORTH,
		wanted_dir,
		GRID_MOVE_AREA | GRID_MOVE_MOVABLES | GRID_MOVE_TURF,
		null,
		base_area,
		out_motion_flags,
		out_moved_atoms,
		turf_overlap_handler,
		movable_overlap_handler,
	)

	translation.run_aftereffects(current_area)

