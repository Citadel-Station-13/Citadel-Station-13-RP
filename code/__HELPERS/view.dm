/proc/getviewsize(view)
	var/viewX
	var/viewY
	if(isnum(view))
		var/totalviewrange = 1 + 2 * view
		viewX = totalviewrange
		viewY = totalviewrange
	else
		var/list/viewrangelist = splittext(view,"x")
		viewX = text2num(viewrangelist[1])
		viewY = text2num(viewrangelist[2])
	return list(viewX, viewY)

/proc/params2turf(scr_loc, turf/origin, client/C)
	if(!scr_loc)
		return null
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = CLAMP(origin.x + text2num(tX) - round(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = CLAMP(origin.y + text2num(tY) - round(actual_view[2] / 2) - 1, 1, world.maxy)
	return locate(tX, tY, tZ)

/proc/screen_loc2turf(text, turf/origin, client/C)
	if(!text)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = CLAMP(origin.x + round(actual_view[1] / 2) - tX, 1, world.maxx)
	tY = CLAMP(origin.y + round(actual_view[2] / 2) - tY, 1, world.maxy)
	return locate(tX, tY, tZ)
