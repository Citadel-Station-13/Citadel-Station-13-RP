//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/apidean
	id = "apidean"
	name = "Apidean"
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)
	body_parts = BP_ALL_STANDARD
	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
		BP_L_ARM,
		BP_R_ARM,
	)

	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE

/datum/sprite_accessory/tail/bodyset/apidean
	name = "apidean tail"
	id = "tail-bodyset-apidean"
	icon = 'icons/mob/bodysets/organic/apidean/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = FALSE
