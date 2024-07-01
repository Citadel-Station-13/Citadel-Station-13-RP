//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/diona
	id = "diona"
	name = "Diona"
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk{
			icon_state = "husk";
		}
	)
	variations = list(
		BODYSET_VARIATION_DEFORMED = /datum/bodyset_variation{
			icon = 'icons/mob/bodysets/organic/diona/deformed.dmi';
		}
	)
	icon = 'icons/mob/bodysets/organic/diona/body.dmi'
	body_parts = BP_ALL_STANDARD

	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE
