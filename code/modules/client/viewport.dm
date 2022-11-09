// these two variables control max dynamic resize for viewport
GLOBAL_VAR_INIT(max_client_view_x, 19)
GLOBAL_VAR_INIT(max_client_view_y, 15)
// these two variables **reflect** (config updates, not this!) effective default viewsize for view(), range(), etc.
GLOBAL_VAR_INIT(game_view_x, 19)
GLOBAL_VAR_INIT(game_view_y, 15)
// these two variables, if set, lock all clients to a certain viewsize no matter what
GLOBAL_VAR(lock_client_view_x)
GLOBAL_VAR(lock_client_view_y)
// valid icon sizes for people to set to; set list an entry to string to override default "sizexsize" string.
GLOBAL_LIST_INIT(valid_icon_sizes, list(32, 48, 64 = "64x64 (1080p)", 72 = "72x72 (Cozy 1080p)", 96, 128 = "128x128 (4K)"))

/**
 * forces world viewsize; use for config VAS
 */
/datum/controller/configuration/proc/update_world_viewsize()
	//! BYONd world.view is immutable, for now we're stuck read-onlying it.
	if(isnum(world.view))
		GLOB.game_view_x = GLOB.game_view_y = world.view
	else
		// is text
		var/list/viewsize = splittext(world.view, "x")
		GLOB.game_view_x = viewsize[1]
		GLOB.game_view_y = viewsize[2]

/**
 * forces screensize update; use for config VAS
 */
/datum/controller/configuration/proc/update_player_viewsize()
	var/viewsize_raw = CONFIG_GET(string/max_viewport_size)
	var/list/viewsize = splittext(viewsize_raw, "x")
	GLOB.max_client_view_x = text2num(viewsize[1])
	GLOB.max_client_view_y = text2num(viewsize[2])

/**
 * populates important vars that things may read early before we sleep
 */
/client/proc/pre_init_viewport()
	current_viewport_width = GLOB.max_client_view_x
	current_viewport_height = GLOB.max_client_view_y

/**
 * called on client init to do this without blocking client/New
 */
/client/proc/init_viewport_blocking()
	fetch_viewport()
	refit_viewport()

/**
 * called by verbs that change viewport
 */
/client/verb/re_viewport()
	set name = ".re_viewport"
	set hidden = TRUE
	fetch_viewport()
	refit_viewport()

/**
 * called to manually update viewport vars since the skin macro is only triggered on resize
 */
/client/proc/fetch_viewport()
	if(viewport_rwlock)
		// we're probably spazzing out right now, don't even bother
		return
	viewport_rwlock = TRUE
	_fetch_viewport()
	viewport_rwlock = FALSE

/client/proc/_fetch_viewport()
	PRIVATE_PROC(TRUE)
	// get vars only; they have to manually refit
	var/list/got = params2list(winget(src, SKIN_MAP_ID_VIEWPORT, "size;zoom;letterbox"))
	assumed_viewport_zoom = got["zoom"] || 0
	assumed_viewport_box = (got["letterbox"] == "true")
	var/list/split = splittext(got["size"], "x")
	if(split && split.len == 2)
		assumed_viewport_spx = text2num(split[1]) || (WORLD_ICON_SIZE * GLOB.game_view_x)
		assumed_viewport_spy = text2num(split[2]) || (WORLD_ICON_SIZE * GLOB.game_view_y)
	else
		stack_trace("fetch_viewport failed to get spx/spy")
		assumed_viewport_spx = (WORLD_ICON_SIZE * GLOB.game_view_x)
		assumed_viewport_spy = (WORLD_ICON_SIZE * GLOB.game_view_y)

/**
 * called directly by the skin
 *
 * @params
 * - w - width of viewport in pixels
 * - h - height of viewport in pixels
 * - z - zoom of viewport
 * - b - are we letterboxing?
 */
