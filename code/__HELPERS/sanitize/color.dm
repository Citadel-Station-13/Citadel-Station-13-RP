//! ascii 65 to 70 is A to F, 48 to 57 is 0 to 9.
#define VALID_HEX_ASCII(n) ((n <= 57)? (n >= 48) : ((n >= 65) && (n <= 70)))

/**
 * check hexcolor
 */
/proc/is_hexcolor(color, allow_short)
	var/color_len = length(color)
	switch(color_len)
		if(4)
			if(!allow_short)
				return FALSE
			if(color[1] != "#")
				return FALSE
			for(var/i in 2 to 4)
				var/c = color[i]
				if(!VALID_HEX_ASCII(c))
					return FALSE
		if(7)
			if(color[1] != "#")
				return FALSE
			for(var/i in 2 to 7)
				var/c = color[i]
				if(!VALID_HEX_ASCII(c))
					return FALSE
	return FALSE

/**
 * check if the list looks vaguely like a color matrix without
 * using expensive string ops on every value
 * basically, just check length
 */
/proc/is_list_vaguely_color_matrix_length(list/L)
	switch(L.len)
		if(3 to 5)
			return TRUE
		if(9)
			return TRUE
		if(12)
			return TRUE
		if(16)
			return TRUE
		if(20)
			return TRUE
	return FALSE

#undef VALID_HEX_ASCII
