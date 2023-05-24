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
	var/static/reformatting_reserved_turfs = FALSE
	/// singleton area holding all free reservation turfs
	var/static/area/unused_reservation_area/unallocated_reserve_area = new

/datum/controller/subsystem/mapping/Recover()
	. = ..()
	reformatting_reserved_turfs = FALSE

/**
 * allocate a new reservation level
 */


#warn oh no

/datum/controller/subsystem/mapping

/*
/datum/controller/subsystem/mapping/proc/safety_clear_transit_dock(obj/docking_port/stationary/transit/T, obj/docking_port/mobile/M, list/returning)
	M.setTimer(0)
	var/error = M.initiate_docking(M.destination, M.preferred_direction)
	if(!error)
		returning += M
		qdel(T, TRUE)
*/

/**
 *
 *
 *
 * wip doc
 */
/datum/controller/subsystem/mapping/proc/request_block_reservation(width, height, type = /datum/turf_reservation, turf_override, border_override, area_override)
	UNTIL((!z || reservation_ready["[z]"]) && !clearing_reserved_turfs)
	var/datum/turf_reservation/reserve = new type
	if(!isnull(turf_override))
		reserve.turf_type = turf_override
	if(!isnull(border_override))
		reserve.border_type = border_override
	if(!isnull(area_override))
		reserve.area_type = area_override
	#warn below
	for(var/i in levels_by_trait(ZTRAIT_RESERVED))
		if(reserve.Reserve(width, height, i))
			return reserve
	//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
	num_of_res_levels += 1
	var/datum/space_level/newReserved = add_new_zlevel("Transit/Reserved [num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE))
	initialize_reserved_level(newReserved.z_value)
	if(reserve.Reserve(width, height, newReserved.z_value))
		return reserve
	QDEL_NULL(reserve)

/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	#warn SCREAM
	UNTIL(!clearing_reserved_turfs)				//regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE			//This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.
	if(!level_trait(z,ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")
	var/turf/A = get_turf(locate(SHUTTLE_TRANSIT_BORDER,SHUTTLE_TRANSIT_BORDER,z))
	var/turf/B = get_turf(locate(world.maxx - SHUTTLE_TRANSIT_BORDER,world.maxy - SHUTTLE_TRANSIT_BORDER,z))
	var/block = block(A, B)
	for(var/t in block)
		// No need to empty() these, because it's world init and they're
		// already /turf/space/basic.
		var/turf/T = t
		T.turf_flags |= UNUSED_RESERVATION_TURF
	unused_turfs["[z]"] = block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE


/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turf/turfs)
	for(var/turf/T as anything in turfs)
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE)
		T.turf_flags |= UNUSED_RESERVATION_TURF
		T.loc = unallocated_reserve_area
		CHECK_TICK

/area/unused_reservation_area
	name = "Unused Reservation Area"
	area_flags = UNIQUE_AREA
	always_unpowered = TRUE
	has_gravity = FALSE
