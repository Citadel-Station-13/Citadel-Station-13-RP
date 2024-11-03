//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/bodyset/organic/nevrean
	name = "Nevrean"
	id = "nevrean"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/nevrean/body.dmi'
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

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/nevrean
	name = "nevrean tail"
	icon = 'icons/mob/bodysets/organic/nevrean/sprite_accessories.dmi'
	icon_state = "tail"
	id = "tail-bodyset-nevrean"
	do_colouration = TRUE
