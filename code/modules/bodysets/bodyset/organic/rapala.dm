//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/organic/rapala
	icon = 'icons/mob/bodysets/organic/rapala/body.dmi'
	body_parts = BP_ALL_STANDARD
	gendered_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
	)
	variations = list(
		BODYSET_VARIATION_DEFORMED = /datum/bodyset_variation{
			state_append = "deform";
		},
	)

/datum/sprite_accessory/tail/bodyset/rapala
	name = "rapala tail"
	icon = 'icons/mob/bodysets/organic/rapala/sprite_accessories.dmi'
	icon_state = "tail"
	id = "tail-bodyset-rapala"
	do_colouration = TRUE
