// these two variables control max dynamic resize for viewport
GLOBAL_VAR_INIT(max_client_view_x, 19)
GLOBAL_VAR_INIT(max_client_view_y, 15)
// these two variables **reflect** (config updates, not this!) effective default viewsize for view(), range(), etc.
GLOBAL_VAR_INIT(game_view_x, 19)
GLOBAL_VAR_INIT(game_view_y, 15)
// minimum size viewports can be
GLOBAL_VAR_INIT(min_client_view_x, 15)
GLOBAL_VAR_INIT(min_client_view_y, 15)
// these two variables, if set, lock all clients to a certain viewsize no matter what
GLOBAL_VAR(lock_client_view_x)
GLOBAL_VAR(lock_client_view_y)

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

//! Core viewport procs
//! These don't obey the read-write lock, and should only be called from the synchronized procs!

/**
 * populates important vars that things may read early before we sleep
 */
/client/proc/pre_init_viewport()
	PRIVATE_PROC(TRUE)
	current_viewport_width = GLOB.max_client_view_x
	current_viewport_height = GLOB.max_client_view_y

/**
 * called on client init to do this without blocking client/New
 */
/client/proc/init_viewport_blocking()
	PRIVATE_PROC(TRUE)
	fetch_viewport()
	refit_viewsize()
	// release the initial lock
	viewport_rwlock = FALSE

/**
 * called to manually update viewport vars since the skin macro is only triggered on resize
 *
 * return TRUE if changed
 */
/client/proc/fetch_viewport()
	PRIVATE_PROC(TRUE)
	. = FALSE
	// get vars only; they have to manually refit
	var/list/got = params2list(winget(src, SKIN_MAP_ID_VIEWPORT, "size;zoom;letterbox"))
	var/got_zoom = text2num(got["zoom"]) || 0
	var/got_box = (got["letterbox"] == "true")
	var/list/split = splittext(got["size"], "x")
	var/got_spx
	var/got_spy
	if(length(split) == 2)
		got_spx = text2num(split[1]) || (WORLD_ICON_SIZE * GLOB.game_view_x)
		got_spy = text2num(split[2]) || (WORLD_ICON_SIZE * GLOB.game_view_y)
	else
		stack_trace("fetch_viewport failed to get spx/spy")
		got_spx = (WORLD_ICON_SIZE * GLOB.game_view_x)
		got_spy = (WORLD_ICON_SIZE * GLOB.game_view_y)
	if(got_zoom != assumed_viewport_zoom || got_spx != assumed_viewport_spx || got_spy != assumed_viewport_spy || got_box != assumed_viewport_box)
		. = TRUE
		assumed_viewport_zoom = got_zoom
		assumed_viewport_spx = got_spx
		assumed_viewport_spy = got_spy
		assumed_viewport_box = got_box

/**
 * called to refit our view size as necessary
 *
 * this is automatically called every time something modifies us
 */
/client/proc/refit_viewsize(no_fit)
	PRIVATE_PROC(TRUE)
	if(!isnull(GLOB.lock_client_view_x) && !isnull(GLOB.lock_client_view_y))
		view = "[GLOB.lock_client_view_x]x[GLOB.lock_client_view_y]"
		on_refit_viewsize(GLOB.lock_client_view_x, GLOB.lock_client_view_y, no_fit)
		return
	if(using_temporary_viewsize)
		view = "[temporary_viewsize_width]x[temporary_viewsize_height]"
		on_refit_viewsize(temporary_viewsize_width, temporary_viewsize_height, no_fit)
		return
	var/widescreen = is_widescreen_enabled()
	if(!widescreen)
		// if not widescreen, we should just force to 15 x 15 and their augmented view
		var/width = 15 + (using_perspective.augment_view_width * 2)
		var/height = 15 + (using_perspective.augment_view_height * 2)
		view = "[width]x[height]"
		on_refit_viewsize(width, height, no_fit)
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
			on_refit_viewsize(max_width, max_height)
			return
		// option 2: they're stretching to fit the longest side
		else
			// todo: handle horizontally-wider view sizes
			// for now we only care about horizontal fit
			var/stretch_pixel_amount = assumed_viewport_spy / max_height
			var/available_width = assumed_viewport_spx / stretch_pixel_amount
			available_width = CEILING(available_width, 1)
			available_width = clamp(available_width, GLOB.min_client_view_x, max_width)
			view = "[available_width]x[max_height]"
			on_refit_viewsize(available_width, max_height, no_fit)
			return
	// option 3: scale as necessary
	var/pixels_per_tile = assumed_viewport_zoom * WORLD_ICON_SIZE
	var/div_x = assumed_viewport_spx / pixels_per_tile
	var/div_y = assumed_viewport_spy / pixels_per_tile
	div_x = CEILING(div_x, 1)
	div_y = CEILING(div_y, 1)
	var/desired_width = clamp(div_x, GLOB.min_client_view_x, max_width)
	var/desired_height = clamp(div_y, GLOB.min_client_view_y, max_height)
	view = "[desired_width]x[desired_height]"
	on_refit_viewsize(desired_width, desired_height, no_fit)

