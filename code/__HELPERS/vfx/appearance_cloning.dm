/**
 * clones us as a high-resolution outline
 */
/atom/proc/vfx_clone_as_outline(color = "#ffffff", alpha = 127)
	var/mutable_appearance/MA = new
	MA.appearance = src
	MA.filters = list(
		filter(type = "outline", size = 1, color = color, flags = OUTLINE_SHARP)
	)
	MA.vis_contents.len = 0	// y ea let's not copy those
	MA.alpha = alpha
	MA.color = color
	MA.appearance_flags = RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
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
	MA.appearance_flags = RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	return MA
