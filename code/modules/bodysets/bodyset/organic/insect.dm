//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/insect
	name = "Insect"
	id = "insect"
	group_id = "human"

	icon = 'icons/mob/bodysets/organic/insect/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_icon = 'icons/mob/bodysets/organic/human/damage.dmi'
	damage_overlay_use_masking = TRUE

	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
	)
	body_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_L_LEG,
		BP_R_LEG,
		BP_R_ARM,
		BP_L_ARM,
	)
