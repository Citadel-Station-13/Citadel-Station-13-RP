/proc/decode_view_size(view)
	if(isnum(view))
		var/totalviewrange = 1 + 2 * view
		return list(totalviewrange, totalviewrange)
	else
		var/list/viewrangelist = splittext(view,"x")
		return list(text2num(viewrangelist[1]), text2num(viewrangelist[2]))

// TODO: optimize
/proc/world_view_max_number()
	if(isnum(world.view))
		return world.view
	var/list/decoded = decode_view_size(world.view)
	return max(decoded[1], decoded[2])
