// This is a list of turf types we dont want to assign to baseturfs unless through initialization or explicitly
GLOBAL_LIST_INIT(blacklisted_automated_baseturfs, typecacheof(list(
	/turf/space,
	/turf/baseturf_bottom,
	)))

/turf/proc/empty(turf_type=/turf/space, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/observer, /obj/effect/landmark, /atom/movable/lighting_object))	//obj/docking_port
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force = TRUE)

	if(turf_type)
		ChangeTurf(turf_type, baseturf_type, flags)
		//var/turf/newT = ChangeTurf(turf_type, baseturf_type, flags)
		/*
		SSair.remove_from_active(newT)
		newT.CalculateAdjacentTurfs()
		SSair.add_to_active(newT,1)
		*/

/turf/proc/copyTurf(turf/T)
	if(T.type != type)
		var/obj/O
		if(underlays.len)	//we have underlays, which implies some sort of transparency, so we want to a snapshot of the previous turf as an underlay
			O = new()
			O.underlays.Add(T)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = O.underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colors = atom_colors.Copy()
		T.update_atom_color()
	if(T.dir != dir)
		T.setDir(dir)
	return T

/turf/simulated/floor/copyTurf(turf/T, copy_air = FALSE)
	. = ..()
	if (istype(T, /turf/simulated/floor))
		/*
		GET_COMPONENT(slip, /datum/component/wet_floor)
		if(slip)
			var/datum/component/wet_floor/WF = T.AddComponent(/datum/component/wet_floor)
			WF.InheritComponent(slip)
		*/
		if (copy_air)
			var/turf/open/openTurf = T
			openTurf.air.copy_from(air)

