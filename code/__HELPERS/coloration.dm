//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/unpack_coloration_string(str)
	RETURN_TYPE(/list)
	var/list/fragments = splittext(str, "#")
	if(!length(fragments))
		return list()
	fragments.Cut(1, 2)
	return fragments

/**
 * Doesn't support matrices. Matrices get kicked to #ffffff.
 */
/proc/pack_coloration_string(list/colors)
	var/cloned
	for(var/i in 1 to length(colors))
		var/c = colors[i]
		if(islist(c))
			if(!cloned)
				cloned = TRUE
				colors = colors.Copy()
			colors[i] = "#ffffff"
	return jointext(colors, "")
