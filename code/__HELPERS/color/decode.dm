//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Decodes a #rrggbb(aa) string.
 *
 * * returned values are from 0 to 255.
 *
 * @params
 * * rgba_string - #rrggbb(aa) string
 * * default_alpha - what alpha is if 'aa' isn't there
 *
 * @return list(r, g, b, a), or null on parse error.
 */
/proc/decode_rgba(rgba_string, default_alpha = 255)
	var/offset = 0
	if(rgba_string[1] == "#")
		offset = 1
	switch(length(rgba_string) - offset)
		if(6, 8)
		else
			CRASH("parse error on rgba string '[rgba_string]")
	// todo: benchmark this is this faster than copytext()
	return list(
		hex2num(copytext(rgba_string, 1 + offset, 3 + offset)),
		hex2num(copytext(rgba_string, 3 + offset, 5 + offset)),
		hex2num(copytext(rgba_string, 5 + offset, 7 + offset)),
		// it's over 7 if alpha exists, even with a #
		length(rgba_string) > 7 ? hex2num(copytext(rgba_string, 7 + offset, 9 + offset)) : default_alpha,
	)
