/obj/structure/bed/chair/modern_chair
	name = "modern chair"
	desc = "It's like sitting in an egg."
	icon = 'icons/obj/structures/furniture_vr.dmi'
	icon_state = "modern_chair"
	color = null
	base_icon_state = "modern_chair"
	applies_material_color = 0

/obj/structure/bed/chair/modern_chair/Initialize(mapload)
	. = ..()
	var/image/I = image(icon, "[base_icon_state]_over")
	I.layer = ABOVE_MOB_LAYER
	I.plane = MOB_PLANE
	add_overlay(I)

/obj/structure/bed/chair/bar_stool
	name = "bar stool"
	desc = "How vibrant!"
	icon_state = "bar"
	base_icon_state = "bar"
	color = null
	applies_material_color = 0

/obj/structure/bed/chair/backed_grey
	name = "grey chair"
	desc = "Also available in red."
	icon = 'icons/obj/structures/furniture_vr.dmi'
	icon_state = "onestar_chair_grey"
	color = null
	base_icon_state = "onestar_chair_grey"
	applies_material_color = 0

/obj/structure/bed/chair/backed_red
	name = "red chair"
	desc = "Also available in grey."
	icon = 'icons/obj/structures/furniture_vr.dmi'
	icon_state = "onestar_chair_red"
	color = null
	base_icon_state = "onestar_chair_red"
	applies_material_color = 0

// Baystation12 chairs with their larger update_icons proc
/obj/structure/bed/chair/bay/update_icon()
	// Strings.
	desc = initial(desc)
	if(reinf_material)
		name = "[reinf_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [reinf_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

	// Prep icon.
	icon_state = ""
	cut_overlays()

	// Base icon (base material color)
	var/cache_key = "[base_icon_state]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon_state)
		if(applies_material_color)
			I.color = material.color
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

	// Padding ('_padding') (padding material color)
	if(reinf_material)
		var/padding_cache_key = "[base_icon_state]-padding-[reinf_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon_state]_padding")
			I.color = reinf_material.color
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	// Over ('_over') (base material color)
	cache_key = "[base_icon_state]-[material.name]-over"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, "[base_icon_state]_over")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_color)
			I.color = material.color
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

	// Padding Over ('_padding_over') (padding material color)
	if(reinf_material)
		var/padding_cache_key = "[base_icon_state]-padding-[reinf_material.name]-over"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon_state]_padding_over")
			I.color = reinf_material.color
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])

	if(has_buckled_mobs())
		if(reinf_material)
			cache_key = "[base_icon_state]-armrest-[reinf_material.name]"
		// Armrest ('_armrest') (base material color)
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon_state]_armrest")
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			if(applies_material_color)
				I.color = material.color
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])
		if(reinf_material)
			cache_key = "[base_icon_state]-padding-armrest-[reinf_material.name]"
			// Padding Armrest ('_padding_armrest') (padding material color)
			if(isnull(stool_cache[cache_key]))
				var/image/I = image(icon, "[base_icon_state]_padding_armrest")
				I.plane = MOB_PLANE
				I.layer = ABOVE_MOB_LAYER
				I.color = reinf_material.color
				stool_cache[cache_key] = I
			add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/bay
	icon = 'icons/obj/structures/furniture_vr.dmi'

/obj/structure/bed/chair/bay/chair
	name = "mounted chair"
	desc = "Like a normal chair, but more stationary."
	icon_state = "bay_chair_preview"
	base_icon_state = "bay_chair"

/obj/structure/bed/chair/bay/chair/padded/red
	reinf_material = /datum/material/solid/cloth/red

/obj/structure/bed/chair/bay/chair/padded/brown
	reinf_material = /datum/material/solid/leather

/obj/structure/bed/chair/bay/chair/padded/teal
	reinf_material = /datum/material/solid/cloth/teal

/obj/structure/bed/chair/bay/chair/padded/black
	reinf_material = /datum/material/solid/cloth/black

