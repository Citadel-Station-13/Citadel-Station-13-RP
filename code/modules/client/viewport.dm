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
	#warn impl

/**
 * forces screensize update; use for config VAS
 */
/datum/controller/configuration/proc/update_player_viewsize()
	#warn impl

/client
	/// what we *think* their current viewport size is in pixels
	var/assumed_viewport_spx
	/// what we *think* their current viewport size is in pixels
	var/assumed_viewport_spy
	/// what we *think* their current viewport zoom is
	var/assumed_viewport_zoom
	/// what we *think* their current viewport letterboxing setting is
	var/assumed_viewport_box

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
	// get vars only; they have to manually refit
	var/list/got = list2params(winget(src, SKIN_MAP_ID_VIEWPORT, "size;zoom;letterbox"))
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
 * - width - width of viewport in pixels
 * - height - height of viewport in pixels
 * - zoom - zoom of viewport
 * - letterbox - are we letterboxing?
 */
/client/verb/on_viewport(width, height, zoom, letterbox)
	set name = ".on_viewport"
	set hidden = TRUE
	// get vars
	assumed_viewport_spx = width
	assumed_viewport_spy = height
	assumed_viewport_zoom = zoom
	assumed_viewport_box = letterbox
	// refit
	refit_viewport()

/**
 * called to refit the viewport as necessary
 */
/client/proc/refit_viewport()
	// if they're stretching to fit

	var/desired_x
	var/desired_y

/client/verb/OnResize()
	set hidden = 1
	#warn if they don't scale we should do something smart to make it work kinda maybe
	if(!is_preference_enabled(/datum/client_preference/scaling_viewport))
		return
	var/divisor = text2num(winget(src, "mapwindow.map", "icon-size")) || world.icon_size
	if(!isnull(GLOB.lock_client_view_x) && !isnull(GLOB.lock_client_view_y))
		last_view_x_dim = GLOB.lock_client_view_x
		last_view_y_dim = GLOB.lock_client_view_y
	else
		var/winsize_string = winget(src, "mapwindow.map", "size")
		last_view_x_dim = GLOB.lock_client_view_x || clamp(ROUND_UP(text2num(winsize_string) / divisor), 15, (CONFIG_GET(number/max_client_view_x)) || (CONFIG_GET(number/max_client_view_x)))
		last_view_y_dim = GLOB.lock_client_view_y || clamp(ROUND_UP(text2num(copytext(winsize_string,findtext(winsize_string,"x")+1,0)) / divisor), 15, (CONFIG_GET(number/max_client_view_y)) || 41)

		if(last_view_x_dim % 2 == 0)
			last_view_x_dim++
		if(last_view_y_dim % 2 == 0)
			last_view_y_dim++

	for(var/check_icon_size in GLOB.valid_icon_sizes)
		winset(src, "menu.icon[check_icon_size]", "is-checked=false")
	winset(src, "menu.icon[divisor]", "is-checked=true")

	view = "[last_view_x_dim]x[last_view_y_dim]"

	// Reset eye/perspective
	reset_perspective()
/* 	var/last_perspective = perspective
	perspective = MOB_PERSPECTIVE
	if(perspective != last_perspective)
		perspective = last_perspective
	var/last_eye = eye
	eye = mob
	if(eye != last_eye)
		eye = last_eye
	if(mob)
		mob.reload_fullscreen() */
	update_clickcatcher()

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

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


/client/verb/force_onresize_view_update()
	set name = ".viewport_refit"
	set hidden = TRUE
	set src = usr
	set category = "Debug"
	refit_viewport()

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
