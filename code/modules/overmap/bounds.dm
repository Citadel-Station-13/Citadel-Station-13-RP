// file contains helpers for bounds visualization
/datum/controller/subsystem/overmaps
	/// caches icons, not overlays
	var/static/list/entity_bounds_overlay_cache = list()
	/// caches icons, not overlays
	var/static/list/tiled_bounds_overlay_cache = list()

/datum/controller/subsystem/overmaps/proc/entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height, color = "#ffffff")
	RETURN_TYPE(/mutable_appearance)
	var/key = "[bound_x]-[bounud_y]-[bound_width]-[bound_height]"
	// those above things are what we care for icon caching so
	var/icon/I = entity_bounds_overlay_cache[key]
	if(!I)
		// generate
		I = new
		I.Scale(bound_width, bound_height)
		I.DrawBox("#ffffffff", 1, 1, bound_width, bound_height)
		I.DrawBox("#ffffff00", 2, 2, bound_width - 1, bound_height - 1)
		entity_bounds_overlay_cache[key] = I
	var/mutable_appearance/MA = new
	. = MA
	MA.icon = I
	MA.color = color
	MA.alpha = 160
	MA.pixel_x = bound_x
	MA.pixel_y = bound_y

/**
 * smooth_directions is directions to **not** show the overlay border
 */
/datum/controller/subsystem/overmaps/proc/tiled_bounds_overlay(smooth_directions = NONE, color = "#ffffff")
	RETURN_TYPE(/mutable_appearance)
	var/key = "[directions]"
	// those above things are what we care for icon cachinig so
	var/icon/I = tiled_bounds_overlay_cache[key]
	if(!I)
		// generate
		I = new
		I.Scale(OVERMAP_WORLD_ICON_SIZE, OVERMAP_WORLD_ICON_SIZE)
		I.DrawBox("#ffffff00", 1, 1, OVERMAP_WORLD_ICON_SIZE, OVERMAP_WORLD_ICON_SIZE)
		if(!(smooth_directions & NORTH))
			I.DrawBox("#ffffffff", 1, OVERMAP_WORLD_ICON_SIZE, OVERMAP_WORLD_ICON_SIZE, OVERMAP_WORLD_ICON_SIZE)
		if(!(smooth_directions & SOUTH))
			I.DrawBox("#ffffffff", 1, 1, OVERMAP_WORLD_ICON_SIZE, 1)
		if(!(smooth_directions & EAST))
			I.DrawBox("#ffffffff", OVERMAP_WORLD_ICON_SIZE, 1, OVERMAP_WORLD_ICON_SIZE, OVERMAP_WORLD_ICON_SIZE)
		if(!(smooth_directions & WEST))
			I.DrawBox("#ffffffff", 1, 1, 1, OVERMAP_WORLD_ICON_SIZE)
		tiled_bounds_overlay_cache[key] = I
	var/mutable_appearance/MA = new
	. = MA
	MA.icon = I
	MA.alpha = 160

/atom/movable/overmap_object/proc/get_bounds_overlay()
	return

/atom/movable/overmap_object/proc/cut_bounds_overlay()
	if(bounds_overlay)
		cut_overlay(bounds_overlay)
		bounds_overlay = null

/atom/movable/overmap_object/proc/add_bounds_overlay()
	if(bounds_overlay)
		cut_bounds_overlay()
	bounds_overlay = get_bounds_overlay()
	if(bounds_overlay)
		add_overlay(bounds_overlay)
