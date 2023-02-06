/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags)
	appearance.color = GLOB.emissive_color
	return appearance

//? below are lazy; recommend using above from /tg/ for anything high-performance-ish

/proc/vfx_clone_as_emissive(mutable_appearance/appearancelike, alpha_override, layer_override)
	var/mutable_appearance/cloned = new
	cloned.appearance = appearancelike
	cloned.color = GLOB.emissive_color
	cloned.plane = EMISSIVE_PLANE
	cloned.appearance_flags |= KEEP_APART
	if(layer_override)
		cloned.layer = layer_override
	if(alpha_override)
		cloned.alpha = alpha_override
	return cloned

/proc/vfx_clone_as_emissive_blocker(mutable_appearance/appearancelike, alpha_override, layer_override)
	var/mutable_appearance/cloned = new
	cloned.appearance = appearancelike
	cloned.color = GLOB.em_block_color
	cloned.plane = EMISSIVE_PLANE
	cloned.appearance_flags |= KEEP_APART
	if(layer_override)
		cloned.layer = layer_override
	if(alpha_override)
		cloned.alpha = alpha_override
	return cloned

/atom/proc/cheap_become_emissive(alpha_override, layer_override)
	. = vfx_clone_as_emissive(src, alpha_override, layer_override || MANGLE_PLANE_AND_LAYER(plane, layer))
	add_overlay(.)

/atom/proc/cheap_become_emissive_blocker(alpha_override, layer_override)
	. = vfx_clone_as_emissive_blocker(src, alpha_override, layer_override || MANGLE_PLANE_AND_LAYER(plane, layer))
	add_overlay(.)
