/area
	luminosity = TRUE
	var/dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

/area/Initialize()
	. = ..()

	if (dynamic_lighting)
		luminosity = FALSE

/area/proc/set_dynamic_lighting(new_dynamic_lighting = DYNAMIC_LIGHTING_ENABLED)
	if (new_dynamic_lighting == dynamic_lighting)
		return FALSE

	dynamic_lighting = new_dynamic_lighting

	if (new_dynamic_lighting)
		for (var/turf/T in src)
			if (T.dynamic_lighting)
				T.lighting_build_overlay()

	else
		for (var/turf/T in src)
			if (T.lighting_overlay)
				T.lighting_clear_overlay()

	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, dynamic_lighting))
			set_dynamic_lighting(var_value)
			return TRUE
	return ..()