//wrapper for ChangeTurf()s that you want to prevent/affect without overriding ChangeTurf() itself
/turf/proc/TerraformTurf(path, new_baseturf, flags)
	return ChangeTurf(path, new_baseturf, flags)

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, flags)
	//Can be optimized later
	var/zlevel_base_path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/space
	if (!ispath(zlevel_base_path))
		zlevel_base_path = text2path(zlevel_base_path)
		if (!ispath(zlevel_base_path))
			warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
			zlevel_base_path = /turf/space
	//End
	switch(path)
		if(null)
			return
		if(/turf/baseturf_bottom)
			path = zlevel_base_path
		if(/turf/space/basic)
			// basic doesn't initialize and this will cause issues
			// no warning though because this can happen naturaly as a result of it being built on top of
			path = /turf/space

	//MULTIZ ADD
	if(ispath(path, zlevel_base_path))
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below, zlevel_base_path) && istype(below, /turf/simulated))
			path = /turf/simulated/open
	//END

	if(!GLOB.use_preloader && path == type && !(flags & CHANGETURF_FORCEOP)) // Don't no-op if the map loader requires it to be reconstructed
		return src
	if(flags & CHANGETURF_SKIP)
		return new path(src)

	//POLARIS START
	var/old_outdoors = outdoors
	var/old_dangerous_objects = dangerous_objects
	//END

	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_object = lighting_object
	var/old_corners = corners

	/*
	var/old_exl = explosion_level
	var/old_exi = explosion_id
	var/old_bp = blueprint_data
	blueprint_data = null
	*/

	var/list/old_baseturfs = baseturfs

	var/list/transferring_comps = list()
	SEND_SIGNAL(src, COMSIG_TURF_CHANGE, path, new_baseturfs, flags, transferring_comps)

	//Blah blah universal state crap
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TURF_CHANGE, src, path, new_baseturfs, flags, transferring_comps)
	//END

	for(var/i in transferring_comps)
		var/datum/component/comp = i
		comp.RemoveComponent()

	changing_turf = TRUE
	qdel(src)	//Just get the side effects and call Destroy
	var/turf/W = new path(src)

	for(var/i in transferring_comps)
		W.TakeComponent(i)

	if(new_baseturfs)
		W.baseturfs = new_baseturfs
	else
		W.baseturfs = old_baseturfs

	/*
	W.explosion_id = old_exi
	W.explosion_level = old_exl
	*/

	if(!(flags & CHANGETURF_DEFER_CHANGE))
		W.AfterChange(flags)

	/*
	W.blueprint_data = old_bp
	*/

	if(SSlighting.initialized)
		recalc_atom_opacity()
		lighting_object = old_lighting_object
		affecting_lights = old_affecting_lights
		corners = old_corners
		if (old_opacity != opacity || dynamic_lighting != old_dynamic_lighting)
			reconsider_lights()

		if (dynamic_lighting != old_dynamic_lighting)
			if (IS_DYNAMIC_LIGHTING(src))
				lighting_build_overlay()
			else
				lighting_clear_overlay()

		for(var/turf/space/S in RANGE_TURFS(1, src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			S.update_starlight()

	//POLARIS START
	if(flags & CHANGETURF_PRESERVE_OUTDOORS)
		outdoors = old_outdoors
	dangerous_objects = old_dangerous_objects
	//POLARIS END

	return W

/turf/simulated/floor/ChangeTurf(path, list/new_baseturfs, flags)

	//ZAS START
	var/obj/fire/old_fire = fire
	var/zone/old_zone = zone
	var/connection_manager/old_connections = connections
	//ZAS END

	/*
	if ((flags & CHANGETURF_INHERIT_AIR) && ispath(path, /turf/open))
		SSair.remove_from_active(src)
		var/stashed_air = air
		air = null // so that it doesn't get deleted
		. = ..()
		if (!. || . == src) // changeturf failed or didn't do anything
			air = stashed_air
			return
		var/turf/open/newTurf = .
		if (!istype(newTurf.air, /datum/gas_mixture/immutable/space))
			QDEL_NULL(newTurf.air)
			newTurf.air = stashed_air
		SSair.add_to_active(newTurf)
	else
		return ..()
	*/
	. = ..()
	if(!. || . == src)
		return

	//ZAS START
	if(air_master)
		air_master.mark_for_update(src)
	if(old_connections)
		old_connections.erase_all()
	if(old_zone)
		old_zone.rebuild()
	var/is_floor = istype(., /turf/simulated/floor)
	if(old_fire)
		is_floor? (fire = old_fire) : fire.RemoveFire()
		fire? update_icon() : NONE
	//ZAS END

// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount = 1, flags)
	if(!amount)
		return
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > new_baseturfs.len)
				CRASH("The bottomost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		new_baseturfs.len -= min(amount, new_baseturfs.len - 1) // No removing the very bottom
		if(new_baseturfs.len == 1)
			new_baseturfs = new_baseturfs[1]
		return ChangeTurf(turf_type, new_baseturfs, flags)

	if(baseturfs == type)
		return src

	return ChangeTurf(baseturfs, baseturfs, flags) // The bottom baseturf will never go away

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
			baseturfs -= baseturfs & GLOB.blacklisted_automated_baseturfs
			baseturfs += old_baseturfs
			return
		else if(!length(new_baseturfs))
			new_baseturfs = list(new_baseturfs, fake_turf_type)
		else
			new_baseturfs += fake_turf_type
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	baseturfs.Insert(1, new_baseturfs)

// Make a new turf and put it on top
// The args behave identical to PlaceOnBottom except they go on top
// Things placed on top of closed turfs will ignore the topmost closed turf
// Returns the new turf
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
#define is_self_closed_turf istype(src, /turf/simulated/wall)
	if(fake_turf_type)
		if(!new_baseturfs) // If no baseturfs list then we want to create one from the turf type
			if(!length(baseturfs))
				baseturfs = list(baseturfs)
			var/list/old_baseturfs = baseturfs.Copy()
			if(!is_self_closed_turf)
				old_baseturfs += type
			newT = ChangeTurf(fake_turf_type, null, flags)
			newT.assemble_baseturfs(initial(fake_turf_type.baseturfs)) // The baseturfs list is created like roundstart
			if(!length(newT.baseturfs))
				newT.baseturfs = list(baseturfs)
			newT.baseturfs -= GLOB.blacklisted_automated_baseturfs
			newT.baseturfs.Insert(1, old_baseturfs) // The old baseturfs are put underneath
			return newT
		if(!length(baseturfs))
			baseturfs = list(baseturfs)
		if(!is_self_closed_turf)
			baseturfs += type
		baseturfs += new_baseturfs
		return ChangeTurf(fake_turf_type, null, flags)
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	if(!is_self_closed_turf)
		baseturfs += type
	var/turf/change_type
	if(length(new_baseturfs))
		change_type = new_baseturfs[new_baseturfs.len]
		new_baseturfs.len--
		if(new_baseturfs.len)
			baseturfs += new_baseturfs
	else
		change_type = new_baseturfs
	return ChangeTurf(change_type, null, flags)
#undef is_self_closed_turf

// Copy an existing turf and put it on top
// Returns the new turf
/turf/proc/CopyOnTop(turf/copytarget, ignore_bottom=1, depth=INFINITY, copy_air = FALSE)
	var/list/new_baseturfs = list()
	new_baseturfs += baseturfs
	new_baseturfs += type

	if(depth)
		var/list/target_baseturfs
		if(length(copytarget.baseturfs))
			// with default inputs this would be Copy(CLAMP(2, -INFINITY, baseturfs.len))
			// Don't forget a lower index is lower in the baseturfs stack, the bottom is baseturfs[1]
			target_baseturfs = copytarget.baseturfs.Copy(CLAMP(1 + ignore_bottom, 1 + copytarget.baseturfs.len - depth, copytarget.baseturfs.len))
		else if(!ignore_bottom)
			target_baseturfs = list(copytarget.baseturfs)
		if(target_baseturfs)
			target_baseturfs -= new_baseturfs & GLOB.blacklisted_automated_baseturfs
			new_baseturfs += target_baseturfs

	var/turf/newT = copytarget.copyTurf(src, copy_air)
	newT.baseturfs = new_baseturfs
	return newT


//If you modify this function, ensure it works correctly with lateloaded map templates.
/turf/proc/AfterChange(flags) //called after a turf has been replaced in ChangeTurf()
	levelupdate()
	/*
	CalculateAdjacentTurfs()

	//update firedoor adjacency
	var/list/turfs_to_check = get_adjacent_open_turfs(src) | src
	for(var/I in turfs_to_check)
		var/turf/T = I
		for(var/obj/machinery/door/firedoor/FD in T)
			FD.CalculateAffectingAreas()
	*/

	/*
	queue_smooth_neighbors(src)
	*/

	HandleTurfChange(src)

/turf/open/AfterChange(flags)
	..()
	RemoveLattice()
	if(!(flags & (CHANGETURF_IGNORE_AIR | CHANGETURF_INHERIT_AIR)))
		Assimilate_Air()

//////Assimilate Air//////
/turf/open/proc/Assimilate_Air()
/*
	var/turf_count = LAZYLEN(atmos_adjacent_turfs)
	if(blocks_air || !turf_count) //if there weren't any open turfs, no need to update.
		return

	var/datum/gas_mixture/total = new//Holders to assimilate air from nearby turfs
	var/list/total_gases = total.gases

	for(var/T in atmos_adjacent_turfs)
		var/turf/open/S = T
		if(!S.air)
			continue
		var/list/S_gases = S.air.gases
		for(var/id in S_gases)
			ASSERT_GAS(id, total)
			total_gases[id][MOLES] += S_gases[id][MOLES]
		total.temperature += S.air.temperature

	air.copy_from(total)

	var/list/air_gases = air.gases
	for(var/id in air_gases)
		air_gases[id][MOLES] /= turf_count //Averages contents of the turfs, ignoring walls and the like

	air.temperature /= turf_count
	SSair.add_to_active(src)
*/

/turf/proc/ReplaceWithLattice()
	ScrapeAway()
	new /obj/structure/lattice(locate(x, y, z))

/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L && (L.flags & INITIALIZED))
		qdel(L)
