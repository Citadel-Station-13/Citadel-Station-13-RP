//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/bodyset/synthetic/oss_vulpkanin
	id = "synth-oss-vulpkanin"
	name = "OSS - Vulpkanin"
	icon = 'icons/mob/bodysets/synthetic/oss_vulpkanin/body.dmi'
	body_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND,
		BP_L_LEG,
		BP_L_FOOT,
		BP_R_LEG,
		BP_R_FOOT,
	)
	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
	)
	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/oss_vulpkanin,
	)

/datum/sprite_accessory/tail/bodyset/oss_vulpkanin
	name = "OSS synthetic vulpkanin tail"
	icon = 'icons/mob/bodysets/synthetic/oss_vulpkanin/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = TRUE
	id = "tail-bodyset-oss_vulpkanin"
