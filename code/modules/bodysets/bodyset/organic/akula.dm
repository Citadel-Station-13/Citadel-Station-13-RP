//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/akula
	id = "akula"
	name = "Akula"
	icon = 'icons/mob/bodysets/organic/akula/body.dmi'
	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
	)
	body_parts = BP_ALL_STANDARD
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE

/datum/sprite_accessory/tail/bodyset/akula
	name = "akula tail"
	id = "tail-bodyset-akula"
	icon = 'icons/mob/bodysets/organic/akula/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = FALSE
