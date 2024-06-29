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

#warn impl

/datum/overmap/proc/initialize(datum/overmap_template/template)
	construct(template)
	allocate()
	ASSERT(reservation)
	build_map(template)

/datum/overmap/proc/allocate()
	if(reservation)
		CRASH("has reservation already")
	// alloc a 1 tile border
	reservation = SSmapping.request_block_reservation(width + 2, height + 2)
	if(!reservation)
		CRASH("failed to allocate")
	return reservation

/datum/overmap/proc/construct(datum/overmap_template/template)
	src.width = template.width
	src.height = template.height

/datum/overmap/proc/build_map(datum/overmap_template/template)
	#warn impl

