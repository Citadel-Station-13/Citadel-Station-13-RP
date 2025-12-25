//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Helper Datums *//

/**
 * Holds an object to render along with the amount.
 *
 * * This does hard-ref the rendered object for ease of use. Since UI is re-rendered on removals, this should be fine.
 */
/datum/storage_numerical_display
	var/obj/item/rendered_object
	var/amount

/datum/storage_numerical_display/New(obj/item/sample, amount = 0)
	src.rendered_object = sample
	src.amount = amount

/proc/cmp_storage_numerical_displays_name_asc(datum/storage_numerical_display/A, datum/storage_numerical_display/B)
	return sorttext(B.rendered_object.name, A.rendered_object.name) || sorttext(B.rendered_object.type, A.rendered_object.type)

//* UI Render Filters *//

/**
 * Do not modify the returned appearances; they might be real instances!
 *
 * @return list(/datum/storage_numerical_display instance, ...)
 */
/datum/object_system/storage/proc/render_numerical_display(list/obj/item/for_items)
	RETURN_TYPE(/list)
	. = list()
	var/list/types = list()
	for(var/obj/item/iterating in (for_items || real_contents_loc()))
		var/datum/storage_numerical_display/collation
		if(isnull(types[iterating.type]))
			collation = new
			collation.rendered_object = iterating
			collation.amount = 0
			. += collation
			types[iterating.type] = collation
		collation = types[iterating.type]
		++collation.amount
	tim_sort(., /proc/cmp_storage_numerical_displays_name_asc)

//* UI Rendering *//

// todo: refactor a bit? this is a little messy

/datum/object_system/storage/proc/ui_queue_refresh()
	if(ui_refresh_queued)
		return
	ui_refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(refresh)), 0)

/datum/object_system/storage/proc/cleanup_ui(mob/user)
	var/list/objects = ui_by_mob[user]
	user.client?.screen -= objects
	QDEL_LIST(objects)
	ui_by_mob -= user

/**
 * we assume that the display style didn't change.
 */
/datum/object_system/storage/proc/refresh_ui(mob/user)
	// for now, we just do a full redraw.
	cleanup_ui(user)
	create_ui(user)

/datum/object_system/storage/proc/create_ui(mob/user)
	var/uses_volumetric_ui = uses_volumetric_ui()
	var/list/atom/movable/screen/storage/objects
	if(uses_volumetric_ui)
		objects += create_ui_volumetric_mode(user)
	else
		objects += create_ui_slot_mode(user)
	LAZYINITLIST(ui_by_mob)
	ui_by_mob[user] = objects
	user.client?.screen += objects

/**
 * this should not rely on uses_numerical_ui()
 */
/datum/object_system/storage/proc/uses_volumetric_ui()
	return max_combined_volume && !ui_numerical_mode && !ui_force_slot_mode

/**
 * this should not rely on uses_volumetric_ui()
 */
/datum/object_system/storage/proc/uses_numerical_ui()
	return ui_numerical_mode

/**
 * inspired by CM; allows tinting the background if something is nearly full
 */
/datum/object_system/storage/proc/get_ui_drawer_tint()
	return null

/datum/object_system/storage/proc/get_ui_predicted_max_items()
	return max_items ? max_items : ceil(STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x))

/**
 * * Will not respect random access limits in numerical mode.
 */
