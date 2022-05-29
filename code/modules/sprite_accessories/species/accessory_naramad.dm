/**
 * =----------------------------=
 * == Naramad Hair Definitions ==
 * =----------------------------=
 */

/datum/sprite_accessory/hair/naramad
	name = "Naramad Plain"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_plain"
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/hair/naramad/medicore
	name = "Naramad Medicore"
	icon_state = "serg_medicore"

/datum/sprite_accessory/hair/naramad/tapered
	name = "Naramad Tapered"
	icon_state = "serg_tapered"

/datum/sprite_accessory/hair/naramad/fairytail
	name = "Naramad Fairytail"
	icon_state = "serg_fairytail"



/**
 * =-------------------------------=
 * == Naramad Marking Definitions ==
 * =-------------------------------=
 */

/datum/sprite_accessory/marking/naramad
	icon = 'icons/mob/human_races/markings_vr.dmi'
	name = "Sergal Markings"
	icon_state = "sergal_full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/marking/naramad/sergal_full_female
	name = "Sergal Markings (Female)"
	icon_state = "sergal_full_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/naramad/eyes
	name = "Sergal Eyes"
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)
