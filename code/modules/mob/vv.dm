/mob/vv_edit_var(var_name, var_value, raw_edit)
	if(raw_edit)
		return ..()
	switch(var_name)
		if(NAMEOF(src, shift_pixel_x))
			set_pixel_shift_x(var_value)
			return TRUE
		if(NAMEOF(src, shift_pixel_y))
			set_pixel_shift_y(var_value)
			return TRUE
	return ..()
