//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/vasilissan
	name = "Vasilissan"
	id = "vasilissan"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/vasilissan/body.dmi'
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
		BP_R_ARM,
		BP_L_ARM,
	)

	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/vasilissan
	name = "vasilissan tail"
	icon = 'icons/mob/bodysets/organic/vasilissan/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = TRUE
	id = "tail-bodyset-vasilissan"
