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
	var/static/area/unused_reservation_area/reservation_unallocated_area = new
	/// spatial grid of turf reservations. the owner of a chunk is the bottom left tile's owner.
	///
	/// this is a list with length of world.maxz, with the actual spatial grid list being at the index of the z
	/// e.g. to grab a reserved level's lookup, do `reservation_spatia_lookups[z_index]`
	///
	/// * null means that a level isn't a reservation level
	/// * this also means that we can't zclear / 'free' reserved levels; they're effectively immovable due to this datastructure
	/// * if it is a reserved level, it returns the spatial grid
	/// * to get a chunk, do `spatial_lookup[ceil(where.x / TURF_CHUNK_RESOLUTION) + (ceil(where.y / TURF_CHUNK_RESOLUTION) - 1) * ceil(world.maxx / TURF_CHUNK_RESOLUTION)]`
	var/static/list/reservation_spatial_lookups = list()

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	if(length(reservation_spatial_lookups) < new_z_count)
		reservation_spatial_lookups.len = new_z_count

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
	if(reserved_level_count)
		log_and_message_admins(SPAN_USERDANGER("Allocating new reserved level. Now at [reserved_level_count + 1]. This is probably not a good thing if the server is not at high load right now."))
	reserved_level_count++
	var/datum/map_level/reserved/level_struct = new
	ASSERT(allocate_level(level_struct))
	initialize_reserved_level(level_struct.z_index)
	reserve_levels |= level_struct.z_index
	// make a list with a predetermined size for the lookup
	reservation_spatial_lookups[level_struct.z_index] = new /list(ceil(world.maxx / TURF_CHUNK_RESOLUTION) * ceil(world.maxy / TURF_CHUNK_RESOLUTION))
	return level_struct.z_index

/**
 * requests a rectangular block of turfs to be reserved.
 *
 * you *must* manually clean it up after you're done with it, or else it's a memory leak.
 *
 * failures are considered a runtime due to how sensitive turf management systems are.
 */
/datum/controller/subsystem/mapping/proc/request_block_reservation(width, height, type = /datum/turf_reservation, turf_override, border_override, area_override)
	var/datum/turf_reservation/reserve = new type
	if(!isnull(turf_override))
		reserve.turf_type = turf_override
	if(!isnull(border_override))
		reserve.border_type = border_override
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
		T.turf_flags |= UNUSED_RESERVATION_TURF
		CHECK_TICK
	// todo: area.assimilate_turfs?
	reservation_unallocated_area.contents.Add(turfs)

/**
 * @return turf reservation someone's in, or null if they're not in a reservation
 */
/datum/controller/subsystem/mapping/proc/get_turf_reservation(atom/where)
	where = get_turf(where)
	if(!where)
		return
	// this doubles as 'is this a reserved level'
	var/list/spatial_lookup = reservation_spatial_lookups[where.z]
	if(!spatial_lookup)
		return
	return spatial_lookup[ceil(where.x / TURF_CHUNK_RESOLUTION) + (ceil(where.y / TURF_CHUNK_RESOLUTION) - 1) * ceil(world.maxx / TURF_CHUNK_RESOLUTION)]

/area/unused_reservation_area
	name = "Unused Reservation Area"
	unique = TRUE
	always_unpowered = TRUE
	has_gravity = FALSE
