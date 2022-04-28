/**
 * tiled overmap effects
 * usually hazards, spatial-filling things, etc
 */
/atom/movable/overmap_object/tiled
	bound_height = 32
	bound_width = 32
	bound_x = 0
	bound_y = 0

/atom/movable/overmap_object/tiled/Initialize(mapload)
	. = ..()
	if(!mapload)
		update_neighbor_bounds_overlays()

/atom/movable/overmap_object/tiled/forceMove(atom/destination)
	cut_bounds_overlay()
	. = ..()
	add_bounds_overlay()
	update_neighbor_bounds_overlays()

/atom/movable/overmap_object/tiled/get_bounds_overlay()
	SSovermaps.tiled_bounds_overlay(get_connecting_tile_dirs())

/**
 * get similar tiles that visually connect to use
 */
/atom/movable/overmap_object/tiled/proc/get_connecting_tile_dirs()
	#warn impl

/**
 * update neighbors for connections
 */
/atom/movable/overmap_object/tiled/proc/update_neighbor_bounds_overlays()
	if(!isturf(loc))
		return
	var/turf/T
	T = get_step(src, NORTH)
	for(var/atom/movable/overmap_object/tiled/O in T)
		O.add_bounds_overlay()
	T = get_step(src, SOUTH)
	for(var/atom/movable/overmap_object/tiled/O in T)
		O.add_bounds_overlay()
	T = get_step(src, EAST)
	for(var/atom/movable/overmap_object/tiled/O in T)
		O.add_bounds_overlay()
	T = get_step(src, WEST)
	for(var/atom/movable/overmap_object/tiled/O in T)
		O.add_bounds_overlay()
