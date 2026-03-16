//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/sprite_accessory/tail/bodyset/teshari
	name = "teshari tail"
	icon = 'icons/mob/bodysets/organic/teshari/sprite_accessories.dmi'
	icon_state = "tail"
	id = "tail-bodyset-teshari"
	do_colouration = TRUE

/datum/sprite_accessory/tail/bodyset/teshari/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation, flattened)
	var/list/image/layers = ..()
	for(var/image/built as anything in layers)
		var/image/hair = image(icon, "tail-hair")
		if(ishuman(for_whom))
			var/mob/living/carbon/human/casted = for_whom
			hair.color = rgb(casted.r_hair, casted.g_hair, casted.b_hair)
		built.overlays += hair
	return layers
