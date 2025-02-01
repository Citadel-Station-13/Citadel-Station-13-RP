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
	if(max_items)
		rendering_width = min(max_items, rendering_width)
	// see if we need to process numerical display
	var/list/datum/storage_numerical_display/numerical_rendered = uses_numerical_ui()? render_numerical_display() : null
	// process indirection
	var/atom/indirection = real_contents_loc()
	// if we have expand when needed, only show 1 more than the actual amount.
	if(ui_expand_when_needed)
		rendering_width = min(rendering_width, (isnull(numerical_rendered)? length(indirection.contents) : length(numerical_rendered)) + 1)
	// compute count and rows
	var/item_count = isnull(numerical_rendered)? length(indirection.contents) : length(numerical_rendered)
	var/rows_needed = ROUND_UP(item_count / rendering_width) || 1
	// prepare iteration
	var/current_row = 1
	var/current_column = 1
	// render boxes
	boxes.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X + rendering_width - 1]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y + rows_needed - 1]:[STORAGE_UI_START_PIXEL_Y]"
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
		for(var/obj/item/item in indirection)
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

/datum/object_system/storage/proc/create_ui_volumetric_mode(mob/user)
	// guard against divide-by-0's
	if(!max_combined_volume)
		return create_ui_slot_mode(user)
	. = list()

	//? resolve view and rendering
	// todo: clientless support is awful here

	// resolve view
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	// setup initial width
	var/rendering_width = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	var/rendering_width_in_pixels = rendering_width * 32
	// effective max scales up if we're overrunning
	var/effective_max_volume = max(max_combined_volume, cached_combined_volume)
	// scale down width to volume
	rendering_width_in_pixels = min(rendering_width_in_pixels, effective_max_volume * VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO)

	//? resolve items

	// resolve indirection
	var/atom/indirection = real_contents_loc()

	//? prepare iteration

	// max x used in all rows, including padding.
	var/maximum_used_width = 0
	// current consumed x of row
	var/iteration_used_width = 0
	// current consumed item padding of row
	var/iteration_used_padding = 0
	// current row
	var/current_row = 1
	// safety
	var/safety = VOLUMETRIC_STORAGE_MAX_ITEMS
	// iterate and render
	for(var/obj/item/item in indirection)
		// check safety
		safety--
		if(safety <= 0)
			to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
			break

		// check row
		if(iteration_used_width >= rendering_width_in_pixels)
			// check if we're out of rows
			if(current_row >= STORAGE_UI_MAX_ROWS)
				to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
				break
			// make another row
			current_row++
			// register to maximum used width
			// we add the edge padding for both edges, but remove the last item's padding.
			maximum_used_width = max(maximum_used_width, iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING * 2 - VOLUMETRIC_STORAGE_ITEM_PADDING)
			// reset vars
			iteration_used_padding = 0
			iteration_used_width = 0

		// render the item
		var/atom/movable/screen/storage/item/volumetric/renderer = new(null, item)
		// scale it as necessary, to nearest multiple of 2
		var/used_pixels = max(VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM, CEILING(rendering_width_in_pixels * (item.get_weight_volume() / effective_max_volume), 2))
		// emit to renderer
		renderer.set_pixel_width(used_pixels)
		// set screen loc
		renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + (iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING) + (used_pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
		// add to emitted screen list
		. += renderer
		// add to iteration tracking
		iteration_used_width += used_pixels
		iteration_used_padding += VOLUMETRIC_STORAGE_ITEM_PADDING
	// register to maximum used width
	// we add the edge padding for both edges, but remove the last item's padding.
	maximum_used_width = max(maximum_used_width, iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING * 2 - VOLUMETRIC_STORAGE_ITEM_PADDING)

	// now that everything's set up, we can render everything based on the solved sizes.
	// middle size; we also keep in account padding so there's a smooth expansion instead of a sudden expansion at the end.
	var/middle_width = max(maximum_used_width, rendering_width_in_pixels + iteration_used_padding)
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
