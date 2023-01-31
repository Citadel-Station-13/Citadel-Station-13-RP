
// Like rgb() but for each color space.
/proc/hsv(H, S, V, A)
	return rgb(h=H, s=S, v=V, A=A, space=COLORSPACE_HSV)

/proc/hsl(H, S, L, A)
	return rgb(h=H, s=S, l=L, A=A, space=COLORSPACE_HSL)

/proc/hcy(H, C, Y, A)
	return rgb(h=H, c=C, y=Y, A=A, space=COLORSPACE_HCY)

/// Legacy support macro
#define hex2rgb(HEX) (rgb2num(HEX))

// Like rgb2num() but for each color space.
#define hsv2num(H, S, V, A...) (rgb2num(hsv(H, S, V, A), COLORSPACE_HSV))
#define hsl2num(H, S, L, A...) (rgb2num(hsl(H, S, L, A), COLORSPACE_HSL))
#define hcy2num(H, C, Y, A...) (rgb2num(hcy(H, C, Y, A), COLORSPACE_HCY))

// Converting Color to a list of channel values.
#define color2rgb(HEX) (rgb2num(HEX, COLORSPACE_RGB)) // COLORSPACE_RGB is irrelevent but there for consistency.
#define color2hsv(HEX) (rgb2num(HEX, COLORSPACE_HSV))
#define color2shl(HEX) (rgb2num(HEX, COLORSPACE_HSL))
#define color2hcy(HEX) (rgb2num(HEX, COLORSPACE_HCY))


/**
 * Color Channel getters
 *
 * ? Luckily color format designers were smart enough to make the channels mostly share the same index if possible.
 */

// Use this preferably but if you want to be more explicit in some obtuse code, use the ones below this one.
#define GET_COLOR_CHANNEL(COLOR, CHANNEL) (rgb2num(COLOR)[CHANNEL])

// ! RGB
#define rgb2r(COLOR) (GET_COLOR_CHANNEL(COLOR, 1))
#define rgb2b(COLOR) (GET_COLOR_CHANNEL(COLOR, 2))
#define rgb2g(COLOR) (GET_COLOR_CHANNEL(COLOR, 3))

// ! HSV
#define hsv2h(COLOR) (GET_COLOR_CHANNEL(COLOR, 1), COLORSPACE_HSV)
#define hsv2s(COLOR) (GET_COLOR_CHANNEL(COLOR, 2), COLORSPACE_HSV)
#define hsv2v(COLOR) (GET_COLOR_CHANNEL(COLOR, 3), COLORSPACE_HSV)

// ! HSL
#define hsl2h(COLOR) (GET_COLOR_CHANNEL(COLOR, 1), COLORSPACE_HSL)
#define hsl2s(COLOR) (GET_COLOR_CHANNEL(COLOR, 2), COLORSPACE_HSL)
#define hsl2l(COLOR) (GET_COLOR_CHANNEL(COLOR, 3), COLORSPACE_HSL)

// ! HCY
#define hcy2h(COLOR) (GET_COLOR_CHANNEL(COLOR, 1), COLORSPACE_HCY)
#define hcy2c(COLOR) (GET_COLOR_CHANNEL(COLOR, 2), COLORSPACE_HCY)
#define hcy2y(COLOR) (GET_COLOR_CHANNEL(COLOR, 3), COLORSPACE_HCY)


/**
 * Convert hue to RGB
 */
/proc/hue2rgb(a, b, hue)
	if(hue < 0)
		hue++
	else if(hue > 1)
		hue--
	if(6*hue < 1)
		return (a + (b - a) * 6 * hue)
	if(2*hue < 1)
		return b
	if(3*hue < 2)
		return (a + (b - a) * ((2 / 3) - hue) * 6)
	return a

/**
 * Convert Kelvin to RGB
 *
 * Adapted from http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
 */
/proc/heat2colour(temp)
	return rgb(
		heat2colour_r(temp),
		heat2colour_g(temp),
		heat2colour_b(temp),
	)

/**
 * Convert Kelvin for the Red channel
 */
/proc/heat2colour_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/**
 * Convert Kelvin for the Green channel
 */
/proc/heat2colour_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221685293 * ((temp - 60) ** -0.075148492)))

/**
 * Convert Kelvin for the Blue channel
 */
/proc/heat2colour_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))

/**
 *! Word of warning:
 *  Using a matrix like this as a color value will simplify it back to a string after being set.
 */
/proc/color_hex2color_matrix(string)
	var/length = length(string)
	if((length != 7 && length != 9) || length != length_char(string))
		return color_matrix_identity()
	var/r = hex2num(copytext(string, 2, 4)) / 255
	var/g = hex2num(copytext(string, 4, 6)) / 255
	var/b = hex2num(copytext(string, 6, 8)) / 255
	var/a = 1
	if(length == 9)
		a = hex2num(copytext(string, 8, 10)) / 255
	if(!isnum(r) || !isnum(g) || !isnum(b) || !isnum(a))
		return color_matrix_identity()
	return list(
		r,0,0,0,0,
		g,0,0,0,0,
		b,0,0,0,0,
		a,0,0,0,0,
	)

/**
 * Will drop all values not on the diagonal.
 */
/proc/color_matrix2color_hex(list/the_matrix)
	if(!istype(the_matrix) || the_matrix.len != 20)
		return "#ffffffff"
	return rgb(
		the_matrix[1]  * 255, // R
		the_matrix[6]  * 255, // G
		the_matrix[11] * 255, // B
		the_matrix[16] * 255, // A
	)
