/obj/structure/bed/chair/modern_chair
	name = "modern chair"
	desc = "It's like sitting in an egg."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "modern_chair"
	color = null
	base_icon = "modern_chair"
	applies_material_colour = 0

/obj/structure/bed/chair/modern_chair/Initialize(mapload)
	. = ..()
	var/image/I = image(icon, "[base_icon]_over")
	I.layer = ABOVE_MOB_LAYER
	I.plane = MOB_PLANE
	add_overlay(I)

/obj/structure/bed/chair/bar_stool
	name = "bar stool"
	desc = "How vibrant!"
	icon_state = "bar"
	base_icon = "bar"
	color = null
	applies_material_colour = 0

/obj/structure/bed/chair/backed_grey
	name = "grey chair"
	desc = "Also available in red."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "onestar_chair_grey"
	color = null
	base_icon = "onestar_chair_grey"
	applies_material_colour = 0

/obj/structure/bed/chair/backed_red
	name = "red chair"
	desc = "Also available in grey."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "onestar_chair_red"
	color = null
	base_icon = "onestar_chair_red"
	applies_material_colour = 0

// Baystation12 chairs with their larger update_icons proc
/obj/structure/bed/chair/bay/update_icon()
	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

	// Prep icon.
	icon_state = ""
	cut_overlays()

	// Base icon (base material color)
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		if(applies_material_colour)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

	// Padding ('_padding') (padding material color)
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	// Over ('_over') (base material color)
	cache_key = "[base_icon]-[material.name]-over"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, "[base_icon]_over")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_colour)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

	// Padding Over ('_padding_over') (padding material color)
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]-over"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding_over")
			I.color = padding_material.icon_colour
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	if(has_buckled_mobs())
		if(padding_material)
			cache_key = "[base_icon]-armrest-[padding_material.name]"
		// Armrest ('_armrest') (base material color)
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			if(applies_material_colour)
				I.color = material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])
		if(padding_material)
			cache_key = "[base_icon]-padding-armrest-[padding_material.name]"
			// Padding Armrest ('_padding_armrest') (padding material color)
			if(isnull(stool_cache[cache_key]))
				var/image/I = image(icon, "[base_icon]_padding_armrest")
				I.plane = MOB_PLANE
				I.layer = ABOVE_MOB_LAYER
				I.color = padding_material.icon_colour
				stool_cache[cache_key] = I
			add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/bay
	icon = 'icons/obj/furniture_vr.dmi'

/obj/structure/bed/chair/bay/chair
	name = "mounted chair"
	desc = "Like a normal chair, but more stationary."
	icon_state = "bay_chair_preview"
	base_icon = "bay_chair"

/obj/structure/bed/chair/bay/chair/padded/red/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "carpet")

/obj/structure/bed/chair/bay/chair/padded/brown/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "leather")

/obj/structure/bed/chair/bay/chair/padded/teal/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "teal")

/obj/structure/bed/chair/bay/chair/padded/black/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "black")

/obj/structure/bed/chair/bay/chair/padded/green/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "green")

/obj/structure/bed/chair/bay/chair/padded/purple/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "purple")

/obj/structure/bed/chair/bay/chair/padded/blue/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "bllue")

/obj/structure/bed/chair/bay/chair/padded/beige/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "beige")

/obj/structure/bed/chair/bay/chair/padded/lime/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "lime")

/obj/structure/bed/chair/bay/chair/padded/yellow/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "yellow")

/obj/structure/bed/chair/bay/comfy
	name = "comfy mounted chair"
	desc = "Like a normal chair, but more stationary, and with more padding."
	icon_state = "bay_comfychair_preview"
	base_icon = "bay_comfychair"

/obj/structure/bed/chair/bay/comfy/red/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "carpet")

/obj/structure/bed/chair/bay/comfy/brown/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "leather")

/obj/structure/bed/chair/bay/comfy/teal/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "teal")

/obj/structure/bed/chair/bay/comfy/black/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "black")

/obj/structure/bed/chair/bay/comfy/green/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "green")

/obj/structure/bed/chair/bay/comfy/purple/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "purple")

/obj/structure/bed/chair/bay/comfy/blue/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "bllue")

/obj/structure/bed/chair/bay/comfy/beige/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "beige")

/obj/structure/bed/chair/bay/comfy/lime/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "lime")

/obj/structure/bed/chair/bay/comfy/yellow/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, new_material, "yellow")

/obj/structure/bed/chair/bay/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair_preview"
	base_icon = "capchair"

/obj/structure/bed/chair/bay/comfy/captain/update_icon()
	..()
	var/image/I = image(icon, "[base_icon]_special")
	I.plane = MOB_PLANE
	I.layer = ABOVE_MOB_LAYER
	add_overlay(I)

/obj/structure/bed/chair/bay/comfy/captain/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, MAT_STEEL, "blue")

/obj/structure/bed/chair/bay/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	base_icon = "shuttle_chair"
	icon_state = "shuttle_chair_preview"
	var/buckling_sound = 'sound/effects/metal_close.ogg'
	var/padding = "blue"

/obj/structure/bed/chair/bay/shuttle/Initialize(mapload, new_material, new_padding_material)
	return ..(mapload, MAT_STEEL, padding)

/obj/structure/bed/chair/bay/shuttle/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	playsound(src,buckling_sound,75,1)
	if(has_buckled_mobs())
		base_icon = "shuttle_chair-b"
	else
		base_icon = "shuttle_chair"

/obj/structure/bed/chair/bay/shuttle/update_icon()
	..()
	if(!has_buckled_mobs())
		var/image/I = image(icon, "[base_icon]_special")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_colour)
			I.color = material.icon_colour
		add_overlay(I)

/obj/structure/bed/chair/bay/chair/padded/red/smallnest
	name = "teshari nest"
	desc = "Smells like cleaning products."
	icon_state = "nest_chair"
	base_icon = "nest_chair"

/obj/structure/bed/chair/bay/chair/padded/red/bignest
	name = "large teshari nest"
	icon_state = "nest_chair_large"
	base_icon = "nest_chair_large"
