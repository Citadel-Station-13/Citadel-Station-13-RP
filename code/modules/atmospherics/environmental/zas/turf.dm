/turf
	var/needs_air_update = FALSE

/turf/proc/has_valid_zone()
	return FALSE

/turf/simulated
	var/datum/zas_zone/zone
	var/open_directions
	/// Do we show gas overlays?
	var/allow_gas_overlays = TRUE

/turf/simulated/has_valid_zone()
	return zone && !zone.invalid

/turf/proc/update_air_properties()
	var/block = CanAtmosPass(src, NONE)
	if(block == ATMOS_PASS_AIR_BLOCKED)
		//dbg(blocked)
		return

	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/simulated/potential = get_step_multiz(src, d)

		if(!istype(potential) || !potential.has_valid_zone())
			continue

		block = potential.CanAtmosPass(src, REVERSE_DIR(d))

		if(block == ATMOS_PASS_AIR_BLOCKED)
			continue

		var/r_block = CanAtmosPass(potential, d)

		if(r_block == ATMOS_PASS_AIR_BLOCKED)
			continue

		air_master.connect(potential, src, min(block, r_block), d)

/*
	Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
	Instead of analyzing the entire zone, we only check the nearest 3x3 turfs surrounding the src turf.
	This implementation may produce false negatives but it (hopefully) will not produce any false postiives.
*/

/turf/simulated/proc/can_safely_remove_from_zone()
	if(!zone)
		return TRUE

	var/check_dirs = get_zone_neighbours(src)
	var/unconnected_dirs = check_dirs

	#ifdef MULTIZAS
	var/to_check = GLOB.cornerdirsz
	#else
	var/to_check = GLOB.cornerdirs
	#endif

	for(var/dir in to_check)
		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/connected_dirs = get_zone_neighbours(get_step(src, dir))
			if(connected_dirs && (dir & GLOB.reverse_dir[connected_dirs]) == dir)
				unconnected_dirs &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	return !unconnected_dirs

//helper for can_safely_remove_from_zone()
/turf/simulated/proc/get_zone_neighbours(turf/simulated/T)
	. = 0
	if(istype(T) && T.zone)
		#ifdef MULTIZAS
		var/to_check = GLOB.cardinalz
		#else
		var/to_check = GLOB.cardinal
		#endif
		for(var/dir in to_check)
			var/turf/simulated/other = get_step(T, dir)
			if(istype(other) && other.zone == T.zone && !(other.CanAtmosPass(T, REVERSE_DIR(dir)) == ATMOS_PASS_AIR_BLOCKED) && get_dist(src, other) <= 1)
				. |= dir

/turf/simulated/update_air_properties()
	if(zone?.invalid)
		c_copy_air()
		zone = null //Easier than iterating through the list at the zone.

	var/self_block = CanAtmosPass(src, NONE)
	if(self_block == ATMOS_PASS_AIR_BLOCKED)
		#ifdef ZAS_DEBUG_GRAPHICS
		if(verbose)
			to_chat(world, "Self-blocked.")
		//dbg(blocked)
		#endif
		if(zone)
			if(can_safely_remove_from_zone()) //Helps normal airlocks avoid rebuilding zones all the time
				zone.remove(src)
			else
				zone.rebuild()
		return

	var/previously_open = open_directions
	open_directions = NONE

	var/list/postponed
	var/list/postponed_dirs
	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/potential = get_step_multiz(src, d)
		if(!potential)
			continue
		var/them_to_us = potential.CanAtmosPass(src, REVERSE_DIR(d))
		if(them_to_us == ATMOS_PASS_AIR_BLOCKED)

			#ifdef ZAS_DEBUG_GRAPHICS
			if(verbose) to_chat(world, "[d] is blocked.")
			//unsim.dbg(air_blocked, turn(180,d))
			#endif

			continue

		var/us_to_them = CanAtmosPass(potential, d)
		if(us_to_them == ATMOS_PASS_AIR_BLOCKED)

			#ifdef ZAS_DEBUG_GRAPHICS
			if(verbose) to_chat(world, "[d] is blocked.")
			//dbg(air_blocked, d)
			#endif

			//Check that our zone hasn't been cut off recently.
			//This happens when windows move or are constructed. We need to rebuild.
			if((previously_open & d) && istype(potential, /turf/simulated))
				var/turf/simulated/S = potential
				if(zone && S.zone == zone)
					zone.rebuild()
					return

			continue

		open_directions |= d

		if(istype(potential, /turf/simulated))
			var/turf/simulated/S = potential
			S.open_directions |= REVERSE_DIR(d)
			if(S.has_valid_zone())
				//Might have assigned a zone, since this happens for each direction.
				if(!zone)

					//We do not merge if
					//    they are blocking us and we are not blocking them, or if
					//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
					if(((them_to_us == ATMOS_PASS_ZONE_BLOCKED) && (us_to_them != ATMOS_PASS_ZONE_BLOCKED)) || ((us_to_them == ATMOS_PASS_ZONE_BLOCKED) && (self_block != ATMOS_PASS_ZONE_BLOCKED)))
						#ifdef ZAS_DEBUG_GRAPHICS
						if(verbose)
							to_chat(world, "[d] is zone blocked.")
						//dbg(zone_blocked, d)
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						LAZYSET(postponed, potential, min(them_to_us, us_to_them))
						LAZYSET(postponed_dirs, potential, d)
					else
						S.zone.add(src)

						#ifdef ZAS_DEBUG_GRAPHICS
						dbg(assigned)
						if(verbose) to_chat(world, "Added to [zone]")
						#endif

				else if(S.zone != zone)

					#ifdef ZAS_DEBUG_GRAPHICS
					if(verbose)
						to_chat(world, "Connecting to [sim.zone]")
					#endif

					air_master.connect(src, potential, min(them_to_us, us_to_them), d)

			#ifdef ZAS_DEBUG_GRAPHICS
				else if(verbose)
					to_chat(world, "[d] has same zone.")

			else if(verbose)
				to_chat(world, "[d] has invalid zone.")
			#endif

		else
			//Postponing connections to tiles until a zone is assured.
			LAZYSET(postponed, potential, min(them_to_us, us_to_them))
			LAZYSET(postponed_dirs, potential, d)

	if(!has_valid_zone()) //Still no zone, make a new one.
		var/datum/zas_zone/newzone = new
		newzone.add(src)

	#ifdef ZAS_DEBUG_GRAPHICS
		dbg(created)
	#endif

	#ifdef ZAS_ASSERTIONS
	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.

	for(var/turf/T as anything in postponed)
		air_master.connect(src, T, postponed[T], postponed_dirs[T])

/turf/proc/post_update_air_properties()
	connections?.update_all()

/turf/proc/make_air()
	air = new /datum/gas_mixture
	air.copy_from_turf(src)
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/turf/simulated/proc/c_copy_air()
	if(!air)
		air = new /datum/gas_mixture
	air.copy_from(zone.air)
	air.group_multiplier = 1
