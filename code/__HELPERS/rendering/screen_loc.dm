/proc/pixel_shift_screen_loc(screen_loc, x, y)
	var/list/split1 = splittext(screen_loc, ",")
	if(length(split1) == 1)
		// bah
		ASSERT(split1[1] == "CENTER")
		return "CENTER:[x],CENTER:[y]"
	var/list/split21 = splittext(split1[1], ":")
	var/list/split22 = splittext(split1[2], ":")
	var/existing_x = length(split21) > 1? split21[2] : null
	var/existing_y = length(split22) > 1? split22[2] : null
	return "[split21[1]]:[(text2num(existing_x) || 0) + x],[split22[1]]:[(text2num(existing_y) || 0) + y]"
