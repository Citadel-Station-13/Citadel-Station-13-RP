//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/bodyset/organic/tajaran
	name = "Tajaran"
	id = "tajaran"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/tajaran/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'

	body_parts = BP_ALL_STANDARD
	gendered_parts = list(
		BP_HEAD,
		BP_GROIN,
		BP_TORSO,
	)

	variations = list(
		BODYSET_VARIATION_DEFORMED = /datum/bodyset_variation{
			name = "Deformed";
			icon = 'icons/mob/bodysets/organic/tajaran/body-deformed.dmi';
		}
	)

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/tajaran
	name = "tajaran tail"
	icon = 'icons/mob/bodysets/organic/tajaran/sprite_accessories.dmi'
	icon_state = "tail"
	variations = list(
		SPRITE_ACCESSORY_VARIATION_WAGGING = "tail-wag",
	)
	id = "tail-bodyset-tajaran"
	do_colouration = TRUE
