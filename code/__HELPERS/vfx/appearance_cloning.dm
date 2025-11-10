/**
 * clones us as a high-resolution outline
 */
/atom/proc/vfx_clone_as_outline(alpha = 127, r = 1, g = 1, b = 1)
	var/image/rendering = image(src, dir = src.dir)
	rendering.filters = list(
		filter(type = "outline", size = 1, color = "#000000", flags = OUTLINE_SHARP)
	)
	rendering.vis_contents.len = 0	// y ea let's not copy those
	rendering.alpha = alpha
	rendering.color = construct_rgba_color_matrix(
		1, 0, 0, -1,
		0, 1, 0, -1,
		0, 0, 1, -1,
		0, 0, 0,  1,
		r, g, b,  0,
	)
	rendering.appearance_flags = RESET_TRANSFORM | RESET_COLOR | KEEP_TOGETHER
	rendering.plane = FLOAT_PLANE
	rendering.layer = FLOAT_LAYER
	return rendering

/**
 * clones us as a high-resolution greyscale
 */
/atom/proc/vfx_clone_as_greyscale(alpha = 127)
	var/static/list/static_greyscale_matrix = COLOR_MATRIX_GRAYSCALE
	var/image/rendering = image(src, dir = src.dir)
	rendering.color = static_greyscale_matrix
	rendering.vis_contents.len = 0	// y ea let's not copy those
	rendering.alpha = alpha
	rendering.appearance_flags = RESET_TRANSFORM | RESET_COLOR | KEEP_TOGETHER
	rendering.plane = FLOAT_PLANE
	rendering.layer = FLOAT_LAYER
	return rendering
