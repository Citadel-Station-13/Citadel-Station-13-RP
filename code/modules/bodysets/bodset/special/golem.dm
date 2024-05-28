//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/special/golem
	id = "golem"
	base_id = "golem"

	body_parts = list(
		BP_HEAD,
		BP_L_ARM,
		BP_L_HAND,
		BP_L_LEG,
		BP_R_ARM,
		BP_R_HAND,
		BP_R_LEG,
		BP_TORSO,
	)
	gendered_parts = list(
		BP_TORSO,
	)
	layered_parts = list(
		BP_L_HAND = list(
			"front" = HUMAN_BODYLAYER_FRONT,
			"behind" = HUMAN_BODYLAYER_BEHIND,
		),
		BP_R_HAND = list(
			"front" = HUMAN_BODYLAYER_FRONT,
			"behind" = HUMAN_BODYLAYER_BEHIND,
		),
		BP_L_LEG = list(
			"front" = HUMAN_BODYLAYER_FRONT,
			"behind" = HUMAN_BODYLAYER_BEHIND,
		),
		BP_R_LEG = list(
			"front" = HUMAN_BODYLAYER_FRONT,
			"behind" = HUMAN_BODYLAYER_BEHIND,
		),
	)

	greyscale = TRUE

	icon = 'icons/mob/bodysets/special/golem/body.dmi'
	mask_icon = 'icons/mob/bodysets/organic/human/mask.dmi'

	variations = list(
		/datum/bodyset_variation{
			name = "Clockwork";
			icon = 'icons/mob/bodysets/special/golem/body-clockwork.dmi';
		},
	)

	w

