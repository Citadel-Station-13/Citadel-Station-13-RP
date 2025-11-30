
/datum/map_level
	//* LEGACY BELOW *//

	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	//! legacy: what planet to make/use
	var/planet_path

	// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z
