/**
 * =-----------------------------=
 * == Shadekin Hair Definitions ==
 * =-----------------------------=
 */

/datum/sprite_accessory/hair/shadekin/short
	name = "Shadekin Short Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_short"
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin/poofy
	name = "Shadekin Poofy Hair"
	icon_state = "shadekin_poofy"

/datum/sprite_accessory/hair/shadekin/long
	name = "Shadekin Long Hair"
	icon_state = "shadekin_long"

/datum/sprite_accessory/hair/shadekin/rivyr
	name = "Rivyr Hair"
	icon_state = "shadekin_rivyr"



/**
 * =--------------------------------=
 * == Shadekin Marking Definitions ==
 * =--------------------------------=
 */

/datum/sprite_accessory/marking/shadekin
	name = "Shadekin Snoot"
	icon_state = "shadekin-snoot"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