/obj/structure/bed/chair/bay/chair/padded/green
	reinf_material = /datum/material/solid/cloth/green

/obj/structure/bed/chair/bay/chair/padded/purple
	reinf_material = /datum/material/solid/cloth/purple

/obj/structure/bed/chair/bay/chair/padded/blue
	reinf_material = /datum/material/solid/cloth/blue

/obj/structure/bed/chair/bay/chair/padded/beige
	reinf_material = /datum/material/solid/cloth/beige

/obj/structure/bed/chair/bay/chair/padded/lime
	reinf_material = /datum/material/solid/cloth/lime

/obj/structure/bed/chair/bay/chair/padded/yellow
	reinf_material = /datum/material/solid/cloth/yellow

/obj/structure/bed/chair/bay/comfy
	name = "comfy mounted chair"
	desc = "Like a normal chair, but more stationary, and with more padding."
	icon_state = "bay_comfychair_preview"
	base_icon_state = "bay_comfychair"

/obj/structure/bed/chair/bay/comfy/red
	reinf_material = /datum/material/solid/cloth/red

/obj/structure/bed/chair/bay/comfy/brown
	reinf_material = /datum/material/solid/leather

/obj/structure/bed/chair/bay/comfy/teal
	reinf_material = /datum/material/solid/cloth/teal

/obj/structure/bed/chair/bay/comfy/black
	reinf_material = /datum/material/solid/cloth/black

/obj/structure/bed/chair/bay/comfy/green
	reinf_material = /datum/material/solid/cloth/green

/obj/structure/bed/chair/bay/comfy/purple
	reinf_material = /datum/material/solid/cloth/purple

/obj/structure/bed/chair/bay/comfy/blue
	reinf_material = /datum/material/solid/cloth/blue

/obj/structure/bed/chair/bay/comfy/beige
	reinf_material = /datum/material/solid/cloth/beige

/obj/structure/bed/chair/bay/comfy/lime
	reinf_material = /datum/material/solid/cloth/lime

/obj/structure/bed/chair/bay/comfy/yellow
	reinf_material = /datum/material/solid/cloth/yellow

/obj/structure/bed/chair/bay/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair_preview"
	base_icon_state = "capchair"

/obj/structure/bed/chair/bay/comfy/captain/update_icon()
	..()
	var/image/I = image(icon, "[base_icon_state]_special")
	I.plane = MOB_PLANE
	I.layer = ABOVE_MOB_LAYER
	add_overlay(I)

/obj/structure/bed/chair/bay/comfy/captain
	material = MAT_STEEL
	reinf_material = /datum/material/solid/cloth/blue

/obj/structure/bed/chair/bay/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	base_icon_state = "shuttle_chair"
	icon_state = "shuttle_chair_preview"
	var/buckling_sound = 'sound/effects/metal_close.ogg'
	var/padding = "blue"

/obj/structure/bed/chair/bay/shuttle
	material = MAT_STEEL

/obj/structure/bed/chair/bay/shuttle/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	playsound(src,buckling_sound, 75, TRUE)
	if(has_buckled_mobs())
		base_icon_state = "shuttle_chair-b"
	else
		base_icon_state = "shuttle_chair"

/obj/structure/bed/chair/bay/shuttle/update_icon()
	..()
	if(!has_buckled_mobs())
		var/image/I = image(icon, "[base_icon_state]_special")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_color)
			I.color = material.color
		add_overlay(I)

/obj/structure/bed/chair/bay/chair/padded/red/smallnest
	name = "teshari nest"
	desc = "Smells like cleaning products."
	icon_state = "nest_chair"
	base_icon_state = "nest_chair"

/obj/structure/bed/chair/bay/chair/padded/red/bignest
	name = "large teshari nest"
	icon_state = "nest_chair_large"
	base_icon_state = "nest_chair_large"
