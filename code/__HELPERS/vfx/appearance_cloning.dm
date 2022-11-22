/**
 * clones us as a high-resolution outline
 */
/atom/proc/vfx_clone_as_outline(alpha = 127, r = 1, g = 1, b = 1)
	var/mutable_appearance/MA = new
	MA.appearance = src
	MA.filters = list(
		filter(type = "outline", size = 1, color = "#000000", flags = OUTLINE_SHARP)
	)
	MA.vis_contents.len = 0	// y ea let's not copy those
	MA.alpha = alpha
	MA.color = rgba_construct_color_matrix(
		1, 0, 0, -1,
		0, 1, 0, -1,
		0, 0, 1, -1,
		0, 0, 0,  1,
		r, g, b,  0,
	)
	MA.appearance_flags = RESET_TRANSFORM | RESET_COLOR
	MA.plane = FLOAT_PLANE
	MA.layer = FLOAT_LAYER
	return MA

/**
 * clones us as a high-resolution greyscale
 */
/atom/proc/vfx_clone_as_greyscale(alpha = 127)
	var/static/list/static_greyscale_matrix = color_matrix_greyscale()
	var/mutable_appearance/MA = new
	MA.appearance = src
	MA.color = static_greyscale_matrix
	MA.vis_contents.len = 0	// y ea let's not copy those
	MA.alpha = alpha
	MA.appearance_flags = RESET_TRANSFORM | RESET_COLOR
	MA.plane = FLOAT_PLANE
	MA.layer = FLOAT_LAYER
	return MA
