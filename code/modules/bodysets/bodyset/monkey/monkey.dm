//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset/monkey
	group_id = "monkey"
	base_id = "monkey"

	name = "Monkey"
	id = "monkey"
	icon = 'icons/mob/bodysets/monkey/monkey/body.dmi'

	damage_overlay_icon = 'icons/mob/bodysets/monkey/damage.dmi'
	damage_overlay_brute_stages = 3
	damage_overlay_burn_stages = 3
	damage_overlay_use_masking = TRUE

	mask_icon = 'icons/mob/bodysets/monkey/mask.dmi'

	body_parts = BP_ALL_STANDARD
	gendered_parts = list()

/datum/bodyset/monkey/farwa
	name = "Monkey (Farwa)"
	id = "farwa"
	icon = 'icons/mob/bodysets/monkey/farwa/body.dmi'

/datum/bodyset/monkey/naera
	name = "Monkey (Naera)"
	id = "naera"
	icon = 'icons/mob/bodysets/monkey/naera/body.dmi'

/datum/bodyset/monkey/sergaling
	name = "Monkey (Sergaling)"
	id = "sergaling"
	icon = 'icons/mob/bodysets/monkey/sergaling/body.dmi'

/datum/bodyset/monkey/sparra
	name = "Monkey (Sparra)"
	id = "sparra"
	icon = 'icons/mob/bodysets/monkey/sparra/body.dmi'

/datum/bodyset/monkey/sobaka
	name = "Monkey (Sobaka)"
	id = "sobaka"
	icon = 'icons/mob/bodysets/monkey/sobaka/body.dmi'

/datum/bodyset/monkey/stok
	name = "Monkey (Stok)"
	id = "stok"
	icon = 'icons/mob/bodysets/monkey/stok/body.dmi'

/datum/bodyset/monkey/wolpin
	name = "Monkey (Wolpin)"
	id = "wolpin"
	icon = 'icons/mob/bodysets/monkey/wolpin/body.dmi'

/datum/sprite_accessory/tail/bodyset/monkey
	abstract_type = /datum/sprite_accessory/tail/bodyset/monkey

/datum/sprite_accessory/tail/bodyset/monkey/chimp
	name = "chimpanzee tail"
	id = "tail-bodyset-chimp"
	icon = 'icons/mob/bodysets/organic/monkey/sprite_accessories.dmi'
	icon_state = "tail-chimp"
	do_colouration = FALSE

/datum/sprite_accessory/tail/bodyset/monkey/stok
	name = "stok tail"
	id = "tail-bodyset-stok"
	icon = 'icons/mob/bodysets/organic/monkey/sprite_accessories.dmi'
	icon_state = "tail-stok"
	do_colouration = FALSE

/datum/sprite_accessory/tail/bodyset/monkey/farwa
	name = "farwa tail"
	id = "tail-bodyset-farwa"
	icon = 'icons/mob/bodysets/organic/monkey/sprite_accessories.dmi'
	icon_state = "tail-farwa"
	do_colouration = FALSE
