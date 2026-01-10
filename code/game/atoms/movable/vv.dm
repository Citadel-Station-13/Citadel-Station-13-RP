/atom/movable/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, step_x) = TRUE, NAMEOF_STATIC(src, step_y) = TRUE, NAMEOF_STATIC(src, step_size) = TRUE, NAMEOF_STATIC(src, bounds) = TRUE)
	var/static/list/careful_edits = list(NAMEOF_STATIC(src, bound_x) = TRUE, NAMEOF_STATIC(src, bound_y) = TRUE, NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)
	var/static/list/not_falsey_edits = list(NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)

	if(banned_edits[var_name])
		return FALSE //PLEASE no.
	if(careful_edits[var_name] && (var_value % world.icon_size) != 0)
		return FALSE
	if(not_falsey_edits[var_name] && !var_value)
		return FALSE

	switch(var_name)
		if(NAMEOF(src, x))
			var/turf/current_turf = locate(var_value, y, z)
			if(current_turf)
				admin_teleport(current_turf)
				return TRUE
			return FALSE
		if(NAMEOF(src, y))
			var/turf/T = locate(x, var_value, z)
			if(T)
				admin_teleport(T)
				return TRUE
			return FALSE
		if(NAMEOF(src, z))
			var/turf/T = locate(x, y, var_value)
			if(T)
				admin_teleport(T)
				return TRUE
			return FALSE
		if(NAMEOF(src, loc))
			if(isatom(var_value) || isnull(var_value))
				admin_teleport(var_value)
				return TRUE
			return FALSE
		if(NAMEOF(src, anchored))
			set_anchored(var_value)
			. = TRUE
		if(NAMEOF(src, glide_size))
			set_glide_size(var_value)
			. = TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	. = ..()
	if(!.)
		return
	if(!raw_edit)
		switch(var_name)
			if(NAMEOF(src, rad_insulation))
				var/turf/simulated/ST = loc
				if(!istype(ST))
					return
				ST.update_rad_insulation()

/atom/movable/vv_get_dropdown()
	. = ..()
	. += "<option value='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(src)]'>Follow</option>"
	. += "<option value='?_src_=holder;[HrefToken()];admingetmovable=[REF(src)]'>Get</option>"
