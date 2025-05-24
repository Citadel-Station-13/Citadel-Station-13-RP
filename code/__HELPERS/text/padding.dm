//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * not unicode-aware!
 */
/proc/string_leftpad(txt, amount, char = " ")
	if(!istext(txt))
		txt = "[txt]"
	if(length(txt) >= amount)
		return txt
	// safety
	ASSERT(amount < 128)
	return "[jointext(new /list(amount - length(txt) + 1), char)][txt]"

/**
 * * not unicode-aware!
 */
/proc/string_rightpad(txt, amount, char = " ")
	if(!istext(txt))
		txt = "[txt]"
	if(length(txt) >= amount)
		return txt
	// safety
	ASSERT(amount < 128)
	return "[txt][jointext(new /list(amount - length(txt) + 1), char)]"
