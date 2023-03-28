//
// Holomap generation.
// Based on /vg/station but trimmed down (without antag stuff) and massively optimized (you should have seen it before!) ~Leshana
//

// Define what criteria makes a turf a path or not

/datum/controller/subsystem/holomaps
	var/list/rock_tcache
	var/list/obstacle_tcache
	var/list/path_tcache
	var/list/space_tcache
	var/list/unexplored_tcache

/datum/controller/subsystem/holomaps/proc/setup_tcaches()
	rock_tcache = typecacheof(/turf/simulated/mineral)
	obstacle_tcache = typecacheof(list(
		/turf/simulated/wall,
		/turf/unsimulated/mineral,
		/turf/unsimulated/wall
	)) - typecacheof(/turf/unsimulated/wall/planetary)
	path_tcache = typecacheof(list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)) - typecacheof(/turf/simulated/floor/outdoors)
	space_tcache = typecacheof(/turf/space)
	unexplored_tcache = typecacheof(/area/mine/unexplored)

/// Generates all the holo minimaps, initializing it all nicely, probably.
/datum/controller/subsystem/holomaps/proc/generateHoloMinimaps()
	if (!rock_tcache)
		setup_tcaches()

	// Build the base map for each z level
	for (var/z = 1 to world.maxz)
		holoMiniMaps |= z // hack, todo fix
		holoMiniMaps[z] = generateHoloMinimap(z)

	// Generate the area overlays, small maps, etc for the station levels.
	for (var/z in GLOB.using_map.station_levels)
		generateStationMinimap(z)

	if(GLOB.using_map.holomap_smoosh)
		for(var/smoosh_list in GLOB.using_map.holomap_smoosh)
			smooshTetherHolomaps(smoosh_list)

	holomaps_initialized = TRUE

	// TODO - Check - They had a delayed init perhaps?
	for (var/obj/machinery/station_map/S in station_holomaps)
		S.setup_holomap()

// Generates the "base" holomap for one z-level, showing only the physical structure of walls and paths.
/datum/controller/subsystem/holomaps/proc/generateHoloMinimap(var/zLevel = 1)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zLevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zLevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		CRASH("Minimap for z=[zLevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		CRASH("Minimap for z=[zLevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	var/turf/T
	var/area/A
	var/Ttype
	for (var/thing in Z_ALL_TURFS(zLevel))
		T = thing
		A = T.loc
		Ttype = T.type

		if (istype(A, /area/shuttle))
			continue

		if (rock_tcache[Ttype] && T.density)
			continue
		if (obstacle_tcache[Ttype] || (!space_tcache[Ttype] && unexplored_tcache[A.type]) || (T.contents.len && locate(/obj/structure/grille, T)))
			canvas.DrawBox(HOLOMAP_OBSTACLE, T.x + offset_x, T.y + offset_y)
		else if(path_tcache[Ttype] || (T.contents.len && locate(/obj/structure/catwalk, T)))
			canvas.DrawBox(HOLOMAP_PATH, T.x + offset_x, T.y + offset_y)

		CHECK_TICK

	return canvas

// Okay, what does this one do?
// This seems to do the drawing thing, but draws only the areas, having nothing to do with the tiles.
// Leshana: I'm guessing this map will get overlayed on top of the base map at runtime? We'll see.
// Wait, seems we actually blend the area map on top of it right now! Huh.
/datum/controller/subsystem/holomaps/proc/generateStationMinimap(var/zLevel)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zLevel)
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zLevel)

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		CRASH("Minimap for z=[zLevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		CRASH("Minimap for z=[zLevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	var/turf/T
	var/area/A
	for (var/thing in Z_ALL_TURFS(zLevel))
		T = thing
		A = T.loc
		if (A.holomap_color)
			canvas.DrawBox(A.holomap_color, T.x + offset_x, T.y + offset_y)

	// Save this nice area-colored canvas in case we want to layer it or something I guess
	extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[zLevel]"] = canvas

	var/icon/map_base = icon(holoMiniMaps[zLevel])
	map_base.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)

	// Generate the full sized map by blending the base and areas onto the backdrop
	var/icon/big_map = icon(HOLOMAP_ICON, "stationmap")
	big_map.Blend(map_base, ICON_OVERLAY)
	big_map.Blend(canvas, ICON_OVERLAY)
	extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAP]_[zLevel]"] = big_map

	// Generate the "small" map (I presume for putting on wall map things?)
	var/icon/small_map = icon(HOLOMAP_ICON, "blank")
	small_map.Blend(map_base, ICON_OVERLAY)
	small_map.Blend(canvas, ICON_OVERLAY)
	small_map.Scale(WORLD_ICON_SIZE, WORLD_ICON_SIZE)

	// And rotate it in every direction of course!
	var/icon/actual_small_map = icon(small_map)
	actual_small_map.Insert(new_icon = small_map, dir = SOUTH)
	actual_small_map.Insert(new_icon = turn(small_map, 90), dir = WEST)
	actual_small_map.Insert(new_icon = turn(small_map, 180), dir = NORTH)
	actual_small_map.Insert(new_icon = turn(small_map, 270), dir = EAST)
	extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[zLevel]"] = actual_small_map

