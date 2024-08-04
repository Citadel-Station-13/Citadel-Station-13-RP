/**
 * probably, because the matrix isn't sanitized for numbers, just that it's the right length of list.
 */
/proc/sanitize_probably_a_byond_color(what, default = "#ffffff")
	if(istext(what))
		return sanitize_hexcolor(what, 6, 1, default)
	if(islist(what))
		var/list/cmatrix = what
		switch(length(cmatrix))
			if(9, 12, 16, 20)
				return cmatrix
		return default
	return default

/proc/sanitize_hexcolor(color, desired_format=3, include_crunch=0, default)
	var/crunch = include_crunch ? "#" : ""
	if(!istext(color))
		color = ""

	var/start = 1 + (text2ascii(color, 1) == 35)
	var/len = length(color)
	var/char = ""
	// RRGGBB -> RGB but awful
	var/convert_to_shorthand = desired_format == 3 && length_char(color) > 3

	. = ""
	var/i = start
	while(i <= len)
		char = color[i]
		switch(text2ascii(char))
			if(48 to 57)		//numbers 0 to 9
				. += char
			if(97 to 102)		//letters a to f
				. += char
			if(65 to 70)		//letters A to F
				. += lowertext(char)
			else
				break
		i += length(char)
		if(convert_to_shorthand && i <= len) //skip next one
			i += length(color[i])

	if(length_char(.) != desired_format)
		if(default)
			return default
		return crunch + repeat_string(desired_format, "0")

	return crunch + .
