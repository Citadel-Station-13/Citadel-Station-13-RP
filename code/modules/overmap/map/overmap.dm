//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
	var/datum/turf_reservation/reservation
	/// our template
	var/datum/overmap_template/template

/datum/overmap/New(id, datum/overmap_template/template)
	src.id = id
	src.template = template

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
	return reservation

/**
 * constructs our parameters from template
 */
/datum/overmap/proc/construct(datum/overmap_template/template)
	src.width = template.width
	src.height = template.height

/**
 * builds and initializes our map, which is usually blank unless a template put stuff in.
 */
/datum/overmap/proc/build()
	var/list/turf/map_turfs = reservation.unordered_inner_turfs()
	for(var/turf/turf as anything in map_turfs)
		var/turf/overmap/map/map_tile = turf.ChangeTurf(/turf/overmap/map)
		map_tile.initialize_overmap(src)


/**
 * makes a border turf
 */
/datum/overmap/proc/reservation_border_initializer(turf/border, datum/turf_reservation/reservation)
	var/turf/overmap/edge/edge = border.ChangeTurf(/turf/overmap/edge)
	edge.initialize_border(src, reservation)
	edge.initialize_overmap(src)
