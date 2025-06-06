/atom/movable/screen/click_catcher
	name = ""
	icon = 'icons/screen/rendering/clickcatcher.dmi'
	icon_state = "catcher"
	appearance_flags = TILE_BOUND | NO_CLIENT_COLOR | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	plane = CLICKCATCHER_PLANE
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER"

/*
#define MAX_SAFE_BYOND_ICON_SCALE_TILES (MAX_SAFE_BYOND_ICON_SCALE_PX / world.icon_size)
///Not using world.icon_size on purpose.
#define MAX_SAFE_BYOND_ICON_SCALE_PX (33 * 32)
/atom/movable/screen/click_catcher/proc/UpdateFill(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/mob/screen_gen.dmi', "catcher")
	var/ox = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_x)
	var/oy = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(MAX_SAFE_BYOND_ICON_SCALE_PX, px)
	var/sy = min(MAX_SAFE_BYOND_ICON_SCALE_PX, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	transform = M

#undef MAX_SAFE_BYOND_ICON_SCALE_TILES
#undef MAX_SAFE_BYOND_ICON_SCALE_PX
*/

/atom/movable/screen/click_catcher/proc/UpdateFill(view_size_x, view_size_y)
	var/matrix/transforming = matrix()
	transforming.Scale(view_size_x, view_size_y)
	transform = transforming

/atom/movable/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = Parse(modifiers["screen-loc"], get_turf(usr.client?.eye || usr), usr.client)
		params += "&catcher=1"
		if(T)
			T.Click(location, control, params)
	return TRUE

/atom/movable/screen/click_catcher/proc/Parse(scr_loc, turf/origin, client/C)
	// screen-loc: Pixel coordinates in screen_loc format ("[tile_x]:[pixel_x],[tile_y]:[pixel_y]")
	if(!scr_loc || !origin)
		return null
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	var/list/actual_view = decode_view_size(C ? C.view : world.view)
	tX = clamp(origin.x + text2num(tX) - round(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = clamp(origin.y + text2num(tY) - round(actual_view[2] / 2) - 1, 1, world.maxy)
	return locate(tX, tY, tZ)
