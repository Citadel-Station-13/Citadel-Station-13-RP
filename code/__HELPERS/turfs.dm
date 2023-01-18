/**
 * Returns the atom sitting on the turf.
 * For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
 */
/proc/get_atom_on_turf(atom/movable/AM)
	var/atom/mloc = AM
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))

/proc/turf_clear(turf/T)
	for(var/atom/A in T)
		if(!(A.atom_flags & ATOM_ABSTRACT))
			return 0
	return 1

/**
 * Picks a turf without a mob from the given list of turfs, if one exists.
 * If no such turf exists, picks any random turf from the given list of turfs.
 */
/proc/pick_mobless_turf_if_exists(list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/**
 * Picks a turf that is clearance tiles away from the map edge given by dir, on z-level Z.
 */
/proc/pick_random_edge_turf(dir, Z, clearance = TRANSITIONEDGE + 1)
	if(!dir)
		return
	switch(dir)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/proc/is_below_sound_pressure(turf/T)
	var/pressure =  T.return_pressure() || 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/**
 *! Turf Manipulation
 */

/**
 * Returns an assoc list that describes how turfs would be changed if the
 * Turfs in turfs_src were translated by shifting the src_origin to the dst_origin
 */
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			log_debug(SPAN_DEBUGERROR("Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos] [ADMIN_JMP(dst_origin)])"))
		// If target is null, preserve that information in the turf map.
		turf_map[source] = target

	return turf_map

/proc/translate_turfs(list/translation, area/base_area = null, turf/base_turf)
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area)
				ChangeArea(target, get_area(source))
			var/leave_turf = base_turf ? base_turf : /turf/simulated/floor/plating
			translate_turf(source, target, leave_turf)
			if(base_area)
				ChangeArea(source, base_area)

	// Change the old turfs (Currently done by translate_turf for us)
	// for(var/turf/source in translation)
	// 	source.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(source), 1, 1)

/proc/translate_turf(turf/Origin, turf/Destination, turftoleave = null)

	// You can stay, though.
	if (istype(Origin, /turf/space))
		log_debug(SPAN_DEBUGERROR("Tried to translate a space turf: src=[log_info_line(Origin)][ADMIN_JMP(Origin)] dst=[log_info_line(Destination)][ADMIN_JMP(Destination)]"))
		return FALSE	// TODO - Is this really okay to do nothing?

	var/turf/X	// New Destination Turf

	var/old_dir1 = Origin.dir
	var/old_icon_state1 = Origin.icon_state
	var/old_icon1 = Origin.icon
	var/old_underlays = Origin.underlays.Copy()
	var/old_decals = Origin.decals ? Origin.decals.Copy() : null

	X = Destination.PlaceOnTop(Origin.type)
	X.setDir(old_dir1)
	X.icon_state = old_icon_state1
	X.icon = old_icon1
	X.copy_overlays(Origin, TRUE)
	X.underlays = old_underlays
	X.decals = old_decals

	/// Move the air from source to dest.
	var/turf/simulated/ST = Origin
	if (istype(ST))
		var/turf/simulated/SX = X
		if(!SX.air)
			SX.make_air()
		SX.air.copy_from(ST.copy_cell_volume())

	var/z_level_change = FALSE
	if (Origin.z != X.z)
		z_level_change = TRUE

	// Move the objects. Not forceMove because the object isn't "moving" really, it's supposed to be on the "same" turf.
	for(var/obj/O in Origin)
		if(O.atom_flags & ATOM_ABSTRACT)
			continue
		O.loc = X
		O.update_light()
		// The objects still need to know if their z-level changed.
		if (z_level_change)
			O.onTransitZ(Origin.z, X.z)

	// Move the mobs unless it's an AI eye or other eye type.
	for(var/mob/M in Origin)
		if (M.atom_flags & ATOM_ABSTRACT)
			continue
		if (isEye(M))
			// If we need to check for more mobs, I'll add a variable.
			continue
		M.loc = X

		// Same goes for mobs.
		if (z_level_change)
			M.onTransitZ(Origin.z, X.z)

	if (turftoleave)
		Origin.ChangeTurf(turftoleave)
	else
		Origin.ScrapeAway()

	return TRUE

/**
 * Used for border objects. This returns true if this atom is on the border between the two specified turfs.
 * This assumes that the atom is located inside the target turf.
 */
/atom/proc/is_between_turfs(turf/origin, turf/target)
	if (atom_flags & ATOM_BORDER)
		var/testdir = get_dir(target, origin)
		return (dir & testdir)
	return TRUE
