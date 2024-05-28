//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/unathi
	name = "Unathi"
	id = "unathi"
	base_id = "unathi"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/unathi/body.dmi'
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
			icon = 'icons/mob/bodysets/organic/unathi/body-deformed.dmi';
		}
	)

	#warn blah
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk{
			icon = 'icons/mob/bodysets/organic/unathi/husk.dmi';
			icon_state = "husk";
		},
	)

/datum/bodyset/organic/unathi/digitigrade
	name = "Unathi (Digitigrade)"
	id = "unathi-digitigrade"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/unathi/body-digitigrade.dmi'
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
			icon = 'icons/mob/bodysets/organic/unathi/body-digitigrade-deformed.dmi';
		}
	)

	#warn blah
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk{
			icon = 'icons/mob/bodysets/organic/unathi/husk-digitigrade.dmi';
			icon_state = "husk";
		},
	)

/datum/sprite_accessory/tail/bodyset/unathi
	name = "unathi tail"
	icon = 'icons/mob/bodysets/organic/unathi/sprite_accessories.dmi'
	icon_state = "tail"
	variations = list(
		SPRITE_ACCESSORY_VARIATION_WAGGING = "tail-wag",
	)
	id = "tail-bodyset-unathi"
	do_colouration = TRUE
