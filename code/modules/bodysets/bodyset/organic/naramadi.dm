//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/naramadi
	name = "Naramadi"
	id = "naramadi"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/naramadi/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
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
			icon = 'icons/mob/bodysets/organic/naramadi/body-deformed.dmi';
		}
	)

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/naramadi
	name = "naramadi tail"
	icon = 'icons/mob/bodysets/organic/naramadi/sprite_accessories.dmi'
	icon_state = "tail"
	id = "tail-bodyset-naramadi"
	do_colouration = TRUE