/client/verb/on_viewport(w as num, h as num, z as num, b as num)
	set name = "on_viewport"
	set hidden = TRUE
	if(viewport_rwlock)	// something is fucking around, don't edit for them
		return
	// get vars
	assumed_viewport_spx = w
	assumed_viewport_spy = h
	assumed_viewport_zoom = z
	assumed_viewport_box = b
	// refit
	refit_viewport()

/**
 * called to refit the viewport as necessary
 */
/client/proc/refit_viewport()
	if(viewport_rwlock)
		// we're probably spazzing out right now, don't even bother
		return
	viewport_rwlock = TRUE
	_refit_viewport()
	viewport_rwlock = FALSE

/client/proc/_refit_viewport()
	if(!isnull(GLOB.lock_client_view_x) && !isnull(GLOB.lock_client_view_y))
		view = "[GLOB.lock_client_view_x]x[GLOB.lock_client_view_y]"
		on_refit_viewport(GLOB.lock_client_view_x, GLOB.lock_client_view_y)
		return
	if(using_temporary_viewsize)
		view = "[temporary_viewsize_width]x[temporary_viewsize_height]"
		on_refit_viewport(temporary_viewsize_width, temporary_viewsize_height)
		return
	var/stretch_to_fit = assumed_viewport_zoom == 0
	using_perspective.ensure_view_cached()
	var/max_width = using_perspective.cached_view_width
	var/max_height = using_perspective.cached_view_height
	if(stretch_to_fit)
		// option 1: they're stretching to fit
		if(assumed_viewport_box)
			// fit everything
			view = "[max_width]x[max_height]"
			on_refit_viewport(max_width, max_height)
			return
		// option 2: they're stretching to fit the longest side
		else
			// in which case..
			// they're going to truncate the smaller size anyways
			view = min(max_width, max_height)
			on_refit_viewport(max_width, max_height)
			return
	// option 3: scale as necessary
	var/pixels_per_tile = assumed_viewport_zoom * WORLD_ICON_SIZE
	var/div_x = assumed_viewport_spx / pixels_per_tile
	var/div_y = assumed_viewport_spy / pixels_per_tile
	div_x = CEILING(div_x, 1)
	div_y = CEILING(div_y, 1)
	var/desired_width = min(max_width, div_x)
	var/desired_height = min(max_height, div_y)
	view = "[desired_width]x[desired_height]"
	on_refit_viewport(desired_width, desired_height)

/client/proc/on_refit_viewport(new_width, new_height)
	var/changed = (current_viewport_height == new_height) && (current_viewport_width == new_width)
	if(changed)
		current_viewport_width = new_width
		current_viewport_height = new_height
	post_refit_viewport(changed)

/**
 * updates everything when our viewport changes
 */
/client/proc/post_refit_viewport(changed)
	if(!changed)
		return
	// force perspective swap for ??? reasons (???)
	var/old_perspective = perspective
	perspective = MOB_PERSPECTIVE
	if(old_perspective != perspective)
		perspective = old_perspective
	// i don't understand the above
	mob?.refit_rendering()

/**
 * automatically fit their viewport to show everything optimally
 */
/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

	// ensure we're not fitting viewport
	if(viewport_rwlock)
		return
	// first, fetch
	fetch_viewport()
	// ensure we're not fitting viewport since above sleeps
	if(viewport_rwlock)
		return
	// start - from here to finish we should have exclusive control over the viewport
	viewport_rwlock = TRUE
	_fit_viewport()
	// finish
	viewport_rwlock = FALSE
	// refit
	refit_viewport()

