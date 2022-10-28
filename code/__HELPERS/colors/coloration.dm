/**
 * unpack coloration string
 *
 * format: #abcdef#abcdef#abcdefgh
 *
 * strings can be rgb or rgba in short or long format
 *
 * return: list of colors, without the # included
 */
/proc/unpack_coloration_string(str, ignore_alpha)
	#warn impl

/**
 * pack coloration string
 *
 * format: list(color, color, color), where color is rgb or gba in short or long format
 *
 * return: coloration string with all colors in long format
 */
/proc/pack_coloration_string(list/colors, ignore_alpha)
	#warn impl
