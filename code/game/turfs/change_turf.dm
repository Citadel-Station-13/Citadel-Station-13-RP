// This is a list of turf types we dont want to assign to baseturfs unless through initialization or explicitly
GLOBAL_LIST_INIT(blacklisted_automated_baseturfs, typecacheof(list(
	/turf/space,
	/turf/baseturf_bottom,
	/turf/simulated/open,
	)))

/// list of turf types that are logically "below" the last turf layer, and are therefore things we should inject above when doing things like injecting shuttle ceilings
GLOBAL_LIST_INIT(multiz_hole_baseturfs, typecacheof(list(
	/turf/space,
	/turf/simulated/open,
	/turf/baseturf_bottom,
)))

/turf/proc/empty(turf_type=/turf/space, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/observer, /obj/landmark, /atom/movable/lighting_object, /obj/effect/shuttle_landmark))
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		ChangeTurf(turf_type)

/turf/proc/CopyTurf(turf/T, copy_flags = NONE)
	if(T.type != type)
		T.ChangeTurf(type)
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	return T

//wrapper for ChangeTurf()s that you want to prevent/affect without overriding ChangeTurf() itself
/turf/proc/TerraformTurf(path, new_baseturf, flags)
	return ChangeTurf(path, new_baseturf, flags)

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, flags)
	switch(path)
		if(null)
			return
		if(/turf/baseturf_bottom)
			path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || GLOB.using_map.base_turf_by_z["[z]"] || /turf/space
			if(!ispath(path))
				path = text2path(path)
				if (!ispath(path))
					warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
					path = /turf/space
			if(path == /turf/space)		// no space/basic check, if you use space/basic in a map honestly get bent
				if(istype(GetBelow(src), /turf/simulated))
					path = /turf/simulated/open
		if(/turf/space/basic)
			// basic doesn't initialize and this will cause issues
			// no warning though because this can happen naturaly as a result of it being built on top of
			if(istype(GetBelow(src), /turf/simulated))
				path = /turf/simulated/open
			else
				path = /turf/space
		if(/turf/space)
			if(istype(GetBelow(src), /turf/simulated))
				path = /turf/simulated/open
		if(/turf/simulated/open)
			if(istype(GetBelow(src), /turf/space))
				path = /turf/space

	if(!GLOB.use_preloader && path == type && !(flags & CHANGETURF_FORCEOP) && (baseturfs == new_baseturfs)) // Don't no-op if the map loader requires it to be reconstructed, or if this is a new set of baseturfs
		return src
	if(flags & CHANGETURF_SKIP)
		return new path(src)

	// store lighting
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_object = lighting_object
	var/old_lc_topright = lc_topright
	var/old_lc_topleft = lc_topleft
	var/old_lc_bottomright = lc_bottomright
	var/old_lc_bottomleft = lc_bottomleft

	// store/invalidae atmos
	var/atom/movable/fire/old_fire = fire
	if(connections)
		connections.erase_all()

	// store planet stuff
	var/old_outdoors = outdoors
	var/old_dangerous_objects = dangerous_objects

	// prep for change
	var/list/old_baseturfs = baseturfs
	var/old_type = type

	var/list/post_change_callbacks = list()
	SEND_SIGNAL(src, COMSIG_TURF_CHANGE, path, new_baseturfs, flags, post_change_callbacks)

	// change
	changing_turf = TRUE
	qdel(src) //Just get the side effects and call Destroy
	//We do this here so anything that doesn't want to persist can clear itself
	var/list/old_comp_lookup = comp_lookup?.Copy()
	var/list/old_signal_procs = signal_procs?.Copy()
	var/turf/W = new path(src)

	// WARNING WARNING
	// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
	// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
	if(old_comp_lookup)
		LAZYOR(W.comp_lookup, old_comp_lookup)
	if(old_signal_procs)
		LAZYOR(W.signal_procs, old_signal_procs)

	for(var/datum/callback/callback as anything in post_change_callbacks)
		callback.InvokeAsync(W)

	if(new_baseturfs)
		W.baseturfs = baseturfs_string_list(new_baseturfs, W)
	else
		W.baseturfs = baseturfs_string_list(old_baseturfs, W) //Just to be safe

	if(!(flags & CHANGETURF_DEFER_CHANGE))
		W.AfterChange(flags, old_type)

	// restore planet stuff
	dangerous_objects = old_dangerous_objects
	if(flags & CHANGETURF_PRESERVE_OUTDOORS)
		outdoors = old_outdoors

	// restore/update atmos
	if(old_fire)
		fire = old_fire
	queue_zone_update()

	// restore lighting
	if(SSlighting.initialized)
		recalc_atom_opacity()
		lighting_object = old_lighting_object
		affecting_lights = old_affecting_lights
		lc_topright = old_lc_topright
		lc_topleft = old_lc_topleft
		lc_bottomright = old_lc_bottomright
		lc_bottomleft = old_lc_bottomleft
		if (old_opacity != opacity || dynamic_lighting != old_dynamic_lighting)
			reconsider_lights()
			updateVisibility(src)

		if (dynamic_lighting != old_dynamic_lighting)
			if (IS_DYNAMIC_LIGHTING(src))
				lighting_build_overlay()
			else
				lighting_clear_overlay()

		// todo: non dynamic lighting space starlight
		for(var/turf/space/S in RANGE_TURFS(1, src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			S.update_starlight()

	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

	return W

// todo: zas refactor
/turf/simulated/ChangeTurf(path, list/new_baseturfs, flags)
	if((flags & CHANGETURF_INHERIT_AIR) && ispath(path, /turf/simulated))
		// invalidate zone
		if(has_valid_zone())
			if(can_safely_remove_from_zone())
				zone.remove(src)
				queue_zone_update()
			else
				zone.rebuild()
		// store air
		var/datum/gas_mixture/GM = remove_cell_volume()
		. = ..()
		if(!.)
			return
		if(has_valid_zone())
			stack_trace("zone rebuilt too fast")
		// restore air
		air = GM
	else
		// if we're not doing so,
		if(has_valid_zone())
			// remove and rebuild zone
			if(can_safely_remove_from_zone())
				zone.remove(src)
				queue_zone_update()
			else
				zone.rebuild()
		// at this point the zone does not have our gas mixture in it, and is invalidated
		. = ..()
		if(!.)
			return
		// ensure zone didn't rebuild yet
		if(has_valid_zone())
			stack_trace("zone reubilt too fast")
		// reset air
		if(!air)
			air = new /datum/gas_mixture(CELL_VOLUME)
		air.parse_gas_string(initial_gas_mix)

/// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount=1, flags)
	if(!amount)
		return
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > new_baseturfs.len)
				CRASH("The bottommost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		new_baseturfs.len -= min(amount, new_baseturfs.len - 1) // No removing the very bottom
		if(new_baseturfs.len == 1)
			new_baseturfs = new_baseturfs[1]
		return ChangeTurf(turf_type, new_baseturfs, flags)

	if(baseturfs == type)
		return src

	return ChangeTurf(baseturfs, baseturfs, flags) // The bottom baseturf will never go away

/**
 * scrape away a turf from the bottom above logically multiz hole baseturfs
 * used for shuttle ceilings
 */
/turf/proc/ScrapeFromLogicalBottom(flags, this_type_only)
	// if we're already logically bottomless, don't bother
	if(GLOB.multiz_hole_baseturfs[src.type])
		return
	// ensure baseturfs list
	if(!islist(baseturfs))
		baseturfs = list(baseturfs)
	var/i
	var/p
	for(i in 1 to baseturfs.len)
		p = baseturfs[i]
		if(GLOB.multiz_hole_baseturfs[p])
			continue
	if(GLOB.multiz_hole_baseturfs[p])
		if(this_type_only && this_type_only != type)
			return
		ScrapeAway(1, flags)	// we had no baseturfs that were logically bottom
		return
	// make sure baseturfs are copied
	var/list/new_baseturfs = baseturfs.Copy()
	new_baseturfs.Cut(i, i+1)	// cut out found
	baseturfs = baseturfs_string_list(new_baseturfs, src)

/**
 * put a turf in from the bottom above logically multiz hole baseturfs. can changeturf.
 * used for shuttle ceilings
 */
/turf/proc/PlaceBelowLogicalBottom(type, flags)
	ASSERT(!GLOB.multiz_hole_baseturfs[type])
	// if we're already bottomless, just place on us
	if(GLOB.multiz_hole_baseturfs[src.type])
		PlaceOnTop(type, flags = flags)
		return
	// ensure baseturfs list
	if(!islist(baseturfs))
		baseturfs = list(baseturfs)
	var/i
	var/p
	for(i in 1 to baseturfs.len)
		p = baseturfs[i]
		if(GLOB.multiz_hole_baseturfs[p])
			continue
	var/list/new_baseturfs = baseturfs.Copy()
	if(GLOB.multiz_hole_baseturfs[p])
		// entire list was bottomless, add on top
		baseturfs = baseturfs_string_list(new_baseturfs + type, src)
		return
	new_baseturfs.Insert(i, type)
	baseturfs = baseturfs_string_list(new_baseturfs, src)

/**
 * put a turf one below the logical top. can changeturf if logical top is a hole.
 * used for shuttle floors
 */
/turf/proc/PlaceBelowLogicalTop(type, flags)
	ASSERT(!GLOB.multiz_hole_baseturfs[type])
	// if we're already bottomless, just place on us
	if(GLOB.multiz_hole_baseturfs[src.type])
		PlaceOnTop(type, flags = flags)
		return
	// ensure baseturfs list
	if(!islist(baseturfs))
		baseturfs = list(baseturfs)
	var/list/new_baseturfs = baseturfs.Copy()
	// see i just realized "the logical top is the current turf" so uh, that's easy.
	new_baseturfs.Insert(new_baseturfs.len + 1, type)
	baseturfs = baseturfs_string_list(new_baseturfs, src)

// Take the input as baseturfs and put it underneath the current baseturfs
// If fake_turf_type is provided and new_baseturfs is not the baseturfs list will be created identical to the turf type's
// If both or just new_baseturfs is provided they will be inserted below the existing baseturfs
/turf/proc/PlaceOnBottom(list/new_baseturfs, turf/fake_turf_type)
	if(fake_turf_type)
		if(!new_baseturfs)
			if(!length(baseturfs))
				baseturfs = list(baseturfs)
			var/list/old_baseturfs = baseturfs.Copy()
			assemble_baseturfs(fake_turf_type)
			if(!length(baseturfs))
				baseturfs = list(baseturfs)
			baseturfs = baseturfs_string_list((baseturfs - (baseturfs & GLOB.blacklisted_automated_baseturfs)) + old_baseturfs, src)
			return
		else if(!length(new_baseturfs))
			new_baseturfs = list(new_baseturfs, fake_turf_type)
		else
			new_baseturfs += fake_turf_type
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	baseturfs = baseturfs_string_list(new_baseturfs + baseturfs, src)

// Make a new turf and put it on top
// The args behave identical to PlaceOnBottom except they go on top
// Things placed on top of closed turfs will ignore the topmost closed turf
// Returns the new turf
/**
 * WARNING WARNING: CITRP EDIT: /turf/closed check replaced with TURF DENSITY CHECK.
 * every if(!density) is a if(!istype(src, /turf/closed)) in this version.
 */
/turf/proc/PlaceOnTop(list/new_baseturfs, turf/fake_turf_type, flags)
	var/area/turf_area = loc
	if(new_baseturfs && !length(new_baseturfs))
		new_baseturfs = list(new_baseturfs)
	flags = turf_area.PlaceOnTopReact(new_baseturfs, fake_turf_type, flags) // A hook so areas can modify the incoming args

	var/turf/newT
	if(flags & CHANGETURF_SKIP) // We haven't been initialized
		if(src.flags & INITIALIZED)
			stack_trace("CHANGETURF_SKIP was used in a PlaceOnTop call for a turf that's initialized. This is a mistake. [src]([type])")
		assemble_baseturfs()
	if(fake_turf_type)
		if(!new_baseturfs) // If no baseturfs list then we want to create one from the turf type
			if(!length(baseturfs))
				baseturfs = list(baseturfs)
			var/list/old_baseturfs = baseturfs.Copy()
			if(!density)
				old_baseturfs += type
			newT = ChangeTurf(fake_turf_type, null, flags)
			newT.assemble_baseturfs(initial(fake_turf_type.baseturfs)) // The baseturfs list is created like roundstart
			if(!length(newT.baseturfs))
				newT.baseturfs = list(baseturfs)
			// The old baseturfs are put underneath, and we sort out the unwanted ones
			newT.baseturfs = baseturfs_string_list(old_baseturfs + (newT.baseturfs - GLOB.blacklisted_automated_baseturfs), newT)
			return newT
		if(!length(baseturfs))
			baseturfs = list(baseturfs)
		if(!density)
			new_baseturfs = list(type) + new_baseturfs
		baseturfs = baseturfs_string_list(baseturfs + new_baseturfs, src)
		return ChangeTurf(fake_turf_type, null, flags)
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	if(!density)
		baseturfs = baseturfs_string_list(baseturfs + type, src)
	var/turf/change_type
	if(length(new_baseturfs))
		change_type = new_baseturfs[new_baseturfs.len]
		new_baseturfs.len--
		if(new_baseturfs.len)
			baseturfs = baseturfs_string_list(baseturfs + new_baseturfs, src)
	else
		change_type = new_baseturfs
	return ChangeTurf(change_type, null, flags)

// Copy an existing turf and put it on top
// Returns the new turf
/turf/proc/CopyOnTop(turf/copytarget, ignore_bottom=1, depth=INFINITY, copy_air = FALSE)
	var/list/new_baseturfs = list()
	new_baseturfs += baseturfs
	new_baseturfs += type

	if(depth)
		var/list/target_baseturfs
		if(length(copytarget.baseturfs))
			// with default inputs this would be Copy(clamp(2, -INFINITY, baseturfs.len))
			// Don't forget a lower index is lower in the baseturfs stack, the bottom is baseturfs[1]
			target_baseturfs = copytarget.baseturfs.Copy(clamp(1 + ignore_bottom, 1 + copytarget.baseturfs.len - depth, copytarget.baseturfs.len))
		else if(!ignore_bottom)
			target_baseturfs = list(copytarget.baseturfs)
		if(target_baseturfs)
			target_baseturfs -= new_baseturfs & GLOB.blacklisted_automated_baseturfs
			new_baseturfs += target_baseturfs

	var/turf/newT = copytarget.CopyTurf(src, copy_air)
	newT.baseturfs = baseturfs_string_list(new_baseturfs, newT)
	return newT

//If you modify this function, ensure it works correctly with lateloaded map templates.
/turf/proc/AfterChange(flags, oldType) //called after a turf has been replaced in ChangeTurf()
	levelupdate()
	update_vertical_turf_graphics()

/turf/proc/RemoveLattice()
	for(var/obj/structure/lattice/L in src)
		qdel(L)

/turf/proc/ReplaceWithLattice()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	new /obj/structure/lattice(locate(x, y, z))
