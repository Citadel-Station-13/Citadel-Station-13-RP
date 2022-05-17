/**
 * clones us as a high-resolution outline
 */
/atom/proc/vfx_clone_as_outline(color)
	var/mutable_appearance/MA = new
	MA.appearance = src
	MA.filters = list(

	)
