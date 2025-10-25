//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap
	/// friendly name, if any; generated if not
	var/name
	/// unique id
	var/id
	/// width in tiles
	var/width
	/// height in tiles
	var/height
	/// cached for speed
	var/lower_left_x
	/// cached for speed
	var/lower_left_y
	/// cached for speed
	var/upper_right_x
	/// cached for speed
	var/upper_right_y
	/// our turf reservation
	var/datum/map_reservation/reservation
	/// our template
	var/datum/overmap_template/template
	/// our area
	var/area/area

/datum/overmap/New(id, datum/overmap_template/template)
	src.id = id
	src.template = template

//* Init *//

/**
 * initializes an overmap from a template
 */
/datum/overmap/proc/initialize(datum/overmap_template/template = src.template)
	ASSERT(!SSovermaps.overmap_by_id[id])

	if(!template.initialized)
		template.initialize()

	construct(template)

	allocate()
	template.on_allocation(src)

	build(template)
	template.on_allocation_initialized(src)

	SSovermaps.overmap_by_id[id] = src
	return TRUE

/**
 * constructs our parameters from template
 */
/datum/overmap/proc/construct(datum/overmap_template/template)
	src.width = template.width
	src.height = template.height

/**
 * allocates our reservation block
 */
/datum/overmap/proc/allocate()
	if(reservation)
		CRASH("has reservation already")
	// alloc a 1 tile border
	reservation = SSmapping.request_block_reservation(
		width,
		height,
		area_override = /area/overmap,
		border = 1,
		border_initializer = CALLBACK(src, PROC_REF(reservation_border_initializer)),
	)
	lower_left_x = reservation.bottom_left_coords[1]
	lower_left_y = reservation.bottom_left_coords[2]
	upper_right_x = reservation.top_right_coords[1]
	upper_right_y = reservation.top_right_coords[2]
	var/area/overmap/created_area = reservation.reservation_area
	created_area.overmap = src
	area = created_area
	return reservation

/**
 * builds and initializes our map, which is usually blank unless a template put stuff in.
 */
/datum/overmap/proc/build()
	initialize_inner_turfs()

/**
 * Keeps this idempotent. This has to be re-invoked if something
 * loads an overmap .dmm into us.
 */
/datum/overmap/proc/initialize_inner_turfs()
	var/list/turf/map_turfs = reservation.unordered_inner_turfs()
	for(var/turf/turf as anything in map_turfs)
		var/turf/overmap/map/map_tile = turf.ChangeTurf(/turf/overmap/map)
		map_tile.initialize_overmap(src)
		CHECK_TICK

/**
 * makes a border turf
 */
/datum/overmap/proc/reservation_border_initializer(turf/border, datum/map_reservation/reservation)
	var/turf/overmap/edge/edge = border.ChangeTurf(/turf/overmap/edge)
	edge.initialize_border(src, reservation)
	edge.initialize_overmap(src)

//* Query *//

/datum/overmap/proc/query_random_placement_location()
	var/turf/approximate_midpoint = reservation.get_approximately_center_turf()
	var/const/reasonable_border = 5
	var/midpoint_x = approximate_midpoint.x
	var/midpoint_y = approximate_midpoint.y
	return query_closest_reasonable_open_space(
		locate(
			rand(min(reservation.bottom_left_coords[1] + reasonable_border, midpoint_x), max(reservation.top_right_coords[1] - reasonable_border, midpoint_x)),
			rand(min(reservation.bottom_left_coords[2] + reasonable_border, midpoint_y), max(reservation.top_right_coords[2] - reasonable_border, midpoint_y)),
			reservation.bottom_left_coords[3],
		),
	)

/**
 * @params
 * * where - epicenter
 * * i_insist - ask very strongly, thus that we ignore things like event cloud checks.
 */
/datum/overmap/proc/query_closest_reasonable_open_space(turf/where, i_insist) as /turf
	if(where.z != reservation.bottom_left_coords[3])
		return null
	if(query_is_reasonable_open_space(where))
		return where
	var/max_radius = 5
	// todo: spiral_range_turfs_invoking or something to break immediately
	var/list/turf/returned = spiral_range_turfs(max_radius, where, TRUE)
	return length(returned) ? pick(returned) : where

/datum/overmap/proc/query_is_reasonable_open_space(turf/where, i_insist)
	return i_insist ? !(locate(/obj/overmap/entity) in where) : !(locate(/obj/overmap) in where)
