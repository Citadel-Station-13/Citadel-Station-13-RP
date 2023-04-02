/**
 * Turns the icon into a greyscaled icon. Alpha masks are untouched.
 */
/icon/proc/greyscale()
	MapColors(
		GREYSCALE_MULT_R, GREYSCALE_MULT_R, GREYSCALE_MULT_R,
		GREYSCALE_MULT_G, GREYSCALE_MULT_G, GREYSCALE_MULT_G,
		GREYSCALE_MULT_B, GREYSCALE_MULT_B, GREYSCALE_MULT_B
	)

/**
 * rgb value to greyscale
 */
/proc/rgb_greyscale(rgb)
	var/list/unpacked = ReadRGB(rgb)
	var/gray = unpacked[1] * GREYSCALE_MULT_R + unpacked[2] *GREYSCALE_MULT_G + unpacked[3] * GREYSCALE_MULT_B
	return (unpacked.len > 3) ? rgb(gray, gray, gray, unpacked[4]) : rgb(gray, gray, gray)
