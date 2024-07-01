//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/teshari
	name = "Teshari"
	id = "teshari"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/teshari/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/teshari/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/teshari/damage.dmi'
	damage_overlay_use_masking = TRUE

	body_parts = BP_ALL_STANDARD
	gendered_parts = list(
		BP_HEAD,
		BP_GROIN,
		BP_TORSO,
	)

	variations = list(
		BODYSET_VARIATION_DEFORMED = /datum/bodyset_variation{
			name = "Deformed";
			icon = 'icons/mob/bodysets/organic/teshari/body-deformed.dmi';
		}
	)

	#warn is this still correct? icon('husk.dmi', "husk") is how it's meant to be done.
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk{
			icon = 'icons/mob/bodysets/organic/teshari/husk.dmi';
			icon_state = "husk";
		},
	)

	var/list/feather_parts = list(
		BP_L_HAND,
		BP_R_HAND,
		BP_L_FOOT,
		BP_R_FOOT,
	)

#warn snowflake rendering of feathers :/

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
