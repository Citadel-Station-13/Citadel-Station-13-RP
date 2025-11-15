//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(orbital_deployment_zones)

/**
 * * markers are used instead of turfs because we can be put on a shuttle, which will translate markers
 *   but turf refs would stay behind
 */
/datum/orbital_deployment_zone
	/// unique ID, if any
	var/id
	#warn impl id

	var/obj/orbital_deployment_marker/lower_left
	var/obj/orbital_deployment_marker/lower_right
	var/obj/orbital_deployment_marker/upper_right
	var/obj/orbital_deployment_marker/upper_left

	/// linked consoles
	var/list/obj/machinery/orbital_deployment_controller/controllers

	/// are we armed?
	var/armed = FALSE
	/// when were we armed?
	var/armed_time

	var/c_impact_obj_dmg_base = 15
	var/c_impact_obj_dmg_sides = 15
	var/c_impact_obj_dmg_cnt = 5
	var/c_impact_mob_dmg_base = 15
	var/c_impact_mob_dmg_sides = 10
	var/c_impact_mob_dmg_cnt = 10
	var/c_landing_obj_dmg_base = 15
	var/c_landing_obj_dmg_sides = 15
	var/c_landing_obj_dmg_cnt = 5
	var/c_landing_mob_dmg_base = 5
	var/c_landing_mob_dmg_sides = 15
	var/c_landing_mob_dmg_cnt = 10

	var/area/current_area

#warn impl

/datum/orbital_deployment_zone/New(
	obj/orbital_deployment_marker/lower_left,
	obj/orbital_deployment_marker/lower_right,
	obj/orbital_deployment_marker/upper_right,
	obj/orbital_deployment_marker/upper_left,
)
	if(!id)
		// todo: stupid way to generate ids tbh but whatever
		id = GUID()

	src.lower_left = lower_left
	src.lower_right = lower_right
	src.upper_right = upper_right
	src.upper_left = upper_left

	if(GLOB.orbital_deployment_zones[id])
		stack_trace("duplicate id [id], this zone will not be registered")
		QDEL_IN(src, 0)
	else
		GLOB.orbital_deployment_zones[id] = src

	for(var/obj/orbital_deployment_marker/corner/marker as anything in list(
		lower_left,
		lower_right,
		upper_right,
		upper_left,
	))
		marker.zone_built = TRUE
		marker.zone = src

/datum/orbital_deployment_zone/Destroy()
	for(var/obj/machinery/orbital_deployment_controller/controller in controllers)
		controller.unlink_zone()
	GLOB.orbital_deployment_zones -= id
	for(var/obj/orbital_deployment_marker/corner/marker as anything in list(
		lower_left,
		lower_right,
		upper_right,
		upper_left,
	))
		if(marker.zone != src)
			stack_trace("uh oh! marker zone mismatch; this should never happen!")
		else
			marker.zone = null
	lower_left = lower_right = upper_right = upper_left = null
	return ..()

/datum/orbital_deployment_zone/proc/construct_initial()

	construct_zone()

/datum/orbital_deployment_zone/proc/construct_zone()
	if(lower_left.z != upper_right.z)
		CRASH("LL/UR not on same z?")
	if(!isturf(lower_left.loc))
		CRASH("LL not on turf")
	if(!isturf(upper_right.loc))
		CRASH("UR not on turf")
	if((upper_right.x - lower_left.x) < 2 || (upper_right.y - lower_left.y) < 2)
		CRASH("LL/UR markers swapped")

	var/turf/test_turf = get_step(lower_left, NORTHEAST)
	if(istype(test_turf.loc, /area/orbital_deployment_area))
		CRASH("tried to write-over a zone (lower-left test failed)")
	var/list/turf/inside_zone = block(get_step(lower_left, NORTHEAST), get_step(upper_right, SOUTHWEST))
	var/area/orbital_deployment_area/deployment_area = new(null)
	current_area = deployment_area


	#warn impl

/**
 * Clears out whatever of the zone is still left.
 */
/datum/orbital_deployment_zone/proc/cleanup_zone()
	#warn impl

/**
 * TODO: This shouldn't be instant, it should blast the pod out as an overmap entity, like a shuttle.
 */
/datum/orbital_deployment_zone/proc/launch()
	#warn params

/**
 * * input dir is with NORTH as 'do not rotate'
 * * keep in mind this returns TRUE if it's physically possible to translate, even if the player shouldn't be allowed to.
 * @return TRUE if it's safe to translate, codewise, FALSE otherwise
 */
/datum/orbital_deployment_zone/proc/check_zone(turf/target_center, dir, list/warnings_out, list/errors_out)

/**
 * @return true / false
 */
/datum/orbital_deployment_zone/proc/yeet_zone(turf/target_center, rotation_degrees)

	var/wanted_dir = math__angle_to_dir_exact_or_throw(rotation_degrees)

	var/list/measured = measure_current_dimensions()
	var/width = measured[1]
	var/height = measured[2]

	if(target_lower_left.x <)

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

	cleanup_zone()
	construct_zone()

/**
 * @return width, height
 */
/datum/orbital_deployment_zone/proc/measure_current_dimensions()
	#warn impl

/datum/orbital_deployment_zone/proc/get_frame_width()
	return (upper_right.x - lower_left.x) - 1

/datum/orbital_deployment_zone/proc/get_frame_height()
	return (upper_right.y - lower_left.y) - 1

/datum/orbital_deployment_zone/proc/on_launch()

/datum/orbital_deployment_zone/proc/contains_turf(turf/T)
	#warn impl