/datum/object_system/storage/proc/create_ui_slot_mode(mob/user)
	. = list()
	var/atom/movable/screen/storage/closer/closer = new
	. += closer
	var/atom/movable/screen/storage/panel/slot/boxes/boxes = new
	. += boxes
	// todo: clientless support is awful here
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	// clamp to max items if needed
	var/rendering_width = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	var/predicted_max_items = get_ui_predicted_max_items()
	if(predicted_max_items)
		rendering_width = min(predicted_max_items, rendering_width)
	// see if we need to process numerical display
	var/list/datum/storage_numerical_display/numerical_rendered = uses_numerical_ui()? render_numerical_display() : null
	// process indirection
	var/obj/item/accessible = accessible_items()
	// if we have expand when needed, only show 1 more than the actual amount.
	if(ui_expand_when_needed)
		rendering_width = min(rendering_width, (isnull(numerical_rendered)? length(accessible) : length(numerical_rendered)) + 1)
	// compute count and rows
	var/item_count = isnull(numerical_rendered)? length(accessible) : length(numerical_rendered)
	var/rows_needed = ROUND_UP(item_count / rendering_width) || 1
	// prepare iteration
	var/current_row = 1
	var/current_column = 1
	// render boxes
	boxes.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X + rendering_width - 1]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y + rows_needed - 1]:[STORAGE_UI_START_PIXEL_Y]"
	boxes.color = get_ui_drawer_tint()
	// render closer
	closer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + rendering_width]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y]"
	// render items
	if(islist(numerical_rendered))
		for(var/datum/storage_numerical_display/display as anything in numerical_rendered)
			var/atom/movable/screen/storage/item/slot/renderer = new(null, display.rendered_object)
			. += renderer
			// render amount
			display.rendered_object.maptext = MAPTEXT("[display.amount]")
			// position
			renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
			// advance
			++current_column
			if(current_column > rendering_width)
				current_column = 1
				++current_row
				if(current_row > STORAGE_UI_MAX_ROWS)
					break
	else
		for(var/obj/item/item in accessible)
			var/atom/movable/screen/storage/item/slot/renderer = new(null, item)
			. += renderer
			// position
			renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
			// advance
			++current_column
			if(current_column > rendering_width)
				current_column = 1
				++current_row
				if(current_row > STORAGE_UI_MAX_ROWS)
					break

/**
 * Volumetric rendering.
 * * Doesn't respect random access limits.
 */
