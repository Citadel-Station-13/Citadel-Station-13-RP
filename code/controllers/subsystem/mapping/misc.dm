/**
 * stuff that really just didn't fit anywhere
 * unlike most "legacy" citrp files, things in here are allowed to be used and will be optimized & maintained.
 */
/datum/controller/subsystem/mapping/proc/z_turfs_of_type(z, list/type_or_cache)
	. = list()
	if(ispath(type_or_cache))
		for(var/turf/T as anything in block(locate(1, 1, z), locate(world.maxx, world.maxy, z)))
			if(istype(T, type_or_cache))
				. += T
	else if(islist(type_or_cache))
		for(var/turf/T as anything in block(locate(1, 1, z), locate(world.maxx, world.maxy, z)))
			if(type_or_cache[T.type])
				. += T
	else
		CRASH("What?")

/**
 * *sigh*
 */
/datum/controller/subsystem/mapping/proc/throw_movables_on_z_turfs_of_type(z, list/type_or_cache, dir)
	ASSERT(dir in GLOB.cardinal)
	var/list/throwing = list()
	for(var/turf/T as anything in z_turfs_of_type(z, type_or_cache))
		for(var/atom/movable/AM as anything in T)
			if(AM.anchored)
				continue
			if((AM.flags & ATOM_ABSTRACT))
				continue
			if(istype(AM, /obj/effect/decal))
				qdel(AM)
				continue
			throwing += AM
	for(var/atom/movable/AM as anything in throwing)
		AM.throw_at_old(get_step(AM, dir), 5, 1)

/**
 * Picks a random space turf from crosslinked levels
 */
/datum/controller/subsystem/mapping/proc/random_crosslinked_space_turf()
	var/list/levels = GetCrosslinked()
	levels = shuffle(levels)
	for(var/z in levels)
		var/list/potential = list()
		for(var/turf/open/space/S in block(locate(2, 2, z), locate(world.maxx - 1, world.maxy - 1, z)))
			potential += S
		. = safepick(potential)
		if(.)
			break

/**
 * Picks a random space turf from station levels
 */
/datum/controller/subsystem/mapping/proc/random_station_space_turf()
	var/list/levels = LevelsByTrait(ZTRAIT_STATION)
	levels = shuffle(levels)
	for(var/z in levels)
		var/list/potential = list()
		for(var/turf/open/space/S in block(locate(2, 2, z), locate(world.maxx - 1, world.maxy - 1, z)))
			potential += S
		. = safepick(potential)
		if(.)
			break

/**
 * Finds the center turf of the "first" (UNSORTED, SO MIGHT BE RANDOM) station leve.
 */
/datum/controller/subsystem/mapping/proc/get_station_center()
	var/list/station_z = LevelsByTrait(ZTRAIT_STATION)
	if(!station_z.len)		// wtf...
		return
	return locate(round(world.maxx * 0.5, 1), round(world.maxy * 0.5, 1), station_z[1])
