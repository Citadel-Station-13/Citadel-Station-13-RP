/**
 * clones us as a high-resolution outline
 */
/atom/proc/vfx_clone_as_outline(color)
	var/mutable_appearance/MA = new
	MA.appearance = src
	MA.filters = list(
		filter(type = "outline", size = 1, color = color, flags = OUTLINE_SHARP)
	)
	MA.vis_contents.len = 0	// y ea let's not copy those
	return MA
