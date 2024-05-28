/datum/bodyset_marking/sergal
	abstract_type = /datum/bodyset_marking/sergal
	icon = "icons/mob/sprite_accessories/markings/sergal.dmi"

/datum/bodyset_marking/sergal/sergal_full
	name = "Sergal Markings"
	id = "marking_sergal_full_m"
	icon_state = "sergal_full"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_SERGAL)
	apply_restrictions = TRUE

/datum/bodyset_marking/sergal/sergal_full_female
	name = "Sergal Markings (Female)"
	id = "marking_sergal_full_f"
	icon_state = "sergal_full_female"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_SERGAL)
	apply_restrictions = TRUE

/datum/bodyset_marking/sergal/sergaleyes
	name = "Sergal Eyes"
	id = "marking_sergal_eyes"
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)
