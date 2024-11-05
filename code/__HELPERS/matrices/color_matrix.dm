/////////////////////
// COLOUR MATRICES //
/////////////////////

/* Documenting a couple of potentially useful color matrices here to inspire ideas
// Greyscale - indentical to saturation @ 0
list(LUMA_R,LUMA_R,LUMA_R,0, LUMA_G,LUMA_G,LUMA_G,0, LUMA_B,LUMA_B,LUMA_B,0, 0,0,0,1, 0,0,0,0)

// Color inversion
list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

// Sepiatone
list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)
*/

//Changes distance hues have from grey while maintaining the overall lightness. Greys are unaffected.
//1 is identity, 0 is greyscale, >1 oversaturates colors
/proc/color_matrix_saturation(value)
	var/inv = 1 - value
	var/R = round(LUMA_R * inv, 0.001)
	var/G = round(LUMA_G * inv, 0.001)
	var/B = round(LUMA_B * inv, 0.001)

	return list(R + value,R,R,0, G,G + value,G,0, B,B,B + value,0, 0,0,0,1, 0,0,0,0)

//Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys
//0 is identity, 120 moves reds to greens, 240 moves reds to blues
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333*(1-cos)
	var/sqrt3_sin = sqrt(3)*sin
	return list(
round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), 0,
round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), 0,
round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), 0,
0,0,0,1,
0,0,0,0)

