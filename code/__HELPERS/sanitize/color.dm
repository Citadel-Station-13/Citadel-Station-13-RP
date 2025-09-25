/**
 * probably, because the matrix isn't sanitized for numbers, just that it's the right length of list.
 */
/proc/sanitize_probably_a_byond_color(what, default = "#ffffffff")
	if(istext(what))
		return sanitize_hexcolor(what, 8, 1, default)
	if(islist(what))
		var/list/cmatrix = what
		switch(length(cmatrix))
			if(9, 12, 16, 20)
				return cmatrix
		return default
	return default

/proc/sanitize_hexcolor(color, desired_format=3, include_crunch=0, default)
	// TODO: don't check this here, do `sanitize_rgba_hexcolor` or something
	switch(desired_format)
		if(3 to 4)
		if(6 to 8)
		else
			CRASH("asked for a nonsensical format ([desired_format])")

	var/crunch = include_crunch ? "#" : ""
	if(!istext(color))
		color = ""

	var/start = 1 + (text2ascii(color, 1) == 35)
	var/len = length(color)
	var/char = ""

	// check if we want to convert from 6-character to 3-character
	var/want_shorthand = FALSE
	switch(desired_format)
		if(3, 4)
			if(length(color) > desired_format)
				want_shorthand = TRUE

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
		if(want_shorthand && i <= len) //skip next one
			i += length(color[i])

	var/resultant_length = length(.)

	// special case: insert alpha if it's not there
	var/has_alpha = resultant_length == 4 || resultant_length == 8
	var/want_alpha = desired_format == 4 || desired_format == 8
	if(!has_alpha && want_alpha)
		. += want_shorthand ? "f" : "ff"

	// check format is correct, if not, toss
	if(resultant_length != desired_format)
		if(default)
			return default
		return crunch + repeat_string(desired_format, "0")

	return crunch + .
