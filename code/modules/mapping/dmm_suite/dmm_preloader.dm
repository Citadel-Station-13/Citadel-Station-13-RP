/// global datum that will preload variables on atoms instanciation
/// this is global for security and speed
GLOBAL_REAL(dmm_preloader, /datum/dmm_preloader) = new
/// this is global for security and speed; if active, atoms will invoke the preloader on New()
///
/// * any atom is allowed to arbitrarily set this to FALSE, but not TRUE, on New()
/// * this is so things like /turf/space/basic that intentionally don't invoke the preloader will still turn it off like atoms should after they preload
GLOBAL_REAL_VAR(dmm_preloader_active) = FALSE
/// target typepath
GLOBAL_REAL_VAR(dmm_preloader_target)

/// Preloader datum
/datum/dmm_preloader
	parent_type = /datum

	//* -- /parsed_map load cycle -- *//

	/// the current active orientation.
	///
	/// * the natural orientation is SOUTH.
	/// * specifying a non-SOUTH orientation rotates the map clockwise to match that orientation.
	var/loading_orientation
	/// the active maploader context
	var/datum/dmm_context/loading_context

	//* --      set per atom      -- *//
	var/list/attributes

// todo: OPTIMIZE THE SHIT OUT OF ALL OF THIS
// because citrp is so quirky and funny we now call this for every fucking atom
// this is not good
// this means that we really need to optimize this to not just be attributes.
// maybe we can get all the swap stuff compounded down? who knows lol
// fucked.

/world/proc/preloader_setup(list/the_attributes, path)
	global.dmm_preloader_active = TRUE
	global.dmm_preloader_target = path
	var/datum/dmm_preloader/preloader_local = global.dmm_preloader
	preloader_local.attributes = the_attributes

/world/proc/preloader_load(atom/what)
	global.dmm_preloader_active = FALSE
	var/datum/dmm_preloader/preloader_local = global.dmm_preloader
	for(var/attribute in preloader_local.attributes)
		var/value = preloader_local.attributes[attribute]
		if(islist(value))
			value = deep_copy_list(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = "<font color=green>[what.type]</font> at [AREACOORD(what)] - <b>VAR:</b> <font color=red>[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]</font>"
			log_mapping("DIRTY VAR: [message]")
			GLOB.dirty_vars += message
		#endif
		what.vars[attribute] = value

	// handle post processing, so things like directions on subtypes don't break.
	// only do everything if necessary.
	// TODO: look over the rotation block, it's inefficient and frankly a mess.
	var/datum/dmm_context/loading_context_local = preloader_local.loading_context
	var/turn_angle = loading_context_local.loaded_orientation_turn_angle
	if(turn_angle && what.preloading_from_mapload_rotation(loading_context_local))
		var/multi_tile = ismovable(what) && ((what:bound_width > WORLD_ICON_SIZE) || (what:bound_height > WORLD_ICON_SIZE)) && (what.appearance_flags & TILE_MOVER)
		var/invert_x = loading_context_local.loaded_orientation_invert_x
		var/invert_y = loading_context_local.loaded_orientation_invert_y
		var/swap_xy = loading_context_local.loaded_orientation_swap_xy

		if(multi_tile)
			// normal multi tile rotation can only handle things that are 'centered' on their bound width/height
			// if something needs to change that every rotation, it needs to override preloading_from_mapload_rotation
			var/atom/movable/casted = what
			// deal with their bounds
			var/bx = casted.bound_x
			var/by = casted.bound_y
			if(invert_y)			//same order of operations as the load rotation, mirror and then x/y swapping.
				by = -by
			if(invert_x)
				bx = -bx
			if(swap_xy)
				var/obx = bx
				bx = by
				by = obx
				var/obw = casted.bound_width
				casted.bound_width = casted.bound_height
				casted.bound_height = obw
			casted.bound_x = bx
			casted.bound_y = by
			// not a pixel mover, we can assume it's multiples of world icon size
			var/dx = round((casted.bound_width / WORLD_ICON_SIZE) - (casted.bound_x / (WORLD_ICON_SIZE / 2)) - 1)
			var/dy = round((casted.bound_height / WORLD_ICON_SIZE) - (casted.bound_y / (WORLD_ICON_SIZE / 2)) - 1)
			casted.x -= dx * ((invert_x ^ swap_xy)? 1 : 0)
			casted.y -= dy * ((invert_y ^ swap_xy)? 1 : 0)

		what.dir = turn(what.dir, turn_angle)
		var/px = what.pixel_x
		var/py = what.pixel_y
		if(invert_y)			//same order of operations as the load rotation, mirror and then x/y swapping.
			py = -py
		if(invert_x)
			px = -px
		if(swap_xy)
			var/opx = px
			px = py
			py = opx
		what.pixel_x = px
		what.pixel_y = py

	what.preloading_from_mapload(loading_context_local)

