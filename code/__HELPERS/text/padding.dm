//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/proc/string_leftpad(txt, amount, char = " ")
	if(!istext(txt))
		txt = "[txt]"
	if(length(txt) < amount)
		. = list()
		for(var/i in length(txt) + 1 to amount)
			. += char
		. += txt
		return jointext(., "")
	return txt

