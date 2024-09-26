// file contains helpers for bounds visualization
/datum/controller/subsystem/overmaps
	/// caches icons, not overlays
	var/static/list/entity_bounds_overlay_cache = list()
	/// caches icons, not overlays
	var/static/list/tiled_bounds_overlay_cache = list()

/datum/controller/subsystem/overmaps/proc/entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height, color = "#ffffff")
	RETURN_TYPE(/mutable_appearance)
	var/key = "[bound_x]-[bound_y]-[bound_width]-[bound_height]"
	// those above things are what we care for icon caching so
	var/icon/I = entity_bounds_overlay_cache[key]
	if(!I)
		// generate
		I = icon('icons/system/blank_32x32.dmi', "")
		I.Scale(bound_width, bound_height)
		I.DrawBox("#ffffffff", 1, 1, bound_width, bound_height)
		I.DrawBox("#ffffff00", 2, 2, bound_width - 1, bound_height - 1)
		entity_bounds_overlay_cache[key] = I
	var/mutable_appearance/MA = new
	. = MA
	MA.appearance_flags = KEEP_APART | RESET_TRANSFORM
	// mutable appearance is not FLOAT_PLANE by default
	MA.plane = FLOAT_PLANE
	MA.icon = I
	MA.color = color
	MA.alpha = 160
	MA.pixel_x = bound_x
	MA.pixel_y = bound_y
	MA.filters = filter(
		type = "drop_shadow",
		color = color + "99",
		size = 1,
		offset = 0,
		x = 0,
		y = 0,
	)

/**
 * smooth_directions is directions to **not** show the overlay border
 */
/datum/controller/subsystem/overmaps/proc/tiled_bounds_overlay(smooth_directions = NONE, color = "#ffffff")
	RETURN_TYPE(/mutable_appearance)
	var/key = "[smooth_directions]"
	// those above things are what we care for icon cachinig so
	var/icon/I = tiled_bounds_overlay_cache[key]
	if(!I)
		// generate
		I = icon('icons/system/blank_32x32.dmi', "")
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
	MA.appearance_flags = KEEP_APART | RESET_TRANSFORM
	// mutable appearance is not FLOAT_PLANE by default
	MA.plane = FLOAT_PLANE
	MA.icon = I
	MA.alpha = 160
	MA.filters = filter(
		type = "drop_shadow",
		color = color + "99",
		size = 1,
		offset = 0,
		x = 0,
		y = 0,
	)

/obj/overmap/proc/get_bounds_overlay()
	return

/obj/overmap/proc/cut_bounds_overlay()
	if(bounds_overlay)
		underlays -= bounds_overlay
		bounds_overlay = null

/obj/overmap/proc/add_bounds_overlay()
	if(bounds_overlay)
		cut_bounds_overlay()
	bounds_overlay = get_bounds_overlay()
	if(bounds_overlay)
		underlays += bounds_overlay

/obj/overmap/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	. = ..()
	if(!.)
		return
	var/static/list/bounds_vars = list(
		"bound_x",
		"bound_y",
		"bound_height",
		"bound_width",
		"bounds",
	)
	if(var_name in bounds_vars)
		if(uses_bounds_overlay)
			add_bounds_overlay()
