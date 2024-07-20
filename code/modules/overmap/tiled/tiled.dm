/**
 * tiled objects
 *
 * static, world icon size hitboxes
 *
 * todo: bake our own smoothing system, tg smoothing is too expensive/generic for thiw
 */
/obj/overmap/tiled
	icon = 'icons/modules/overmap/tiled.dmi'
	uses_bounds_overlay = TRUE
	smoothing_flags = SMOOTH_CUSTOM

	var/adjacency_dirs

/obj/overmap/tiled/Initialize(mapload)
	. = ..()
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/overmap/tiled/Destroy()
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/overmap/tiled/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	QUEUE_SMOOTH_NEIGHBORS(old_loc)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/overmap/tiled/custom_smooth(junctions)
	adjacency_dirs = junctions
	add_bounds_overlay()

/obj/overmap/tiled/calculate_adjacencies()
	. = NONE
	for(var/dir in GLOB.cardinal)
		if(locate(/obj/overmap/tiled) in get_step(src, dir))
			. |= dir

/obj/overmap/tiled/get_bounds_overlay()
	return SSovermaps.tiled_bounds_overlay(adjacency_dirs, color)