//These next three rotate values about one axis only
//x is the red axis, y is the green axis, z is the blue axis.
/proc/color_matrix_rotate_x(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(1,0,0,0, 0,cosval,sinval,0, 0,-sinval,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_y(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,0,-sinval,0, 0,1,0,0, sinval,0,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_z(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,sinval,0,0, -sinval,cosval,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)


//Returns a matrix addition of A with B
/proc/color_matrix_add(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(A.len != 20 || B.len != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	for(var/value in 1 to 20)
		output[value] = A[value] + B[value]
	return output

//Returns a matrix multiplication of A with B
/proc/color_matrix_multiply(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(A.len != 20 || B.len != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	var/x = 1
	var/y = 1
	var/offset = 0
	for(y in 1 to 5)
		offset = (y-1)*4
		for(x in 1 to 4)
			output[offset+x] = round(A[offset+1]*B[x] + A[offset+2]*B[x+4] + A[offset+3]*B[x+8] + A[offset+4]*B[x+12]+(y == 5?B[x+16]:0), 0.001)
	return output

/**
 * Converts RGB shorthands into RGBA matrices complete of constants rows (ergo a 20 keys list in byond).
 * if return_identity_on_fail is true, stack_trace is called instead of CRASH, and an identity is returned.
 */
/proc/color_to_full_rgba_matrix(color, return_identity_on_fail = TRUE)
	if(!color)
		return COLOR_MATRIX_IDENTITY
	if(istext(color))
		var/list/L = rgb2num(color)
		if(!L)
			var/message = "Invalid/unsupported color ([color]) argument in color_to_full_rgba_matrix()"
			if(return_identity_on_fail)
				stack_trace(message)
				return COLOR_MATRIX_IDENTITY
			CRASH(message)
		return list(L[1]/255,0,0,0, 0,L[2]/255,0,0, 0,0,L[3]/255,0, 0,0,0,L.len>3?L[4]/255:1, 0,0,0,0)
	if(!islist(color)) //invalid format
		CRASH("Invalid/unsupported color ([color]) argument in color_to_full_rgba_matrix()")
	var/list/L = color
	switch(L.len)
		if(3 to 5) // row-by-row hexadecimals
			. = list()
			for(var/a in 1 to L.len)
				var/list/rgb = rgb2num(L[a])
				for(var/b in rgb)
					. += b/255
				if(length(rgb) % 4) // RGB has no alpha instruction
					. += a != 4 ? 0 : 1
			if(L.len < 4) //missing both alphas and constants rows
				. += list(0,0,0,1, 0,0,0,0)
			else if(L.len < 5) //missing constants row
				. += list(0,0,0,0)
		if(9 to 12) //RGB
			. = list(L[1],L[2],L[3],0, L[4],L[5],L[6],0, L[7],L[8],L[9],0, 0,0,0,1)
			for(var/b in 1 to 3)  //missing constants row
				. += L.len < 9+b ? 0 : L[9+b]
			. += 0
		if(16 to 20) // RGBA
			. = L.Copy()
			if(L.len < 20) //missing constants row
				for(var/b in 1 to 20-L.len)
					. += 0
		else
			var/message = "Invalid/unsupported color (list of length [L.len]) argument in color_to_full_rgba_matrix()"
			if(return_identity_on_fail)
				stack_trace(message)
				return COLOR_MATRIX_IDENTITY
			CRASH(message)

//! legacy

/**
 * Force a matrix to be a full 20 value rgba matrix.
 */
/proc/color_matrix_expand(list/M)
	var/list/expanding = M.Copy()
	. = expanding
	switch(length(M))
		if(20) // rgba full with constant
		if(9) // rgb without constant
			expanding.Insert(4, 0) // inject ra
			expanding.Insert(8, 0) // inject ga
			expanding.Insert(12, 0) // inject ba
			expanding.Insert(13, 0, 0, 0, 1) // inject ar to aa
			expanding.Insert(17, 0, 0, 0, 0) // inject cr to ca
		if(12) // rgb with constant			expanding.Insert(4, 0)
			expanding.Insert(4, 0) // insert ra
			expanding.Insert(8, 0) // inject ga
			expanding.Insert(12, 0) // inject ba
			expanding.Insert(13, 0, 0, 0, 1) // inject ar to aa
			expanding.Insert(20, 0) // inject ca
		if(16) // rgba without constant
			expanding.Insert(17, 0, 0, 0, 0) // inject cr to ca
		else
			. = COLOR_MATRIX_IDENTITY
			CRASH("what?")

/**
 * Builds a color matrix that transforms the hue, saturation, and value, all in one operation.
 */
/proc/color_matrix_hsv(hue, saturation, value)
	hue = clamp(360 - hue, 0, 360)

	// This is very much a rough approximation of hueshifting. This carries some artifacting, such as negative values that simply shouldn't exist, but it does get the job done, and that's what matters.
	var/cos_a = cos(hue) // These have to be inverted from 360, otherwise the hue's inverted
	var/sin_a = sin(hue)
	var/rot_x = cos_a + (1 - cos_a) / 3
	var/rot_y = (1 - cos_a) / 3 - 0.5774 * sin_a // 0.5774 is sqrt(1/3)
	var/rot_z = (1 - cos_a) / 3 + 0.5774 * sin_a

	return list(
		round((((1-saturation) * LUMA_R) + (rot_x * saturation)) * value, 0.01), round((((1-saturation) * LUMA_R) + (rot_y * saturation)) * value, 0.01), round((((1-saturation) * LUMA_R) + (rot_z * saturation)) * value, 0.01),
		round((((1-saturation) * LUMA_G) + (rot_z * saturation)) * value, 0.01), round((((1-saturation) * LUMA_G) + (rot_x * saturation)) * value, 0.01), round((((1-saturation) * LUMA_G) + (rot_y * saturation)) * value, 0.01),
		round((((1-saturation) * LUMA_B) + (rot_y * saturation)) * value, 0.01), round((((1-saturation) * LUMA_B) + (rot_z * saturation)) * value, 0.01), round((((1-saturation) * LUMA_B) + (rot_x * saturation)) * value, 0.01),
		0, 0, 0
	)

/**
 * Assembles a color matrix, defaulting to identity.
 */
/proc/construct_rgba_color_matrix(rr = 1, rg = 0, rb = 0, ra = 0, gr = 0, gg = 1, gb = 0, ga = 0, br = 0, bg = 0, bb = 1, ba = 0, ar = 0, ag = 0, ab = 0, aa = 1, cr = 0, cg = 0, cb = 0, ca = 0)
	return list(rr, rg, rb, ra, gr, gg, gb, ga, br, bg, bb, ba, ar, ag, ab, aa, cr, cg, cb, ca)

/**
 * Assembles a color matrix, defaulting to identity.
 */
/proc/construct_rgb_color_matrix(rr = 1, rg = 0, rb = 0, gr = 0, gg = 1, gb = 0, br = 0, bg = 0, bb = 1, cr = 0, cg = 0, cb = 0)
	return list(rr, rg, rb, gr, gg, gb, br, bg, bb, cr, cg, cb)

/**
 * Constructs a colored greyscale matrix.
 * WARNING: Bad math up ahead. please redo this proc.
 */
/proc/rgba_auto_greyscale_matrix(rgba_string)
	return color_matrix_multiply(
		COLOR_MATRIX_GRAYSCALE,
		color_to_full_rgba_matrix(rgba_string)
	)
