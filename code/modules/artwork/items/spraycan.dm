//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/pen/crayon/spraycan
	name = "spraycan"
	icon = 'icons/modules/artwork/items/spraycans.dmi'
	icon_state = "spraycan"

	#warn ugh

	debris_path = /obj/effect/debris/cleanable/crayon/spraycan
	crayon_free_recolor = TRUE
	cappable = TRUE
	capped = TRUE

	/// cap overlay?
	var/cap_overlay = TRUE

/obj/item/pen/crayon/spraycan/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/pen/crayon/spraycan/switch_color(new_color)
	. = ..()
	update_icon()

/obj/item/pen/crayon/spraycan/update_icon(updates)
	cut_overlays()
	. = ..()
	if(cap_overlay)
		var/image/cap_image = image(icon, icon_state = capped? "[icon_state]_colors" : "[icon_state]_colors")
		cap_image.color = crayon_color
		add_overlay(cap_image)

/obj/item/pen/crayon/spraycan/update_icon_state()
	icon_state = capped? "[initial(icon_state)]_cap" : "[initial(icon_state)]"
	return ..()
