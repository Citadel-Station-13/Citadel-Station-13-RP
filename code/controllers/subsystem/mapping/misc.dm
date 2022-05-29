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
			if((AM.flags & AF_ABSTRACT))
				continue
			if(istype(AM, /obj/effect/decal))
				qdel(AM)
				continue
			throwing += AM
	for(var/atom/movable/AM as anything in throwing)
		AM.throw_at(get_step(AM, dir), 5, 1)
