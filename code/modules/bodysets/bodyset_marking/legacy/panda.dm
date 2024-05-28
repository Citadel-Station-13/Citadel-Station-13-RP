/datum/bodyset_marking/legacy/panda
	abstract_type = /datum/bodyset_marking/legacy/panda
	icon = "icons/mob/sprite_accessories/markings/panda.dmi"

/datum/bodyset_marking/legacy/panda/panda_eye_marks
	name = "Panda Eye Markings"
	id = "marking_panda_eyes"
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN)

/datum/bodyset_marking/legacy/panda/panda_full
	name = "Panda Limbs"
	id = "marking_panda_full"
	icon_state = "panda"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	color_uses_blend_add = TRUE
