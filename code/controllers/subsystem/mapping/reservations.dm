//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * turf reservation system
 */
/datum/controller/subsystem/mapping
	/// reserved levels allocated
	var/static/reserved_level_count = 0
	/// reserved turfs allowed - we can over-allocate this if we're only going to be slightly over and can always allocate atleast one level.
	var/static/reserved_turfs_max = 192 * 192 * 3
	/// allocated space reservations
	var/static/list/datum/turf_reservation/reservations = list()
	/// list of reserved z-indices for fast access
	var/static/list/reserve_levels = list()
	/// doing some blocking op on reservation system
	var/static/reservation_blocking_op = FALSE
	/// singleton area holding all free reservation turfs
	var/static/area/unused_reservation_area/unallocated_reserve_area = new

/datum/controller/subsystem/mapping/Recover()
	. = ..()
	reservation_blocking_op = FALSE

/**
 * allocate a new reservation level
 */
/datum/controller/subsystem/mapping/proc/allocate_reserved_level()
	if(reserved_level_count && ((world.maxx * world.maxy * (reserved_level_count + 1)) > reserved_turfs_max))
		log_and_message_admins(SPAN_USERDANGER("Out of dynamic reservation allocations. Is there a memory leak with turf reservations?"))
		return FALSE
	log_and_message_admins(SPAN_USERDANGER("Allocating new reserved level. Now at [reserved_level_count]. This is probably not a good thing if the server is not at high load right now."))
	var/datum/map_level/reserved/level_struct = new
	ASSERT(allocate_level(level_struct))
	reserved_level_count++
	initialize_reserved_level(level_struct.z_index)
	reserve_levels |= level_struct.z_index
	return level_struct.z_index

/**
 * requests a rectangular block of turfs to be reserved.
 *
 * you *must* manually clean it up after you're done with it, or else it's a memory leak.
 *
 * failures are considered a runtime due to how sensitive turf management systems are.
 *
 * @params
 * * width - width of reserved block
 * * height - height of reserved block
 * * type - /datum/turf_reservation type to make
 * * turf_override - init turf contents to type instead of world.area
 * * area_override - init area typepath to type instead of world.area
 * * border - border turfs; these are outside of the allocation.
 * * border_handler - what callback to call with (atom/movable/mover) when something crosses the border.
 * * border_initializer - what callback to call with (turf/bordering) on every border turf to init them. defaults to just making loop-back turfs
 */
/datum/controller/subsystem/mapping/proc/request_block_reservation(width, height, type = /datum/turf_reservation, turf_override, area_override, border, datum/callback/border_handler, datum/callback/border_initializer)
	#warn impl border, border_handler, border_initializer
	var/datum/turf_reservation/reserve = new type
	if(!isnull(turf_override))
		reserve.turf_type = turf_override
	if(!isnull(area_override))
		reserve.area_type = area_override
	if(reserve.reserve(width, height))
		return reserve
	var/index = allocate_reserved_level()
	ASSERT(index)
	if(reserve.reserve(width, height, index))
		return reserve
	QDEL_NULL(reserve)
	CRASH("failed to reserve")

/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	var/list/turf/turfs = Z_TURFS(z)
	reserve_turfs(turfs)

/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turf/turfs)
	for(var/turf/T as anything in turfs)
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE)
		T.turf_flags |= TURF_FLAG_UNUSE_RESERVATION
		CHECK_TICK
	// todo: area.assimilate_turfs?
	unallocated_reserve_area.contents.Add(turfs)

/area/unused_reservation_area
	name = "Unused Reservation Area"
	unique = TRUE
	always_unpowered = TRUE
	has_gravity = FALSE
