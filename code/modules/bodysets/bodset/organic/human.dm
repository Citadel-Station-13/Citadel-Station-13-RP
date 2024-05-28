//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/human
	name = "Human"
	id = "human"
	base_id = "human"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/human/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE

	gendered_parts = list(
		BP_HEAD,
		BP_GROIN,
		BP_TORSO,
	)

	variations = list(
		BODYSET_VARIATION_DEFORMED = /datum/bodyset_variation{
			name = "Deformed";
			icon = 'icons/mob/bodysets/organic/human/body-deformed.dmi';
		}
	)

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/**
 * this is such a widely used one it's just a hardcoded type
 */
/datum/bodyset_overlay/husk/human
	id = BODYSET_OVERLAY_HUSKED

#warn impl

/datum/bodyset/organic/human/gravworlder
	id = "human-gravworlder"
	name = "Human (Gravworlder)"
	icon = 'icons/mob/bodysets/organic/human/body-gravworlder.dmi'

/datum/bodyset/organic/human/tritonian
	id = "human-tritonian"
	name = "Human (Tritonian)"
	icon = 'icons/mob/bodysets/organic/human/body-tritonian.dmi'

/datum/bodyset/organic/human/spacer
	id = "human-spacer"
	name = "Human (Spacer)"
	icon = 'icons/mob/bodysets/organic/human/body-spacer.dmi'

/datum/bodyset/organic/human/vatborn
	id = "human-vatborn"
	name = "Human (Vatborn)"
	icon = 'icons/mob/bodysets/organic/human/body-vatborn.dmi'
