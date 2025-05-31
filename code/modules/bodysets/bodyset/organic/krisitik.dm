//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/bodyset/organic/krisitik
	name = "Krisitik"
	id = "krisitik"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/krisitik/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'

	gendered_parts = list(
		BP_HEAD,
		BP_GROIN,
		BP_TORSO,
	)

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/prototype/sprite_accessory/tail/bodyset/krisitik
	name = "krisitik tail"
	id = "tail-bodyset-krisitik"
	icon = 'icons/mob/bodysets/organic/krisitik/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = FALSE