/client/proc/on_refit_viewsize(new_width, new_height, no_fit)
	var/changed = (current_viewport_height != new_height) || (current_viewport_width != new_width)
	if(changed)
		current_viewport_width = new_width
		current_viewport_height = new_height
		if(!no_fit && is_auto_fit_viewport_enabled())
			fit_viewport()
	post_refit_viewsize(changed)

/**
 * updates everything when our viewport changes
 */
/client/proc/post_refit_viewsize(changed)
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
 * called to fit our viewport to what we **should** have to get our effective view.
 */
/client/proc/fit_viewport()
	// by now we already fetched viewport
	// figure out how big they want it to be based on their settings
	// note: we only care about horizontal because the splitter.. is, well, horizontal.
	var/desired_pixel_width
	// todo: pref
	// maximum % they're willing to have their map
	var/maximum_splitter_percent = 80
	// splitter intrinsic width
	var/assumed_splitter_width = 4
	// effective size
	var/widescreen = is_widescreen_enabled()
	var/effective_view_width
	var/effective_view_height
	// todo: optimize the shit out of this proc and the view system
	if(!isnull(GLOB.lock_client_view_x) && !isnull(GLOB.lock_client_view_y))
		effective_view_width = GLOB.lock_client_view_x
		effective_view_height = GLOB.lock_client_view_y
	else if(widescreen)
		effective_view_width = clamp(temporary_viewsize_width || using_perspective.cached_view_width, GLOB.min_client_view_x, 67)
		effective_view_height = clamp(temporary_viewsize_height || using_perspective.cached_view_height, GLOB.min_client_view_y, 67)
	else
		effective_view_width = clamp(temporary_viewsize_width || (15 + (using_perspective.augment_view_width * 2)), GLOB.min_client_view_x, 67)
		effective_view_height = clamp(temporary_viewsize_height || (15 + (using_perspective.augment_view_height * 2)), GLOB.min_client_view_y, 67)
	if(assumed_viewport_zoom == 0)
		// they're stretching to fit; this makes it annoying
		var/aspect_ratio = effective_view_width / effective_view_height
		// we have to fit everything
		// viewport_spy should never change since that's not what the player can drag,
		// unless they resize the outer window itself.
		desired_pixel_width = assumed_viewport_spy * aspect_ratio
	else
		// they're not using stretch to fit; this makes it very easy
		desired_pixel_width = WORLD_ICON_SIZE * assumed_viewport_zoom * effective_view_width
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
	var/current_width = text2num(parsed[1])
	var/last_width = current_width
	if(current_width == desired_pixel_width)
		// done
		return
	// nope, start adjusting
	delta = 100 * ((desired_pixel_width - current_width) / screen_width)
	for(var/safety in 1 to 10)
		current_percent = min(current_percent + delta, maximum_splitter_percent)
		winset(src, SKIN_SPLITTER_ID_MAIN, "splitter=[current_percent]")
		fetching = winget(src, SKIN_MAP_ID_VIEWPORT, "size")
		parsed = splittext(fetching, "x")
		current_width = text2num(parsed[1])
		// done?
		if(current_width == desired_pixel_width)
			return
		// if we're literally down to a pixel how about like Don't
		if(last_width == current_width)
			return
		last_width = current_width
		// keep adjusting
		// overshot?
		if ((delta > 0 && current_width > desired_pixel_width) || (delta < 0 && current_width < desired_pixel_width))
			// reverse in half
			delta = -delta / 2