// For tiny multi-z maps like the tether, we want to smoosh em together into a nice big one!
/datum/controller/subsystem/holomaps/proc/smooshTetherHolomaps(var/list/zlevels)
	var/icon/big_map = icon(HOLOMAP_ICON, "stationmap")
	var/icon/small_map = icon(HOLOMAP_ICON, "blank")
	// For each zlevel in turn, overlay them on top of each other
	for(var/zLevel in zlevels)
		var/icon/z_terrain = icon(holoMiniMaps[zLevel])
		z_terrain.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)
		big_map.Blend(z_terrain, ICON_OVERLAY)
		small_map.Blend(z_terrain, ICON_OVERLAY)
		var/icon/z_areas = extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[zLevel]"]
		big_map.Blend(z_areas, ICON_OVERLAY)
		small_map.Blend(z_areas, ICON_OVERLAY)

	// Then scale and rotate to make the actual small map we will use
	small_map.Scale(WORLD_ICON_SIZE, WORLD_ICON_SIZE)
	var/icon/actual_small_map = icon(small_map)
	actual_small_map.Insert(new_icon = small_map, dir = SOUTH)
	actual_small_map.Insert(new_icon = turn(small_map, 90), dir = WEST)
	actual_small_map.Insert(new_icon = turn(small_map, 180), dir = NORTH)
	actual_small_map.Insert(new_icon = turn(small_map, 270), dir = EAST)

	// Then assign this icon as the icon for all those levels!
	for(var/zLevel in zlevels)
		extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAP]_[zLevel]"] = big_map
		extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[zLevel]"] = actual_small_map

// TODO - Holomap Markers!
// /proc/generateMinimapMarkers(var/zLevel)
// 	// Save these values now to avoid a bazillion array lookups
// 	var/offset_x = HOLOMAP_PIXEL_OFFSET_X(zLevel)
// 	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y(zLevel)

// 	// TODO - Holomap markers
// 	for(var/filter in list(HOLOMAP_FILTER_STATIONMAP))
// 		var/icon/canvas = icon(HOLOMAP_ICON, "blank")
// 		for(/datum/holomap_marker/holomarker in holomap_markers)
// 			if(holomarker.z == zLevel && holomarker.filter & filter)
// 				canvas.Blend(icon(holomarker.icon, holomarker.icon_state), ICON_OVERLAY, holomarker.x + offset_x, holomarker.y + offset_y)
// 		extraMiniMaps["[HOLOMAP_EXTRA_MARKERS]_[filter]_[zLevel]"] = canvas

// /datum/holomap_marker
// 	var/x
// 	var/y
// 	var/z
// 	var/filter
// 	var/icon = 'icons/holomap_markers.dmi'
// 	var/icon_state
