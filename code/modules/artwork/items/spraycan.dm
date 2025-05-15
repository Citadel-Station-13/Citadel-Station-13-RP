//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/pen/crayon/spraycan
	name = "spraycan"
	icon = 'icons/modules/artwork/items/spraycans.dmi'
	icon_state = "spraycan"

	materials_base = list(
		MAT_STEEL = 500,
		MAT_GLASS = 100,
	)

	debris_path = /obj/effect/debris/cleanable/crayon/spraycan
	crayon_name = "spraycan"
	crayon_sound = /datum/soundbyte/spray/air_1
	crayon_free_recolor = TRUE
	crayon_edible = FALSE
	cappable = TRUE
	capped = TRUE
	debris_time = 1 SECONDS

	/// do we render the cap?
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
