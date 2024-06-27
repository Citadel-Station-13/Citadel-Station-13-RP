//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/overmap
	/// friendly name, if any; generated if not
	var/name
	/// unique id
	var/id
	#warn cross-round id
	/// width in tiles
	var/width
	/// height in tiles
	var/height
	/// our turf reservation
	var/datum/turf_reservation/reservation
	/// our template
	var/datum/overmap_template/template

#warn impl

/datum/overmap/New(id, datum/overmap_template/template)
	src.id = id
	src.template = template

/**
 * initializes an overmap from a template
 */
/datum/overmap/proc/initialize(datum/overmap_template/template = src.template)
	construct(template)

	allocate()
	template.on_allocation(src)

	build(template)
	template.on_allocation_initialized(src)

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
	var/list/turf/map_turfs = reservation.inner_turfs.Copy()
	for(var/turf/turf as anything in map_turfs)
		
	#warn impl

/**
 * makes a border turf
 */
/datum/overmap/proc/reservation_border_initializer(turf/border, datum/turf_reservation/reservation)
	var/turf/overmap/edge/edge = border.ChangeTurf(/turf/overmap/edge)
	edge.initialize_overmap(src)