//! Synchronized procs; calling these from outside is fine.
/**
 * call this when things change to queue an update
 *
 * should only be called **in code**, not by the skin!
 *
 * warning: this proc doesn't refit instantly, it only queues.
 * client decides what time is best to refit.
 */
/client/proc/request_viewport_update()
	set waitfor = FALSE
	if(!viewport_rwlock)
		_request_viewport_update()
	if(!viewport_queued)
		viewport_queued = TRUE
		addtimer(CALLBACK(src, .proc/_request_viewport_update), 0)

/**
 * call this when things change to queue an update
 *
 * should only be called **in code**, not by the skin!
 *
 * blocks until finished
 */
/client/proc/request_viewport_update_blocking()
	if(!viewport_rwlock)
		_request_viewport_update()
		return
	if(!viewport_queued)
		viewport_queued = TRUE
		addtimer(CALLBACK(src, .proc/_request_viewport_update), 0)
	UNTIL(!viewport_queued)

// todo : locks are probably bad when working with request fit
/client/proc/_request_viewport_update(no_fit, no_fetch)
	PRIVATE_PROC(TRUE)
	// if rwlocked, wait; people should be queuing and not calling this directly
	UNTIL(!viewport_rwlock)
	// clear queued
	viewport_queued = FALSE
	// lock
	viewport_rwlock = TRUE
	if(!no_fetch)
		fetch_viewport()
	// refit size based on viewport
	refit_viewsize(no_fit)
	// release lock
	viewport_rwlock = FALSE

/**
 * call this to request a viewport fit
 */
/client/proc/request_viewport_fit(no_recalc)
	set waitfor = FALSE
	_request_viewport_fit(no_recalc)

/**
 * call this to request a viewport fit
 * forcefully fits
 * blocks until finished
 * don't call this from non-buttons because it blocks and
 * absolutely can stack and ruin everyone's day.
 */
/client/proc/viewport_fit_blocking(no_recalc)
	UNTIL(!viewport_rwlock)
	return _request_viewport_fit(no_recalc)

// todo : locks are probably bad when working with request update
/client/proc/_request_viewport_fit(no_recalc)
	PRIVATE_PROC(TRUE)
	// if viewport is locked, ignore it
	if(viewport_rwlock)
		return
	// acquire lock
	viewport_rwlock = TRUE
	// just in case because this is called by a lot of things that are too shitcoded to update (like my own code)
	fetch_viewport()
	// fit viewport
	fit_viewport()
	// fetch values; we do not trust on-size to trigger
	fetch_viewport()
	// then refit the viewsize if needed
	if(!no_recalc)
		refit_viewsize()
	// release lock
	viewport_rwlock = FALSE

/**
 * called directly by the skin when resizing
 *
 * @params
 * - w - width of viewport in pixels
 * - h - height of viewport in pixels
 * - z - zoom of viewport
 * - b - are we letterboxing?
 */
/client/verb/on_viewport(w as text, h as text, z as num, b as num)
	set name = ".on_viewport"
	set hidden = TRUE
	if(viewport_rwlock)	// something is fucking around, don't edit for them
		return
	// get vars
	assumed_viewport_spx = text2num(w)
	assumed_viewport_spy = text2num(h)
	assumed_viewport_zoom = z
	assumed_viewport_box = b
	// refit
	_request_viewport_update(TRUE, TRUE)

/**
 * automatically fit their viewport to show everything optimally
 */
/client/verb/user_fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"
	request_viewport_fit()

/client/verb/force_map_zoom(n as num)
	set name = ".viewport_zoom"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(!isnum(n) || n < 0)
		to_chat(usr, SPAN_WARNING("invalid number"))
		return
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	winset(src, SKIN_MAP_ID_VIEWPORT, "zoom=[n]")
	assumed_viewport_zoom = n
	request_viewport_update(TRUE)

/client/verb/force_map_box(n as num)
	set name = ".viewport_box"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	n = !!n	// force bool
	winset(src, SKIN_MAP_ID_VIEWPORT, "letterbox=[n? "true" : "false"]")
	assumed_viewport_box = n
	request_viewport_update(TRUE)

/client/verb/force_onresize_view_update()
	set name = ".viewport_update"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	if(viewport_rwlock)
		to_chat(usr, SPAN_WARNING("Viewport is rwlocked; try again later."))
		return
	request_viewport_update()

/client/verb/show_winset_debug_values()
	set name = ".viewport_debug"
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