/datum/object_system/storage/proc/create_ui_volumetric_mode(mob/user)
	// guard against divide-by-0's
	if(!max_combined_volume)
		return create_ui_slot_mode(user)
	. = list()

	//? resolve items

	// resolve indirection
	var/atom/indirection = real_contents_loc()

	//? resolve view and rendering
	// todo: clientless support is awful here

	// resolve view
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	// setup initial width limits
	var/rendering_width_limit = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	var/rendering_width_px_limit = rendering_width_limit * 32

	// here's the tricky part
	// we don't know our max (need to know how many items in one row which we don't)
	// or our min (ditto)
	// and during the row-forming ops we can actually end up adding more space as needed
	// so:

	// we keep a running current-width
	var/rendering_width_px = 0
	// we scale up effective max volume if we're overpacked
	var/effective_max_volume = max(max_combined_volume, cached_combined_volume)
	// we have some dynamic tuning for how many pixels things use
	var/effective_pixel_volume_ratio = VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO
	// we compute how much pixels we ideally will need to display everything
	var/ideal_width_px = effective_pixel_volume_ratio * effective_max_volume
	// if too low,
	if(ideal_width_px < (VOLUMETRIC_STORAGE_INFLATE_TO_TILES * WORLD_ICON_SIZE))
		// expand our horizons
		effective_pixel_volume_ratio = (VOLUMETRIC_STORAGE_INFLATE_TO_TILES * WORLD_ICON_SIZE) / effective_max_volume
		ideal_width_px = effective_pixel_volume_ratio * effective_max_volume

	// -- prepare for iteration --

	// volume accounted for.
	// when we render things smaller than minimum pixels per item, we effectively 'overrun'.
	// this results in things looking full when they're not.
	// so, we track how much actual volume we rendered
	var/volume_accounted_for = 0

	// currently used inner-width;
	// * this includes boxes and padding alike
	var/iteration_width = 0
	// current row
	var/current_row = 1
	// safety var
	var/safety = VOLUMETRIC_STORAGE_MAX_ITEMS

	// -- iterate --

	for(var/obj/item/item in indirection)
		var/item_volume = item.get_weight_volume()
		// check safety
		if(--safety <= 0)
			to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
			break
		var/item_width_px = max(VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM, item_volume * effective_pixel_volume_ratio)
		var/space_left_px = rendering_width_px_limit - iteration_width
		// check row; only wrap around when we're out of px-limit, or, if
		// the current item would be unacceptably squashed by being stuffed in.
		if(space_left_px < (item_width_px * 0.75))
			// check if we're out of rows
			if(current_row >= STORAGE_UI_MAX_ROWS)
				to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
				break
			// do final row stuff
			if(iteration_width > 0)
				// subtract last item padding if any items were rendered
				iteration_width -= VOLUMETRIC_STORAGE_ITEM_PADDING
			iteration_width += VOLUMETRIC_STORAGE_EDGE_PADDING
			rendering_width_px = max(rendering_width_px, iteration_width)
			// make another row
			++current_row
			iteration_width = 0

		// render the item
		var/atom/movable/screen/storage/item/volumetric/renderer = new(null, item)
		// add to emitted screen list
		. += renderer
		// scale it as necessary, to nearest multiple of 2
		var/used_pixels = max(VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM, CEILING(ideal_width_px * (item_volume / effective_max_volume), 2))
		renderer.set_pixel_width(used_pixels)
		// set screen loc
		renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + VOLUMETRIC_STORAGE_EDGE_PADDING + iteration_width + (used_pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
		// add to iteration tracking
		iteration_width += used_pixels + VOLUMETRIC_STORAGE_ITEM_PADDING
		volume_accounted_for += item_volume

	// if we only used one row..
	if(current_row == 1)
		// expand it if we still have room left to take into account the unused space.
		if(volume_accounted_for < effective_max_volume)
			iteration_width = min(rendering_width_px_limit, iteration_width + (effective_max_volume - volume_accounted_for) * effective_pixel_volume_ratio + VOLUMETRIC_STORAGE_ITEM_PADDING)
	// do final row stuff
	if(iteration_width > 0)
		// subtract last item padding if any items were rendered
		iteration_width -= VOLUMETRIC_STORAGE_ITEM_PADDING
	iteration_width += VOLUMETRIC_STORAGE_EDGE_PADDING
	rendering_width_px = max(rendering_width_px, iteration_width)

	// -- render --

	// now that everything's set up, we can render everything based on the solved sizes.
	var/middle_width = rendering_width_px + VOLUMETRIC_STORAGE_EDGE_PADDING * 2
	// i hate byond i hate byond i hate byond i hate byond; this is because things break if we don't extend by 2 pixels
	// at a time for left/right as we use a dumb transform matrix and screen loc to shift, instead of a scale and shift matrix
	middle_width = CEILING(middle_width, 2)
	// todo: instead of this crap we should instead have the translation matrix do the shift
	var/middle_shift = round(middle_width * 0.5 - VOLUMETRIC_STORAGE_BOX_ICON_SIZE * 0.5)
	// render left
	var/atom/movable/screen/storage/panel/volumetric/left/p_left = new
	. += p_left
	p_left.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
		BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
	// render middle
	var/atom/movable/screen/storage/panel/volumetric/middle/p_box = new
	. += p_box
	p_box.set_pixel_width(middle_width)
	p_box.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_shift],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_shift],\
		BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
	p_box.color = get_ui_drawer_tint()
	// render closer on bottom
	var/atom/movable/screen/storage/closer/closer = new
	. += closer
	closer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y]"
	// render right sides above closer
	if(current_row > 1)
		var/atom/movable/screen/storage/panel/volumetric/right/p_right = new
		. += p_right
		p_right.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width - WORLD_ICON_SIZE + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + 1]:[STORAGE_UI_START_PIXEL_Y] to \
			LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width - WORLD_ICON_SIZE + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
