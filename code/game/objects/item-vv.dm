/obj/item/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	. = ..()
	if(!.)
		return
	switch(var_name)
		if(NAMEOF(src, siemens_coefficient))
			inv_inside?.invalidate_simple_covered_siemens_coefficient_cache()
