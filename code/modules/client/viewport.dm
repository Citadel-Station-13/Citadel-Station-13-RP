GLOBAL_VAR_INIT(lock_client_view_x, null)
GLOBAL_VAR_INIT(lock_client_view_y, null)
GLOBAL_LIST_INIT(valid_icon_sizes, list(32, 48, 64, 72, 96, 128))

/datum/preferences
	var/icon_size = 64

/client
	var/last_view_x_dim = 7
	var/last_view_y_dim = 7


/client/verb/SetCozyViewInwards(val as num|text)
	set hidden = 1

	if(prefs && val != prefs.icon_size)
		prefs.icon_size += val
		SScharacter_setup.queue_preferences_save(prefs)
	winset(src, "mapwindow.map", "icon-size=[prefs.icon_size]")
	OnResize()

/client/verb/SetWindowIconSize(val as num|text)
	set hidden = 1
	winset(src, "mapwindow.map", "icon-size=[val]")
	if(prefs && val != prefs.icon_size)
		prefs.icon_size = val
		SScharacter_setup.queue_preferences_save(prefs)
	OnResize()

/client/verb/OnResize()
	set hidden = 1
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

/client/verb/force_onresize_view_update()
	set name = "Force Client View Update"
	set src = usr
	set category = "Debug"
	OnResize()

/client/verb/show_winset_debug_values()
	set name = "Show Client View Debug Values"
	set src = usr
	set category = "Debug"

	var/divisor = text2num(winget(src, "mapwindow.map", "icon-size")) || world.icon_size
	var/winsize_string = winget(src, "mapwindow.map", "size")

	to_chat(usr, "Current client view: [view]")
	to_chat(usr, "Icon size: [divisor]")
	to_chat(usr, "xDim: [round(text2num(winsize_string) / divisor)]")
	to_chat(usr, "yDim: [round(text2num(copytext(winsize_string,findtext(winsize_string,"x")+1,0)) / divisor)]")