/client/proc/_fit_viewport()
	// by now we already fetched viewport
	// figure out how big they want it to be based on their settings
	// note: we only care about horizontal because the splitter.. is, well, horizontal.
	var/desired_pixel_width
	// todo: pref
	// maximum % they're willing to have their map
	var/maximum_splitter_percent = 80
	// splitter intrinsic width
	var/assumed_splitter_width = 4
	if(assumed_viewport_zoom == 0)
		// they're stretching to fit; this makes it annoying
	else
		// they're not using stretch to fit; this makes it very easy
		desired_pixel_width = WORLD_ICON_SIZE * assumed_viewport_zoom * current_viewport_width
	// grab their screen size (or what counts as it)
	var/list/fetching = winget(src, SKIN_SPLITTER_ID_MAIN, "size")
	var/list/parsed = splittext(fetching, "x")
	var/screen_width = text2num(parsed[1])
	// grab what percent we should go to
	var/current_percent = min(100 * ((desired_pixel_width + assumed_splitter_width) / screen_width), maximum_splitter_percent)
	// initial set
	winset(src, SKIN_SPLITTER_ID_MAIN, "splitter=[current_percent]")
	// funny method of correcting for misalignments via binary-search-like behavior
	var/delta
	fetching = winget(src, SKIN_MAP_ID_VIEWPORT, "size")
	parsed = splittext(fetching, "x")
	var/current_width = parsed[1]
	if(current_width == desired_pixel_width)
		// done
		return
	// nope, start adjusting
	delta = 100 * ((desired_pixel_width - current_width) / screen_width)
	for(var/safety in 1 to 10)
		current_percent += delta
		winset(src, SKIN_SPLITTER_ID_MAIN, "splitter=[current_percent]")
		fetching = winget(src, SKIN_MAP_ID_VIEWPORT, "size")
		parsed = splittext(fetching, "x")
		current_width = parsed[1]
		// done?
		if(current_width == desired_pixel_width)
			return
		// keep adjusting
		// overshot?
		if ((delta > 0 && current_width > desired_pixel_width) || (delta < 0 && current_width < desired_pixel_width))
			// reverse in half
			delta = -delta / 2

#warn deal with

/*

	// Fetch the client's aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		return	// You're already good fam.

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculate and apply our best estimate
	// +4 pixels are for the eidth of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			return	// Success!

		// Calculate a probable delta value based on the diff
		else if (isnull(delta))
			delta = 100 * (desired_width - got_width) / split_width

		// If we overshot, halve the delta and reverse direction
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")
*/

/client/verb/force_map_zoom(n as num)
	set name = "viewport_zoom"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(!isnum(n) || n < 0)
		to_chat(usr, SPAN_WARNING("invalid number"))
		return
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	viewport_rwlock = TRUE
	winset(src, SKIN_MAP_ID_VIEWPORT, "zoom=[n]")
	assumed_viewport_zoom = n
	viewport_rwlock = FALSE
	refit_viewport()

/client/verb/force_map_box(n as num)
	set name = "viewport_box"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	viewport_rwlock = TRUE
	n = !!n	// force bool
	winset(src, SKIN_MAP_ID_VIEWPORT, "letterbox=[n? "true" : "false"]")
	assumed_viewport_box = n
	viewport_rwlock = FALSE
	refit_viewport()

/client/verb/force_onresize_view_update()
	set name = "viewport_refit"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	fetch_viewport()
	refit_viewport()

/client/verb/show_winset_debug_values()
	set name = "viewport_debug"
	set hidden = TRUE
	set src = usr
	set category = "Debug"

	var/divisor = text2num(winget(src, "mapwindow.map", "icon-size")) || world.icon_size
	var/winsize_string = winget(src, "mapwindow.map", "size")

	to_chat(usr, "Current client view: [view]")
	to_chat(usr, "Icon size: [divisor]")
	to_chat(usr, "xDim: [round(text2num(winsize_string) / divisor)]")
	to_chat(usr, "yDim: [round(text2num(copytext(winsize_string,findtext(winsize_string,"x")+1,0)) / divisor)]")
	to_chat(usr, "server thinks viewport is:[assumed_viewport_spx]/[assumed_viewport_spy]/[assumed_viewport_zoom]/[assumed_viewport_box]")
	to_chat(usr, "server thinks view is:[current_viewport_width]x[current_viewport_height]")
