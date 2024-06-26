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

/datum/overmap/proc/initialize(datum/overmap_template/template = src.template)
	construct(template)
	allocate()
	ASSERT(reservation)
	build_map(template)

/datum/overmap/proc/allocate()
	if(reservation)
		CRASH("has reservation already")
	// alloc a 1 tile border
	reservation = SSmapping.request_block_reservation(
		width,
		height,
		area_override = /area/overmap,
		border = 1,
		border_handler = CALLBACK(src, PROC_REF(reservation_border_handler)),
		border_initializer = CALLBACK(src, PROC_REF(reservation_border_initializer)),
	)
	if(!reservation)
		CRASH("failed to allocate")
	return reservation

/datum/overmap/proc/construct(datum/overmap_template/template)
	src.width = template.width
	src.height = template.height

/datum/overmap/proc/build_map(datum/overmap_template/template)
	#warn impl

/**
 * handles when something touches our border
 */
/datum/overmap/proc/reservation_border_handler(atom/movable/AM)
	#warn impl looping

/**
 * makes a border turf
 */
/datum/overmap/proc/reservation_border_initializer(turf/border)
	border.ChangeTurf(/turf/overmap/edge)
