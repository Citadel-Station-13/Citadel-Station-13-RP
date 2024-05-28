//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/akula
	id = "akula"
	name = "Akula"
	icon = 'icons/mob/bodysets/organic/akula/body.dmi'
	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
	)
	body_parts = BP_ALL_STANDARD
	overlays = list(
		BODYSET_OVERLAY_HUSKED = /datum/bodyset_overlay/husk/human,
	)

/datum/sprite_accessory/tail/bodyset/akula
	name = "akula tail"
	id = "tail-bodyset-akula"
	icon = 'icons/mob/bodysets/organic/akula/sprite_accessories.dmi'
	icon_state = "tail"
	do_colouration = FALSE
