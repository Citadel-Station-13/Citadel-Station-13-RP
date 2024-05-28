//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/shadekin
	name = "Shadekin"
	id = "shadekin"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/shadekin/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE

	body_parts = BP_ALL_STANDARD

	#warn husk icon is same icon with icon_state of "husk"; is this still correct?
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk{
			icon_state = "husk";
		},
	)

/datum/sprite_accessory/tail/bodyset/shadekin
	name = "shadekin tail"
	icon = 'icons/mob/bodysets/organic/shadekin/sprite_accessories.dmi'
	icon_state = "tail"
	id = "tail-bodyset-shadekin"
	do_colouration = TRUE
