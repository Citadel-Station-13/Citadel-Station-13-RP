//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_transit
	/**
	 * This is the lower left corner of the target landing area. This does not
	 * include padding added to the reservation.
	 */
	var/turf/target_lower_left
	var/turf/target_upper_right
	var/target_dir_from_north

	var/datum/map_reservation/reservation
	var/area/structural_area

	var/packaged_width
	var/packaged_height
	var/packaged_border

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

	var/c_telegraph_time

	var/landing = FALSE

	/**
	 * Border added to the transit reservation.
	 */
	var/const/border_size = 2

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
	src.c_telegraph_time = zone.c_telegraph_period

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
	var/border = border_size

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

	packaged_width = width
	packaged_height = height
	packaged_border = border

	// move into
	var/list/src_ordered = SSgrids.get_ordered_turfs(
		lower_left.x,
		upper_right.x,
		lower_left.y,
		upper_right.y,
		lower_left.z,
		NORTH,
	)

	var/target_x = allocating.bottom_left_coords[1] + border
	var/target_y = allocating.bottom_left_coords[2] + border
	var/list/dst_ordered = SSgrids.get_ordered_turfs(
		target_x,
		target_x + width - 1,
		target_y,
		target_y + height - 1,
		allocating.bottom_left_coords[3],
		NORTH,
	)

	log_orbital_deployment(launching_actor, "allocating/packaging a [width]x[height] area")

	// unlike shuttles, we package **everything** that isn't the bottom of the baseturfs
	// stack. this is technically not amazing behavior, but, uh, whatever lol?
	// we probably should figure out some standardization of how baseturfs
	// behave but also, not 3d engine so only so much we can do

	// this loop has a null check (no as anything) because get ordered turfs can return nulls
	for(var/turf/T in src_ordered)
		// ignore space turfs and other open turfs
		if(T.is_probably_baseturf_bottom() || ((T.mz_flags & (MZ_OPEN_BOTH)) == MZ_OPEN_BOTH))
			continue
		T.insert_baseturf_above_root_if_not_exists(/turf/baseturf_skipover/orbital_deployment)

	// yeet into package
	SSgrids.translate(
		src_ordered,
		dst_ordered,
		NORTH,
		NORTH,
		GRID_MOVE_AREA | GRID_MOVE_MOVABLES | GRID_MOVE_TURF,
		/turf/baseturf_skipover/orbital_deployment,
		/area/space,
	)

	return TRUE

/datum/orbital_deployment_transit/proc/land()
	if(src.landing)
		CRASH("already landing")
	src.landing = TRUE
	var/datum/orbital_deployment_translation/translation = new(src)
	// 1. yeet zone
	perform_chunk_translation_to_landing(translation)

	// 2. gather remaining
	var/list/atom/movable/remaining = list()
	for(var/T in reservation.unordered_inner_turfs())
		for(var/atom/movable/AM as anything in T)
			if(AM.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
				continue
			remaining += AM
	translation.falling_out_of_the_sky += remaining

	// 3. perform landing
	translation.run_aftereffects(structural_area)

	// 4. qdel self; anything left is getting deleted. byebye!!
	qdel(src)

/datum/orbital_deployment_transit/proc/perform_chunk_translation_to_landing(datum/orbital_deployment_translation/translation)
	ASSERT(target_lower_left)
	ASSERT(target_dir_from_north)

	var/list/from_turfs = get_transit_ordered_turfs()
	var/list/to_turfs = get_target_ordered_turfs()

	translation.dest_lower_left = target_lower_left
	translation.dest_upper_right = target_upper_right
	translation.initialize()

	var/datum/bound_proc/turf_overlap_handler = BOUND_PROC(translation, TYPE_PROC_REF(/datum/orbital_deployment_translation, on_turf_overlap))
	var/datum/bound_proc/movable_overlap_handler = BOUND_PROC(translation, TYPE_PROC_REF(/datum/orbital_deployment_translation, on_movable_overlap))

	SSgrids.translate(
		from_turfs,
		to_turfs,
		NORTH,
		target_dir_from_north,
		GRID_MOVE_AREA | GRID_MOVE_MOVABLES | GRID_MOVE_TURF,
		/turf/baseturf_skipover/orbital_deployment,
		reservation.area_type,
		null,
		null,
		turf_overlap_handler,
		movable_overlap_handler,
	)

	translation.run_aftereffects(structural_area)

/datum/orbital_deployment_transit/proc/get_transit_ordered_turfs()
	var/list/from_lower_left_coords = reservation.bottom_left_coords.Copy()
	from_lower_left_coords[1] += packaged_border
	from_lower_left_coords[2] += packaged_border
	return SSgrids.get_ordered_turfs(
		from_lower_left_coords[1],
		from_lower_left_coords[1] + packaged_width - 1,
		from_lower_left_coords[2],
		from_lower_left_coords[2] + packaged_height - 1,
		from_lower_left_coords[3],
		NORTH,
	)

/datum/orbital_deployment_transit/proc/get_target_ordered_turfs()
	return SSgrids.get_ordered_turfs(
		target_lower_left.x,
		target_upper_right.x,
		target_lower_left.y,
		target_upper_right.y,
		target_lower_left.z,
		target_dir_from_north,
	)

/datum/orbital_deployment_transit/proc/telegraph(how_long)
	var/list/src_turfs = get_transit_ordered_turfs()
	var/list/dst_turfs = get_target_ordered_turfs()
	for(var/i in 1 to length(src_turfs))
		var/turf/source = src_turfs[i]
		if(source.type == reservation.turf_type)
			continue
		var/turf/dest = dst_turfs[i]
		new /atom/movable/render/orbital_deployment_telegraph(dest, how_long)
