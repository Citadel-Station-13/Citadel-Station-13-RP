//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * allocate a new reservation level
 */
/datum/controller/subsystem/mapping/proc/allocate_reserved_level()
	if(reservation_level_count && ((world.maxx * world.maxy * (reservation_level_count + 1)) > reservation_turf_limit))
		log_and_message_admins(SPAN_USERDANGER("Out of dynamic reservation allocations. Is there a memory leak with turf reservations?"))
		return FALSE
	if(reservation_level_count)
		log_and_message_admins(SPAN_USERDANGER("Allocating new reserved level. Now at [reservation_level_count + 1]. This is potentially not a good thing if the server is not at high load right now."))
	reservation_level_count++
	var/datum/map_level/level_struct = allocate_level(/datum/map_level/reserved)
	ASSERT(level_struct)
	initialize_reservation_level(level_struct.z_index)
	reservation_levels |= level_struct.z_index
	// make a list with a predetermined size for the lookup
	reservation_spatial_lookups[level_struct.z_index] = new /list(ceil(world.maxx / TURF_CHUNK_RESOLUTION) * ceil(world.maxy / TURF_CHUNK_RESOLUTION))
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
 * * type - /datum/map_reservation type to make
 * * turf_override - init turf contents to type instead of world.area
 * * area_override - init area typepath to type instead of world.area
 * * border - border turfs; these are outside of the allocation.
 * * border_handler - what callback to call with (atom/movable/mover) when something crosses the border. the handler should always evict the atom from the border turfs!
 * * border_initializer - what callback to call with (turf/bordering) on every border turf to init them. defaults to just making loop-back turfs
 */
/datum/controller/subsystem/mapping/proc/request_block_reservation(width, height, type = /datum/map_reservation, turf_override, area_override, border, datum/callback/border_handler, datum/callback/border_initializer)
	var/datum/map_reservation/reserve = new type
	if(!isnull(turf_override))
		reserve.turf_type = turf_override
	if(!isnull(area_override))
		reserve.area_type = area_override
	if(border_handler)
		reserve.border_handler = border_handler
	if(border_initializer)
		reserve.border_initializer = border_initializer
	if(reserve.reserve(width, height, border))
		return reserve
	var/index = allocate_reserved_level()
	ASSERT(index)
	if(reserve.reserve(width, height, border, index))
		return reserve
	QDEL_NULL(reserve)
	CRASH("failed to reserve")

/datum/controller/subsystem/mapping/proc/initialize_reservation_level(z)
	var/list/turf/turfs = Z_TURFS(z)
	initialize_unused_reservation_turfs(turfs)

/datum/controller/subsystem/mapping/proc/initialize_unused_reservation_turfs(list/turf/turfs)
	for(var/turf/T as anything in turfs)
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE)
		T.turf_flags |= TURF_FLAG_UNUSED_RESERVATION
		CHECK_TICK
	// todo: area.assimilate_turfs?
	reservation_unallocated_area.contents.Add(turfs)

/**
 * @return turf reservation someone's in, or null if they're not in a reservation
 */
/datum/controller/subsystem/mapping/proc/get_turf_reservation(atom/where)
	return reservation_spatial_lookups[get_z(where)]?[ceil(where.x / TURF_CHUNK_RESOLUTION) + (ceil(where.y / TURF_CHUNK_RESOLUTION) - 1) * ceil(world.maxx / TURF_CHUNK_RESOLUTION)]

/area/reservation_unused
	name = "Unallocated Reservation Area"
	unique = TRUE
	always_unpowered = TRUE
	has_gravity = FALSE
