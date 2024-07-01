//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/vulpkanin
	name = "Vulpkanin"
	id = "vulpkanin"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/vulpkanin/body.dmi'
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

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/vulpkanin
	name = "vulpkanin tail"
	icon = 'icons/mob/bodysets/organic/vulpkanin/sprite_accessories.dmi'
	icon_state = "tail"
	variations = list(
		SPRITE_ACCESSORY_VARIATION_WAGGING = "tail-wag",
	)
	do_colouration = TRUE
	id = "tail-bodyset-vulpkanin"
