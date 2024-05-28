/datum/bodyset_marking/tesh
	abstract_type = /datum/bodyset_marking/tesh
	icon = 'icons/mob/sprite_accessories/markings/tesh_stuff.dmi'
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE
	bodyset_group_restricted = /datum/bodyset/organic/teshari::group_id

/datum/bodyset_marking/tesh/teshi_heterochromia
	name = "Teshari Heterochromia"
	id = "marking_teshari_heterochromia"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/tesh/tesh_feathers
	name = "Teshari Feathers"
	id = "marking_teshari_feathers"
	icon_state = "teshi_feathers"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_FOOT, BP_R_FOOT, BP_L_HAND, BP_R_HAND)

/datum/bodyset_marking/tesh/teshi_fluff
	name = "Teshari underfluff"
	id = "marking_teshari_fluff"
	icon_state = "teshi_fluff"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO, BP_HEAD)

/datum/bodyset_marking/tesh/teshi_small_feathers
	name = "Teshari small wingfeathers"
	id = "marking_teshari_wingfeathers_small"
	icon_state = "teshi_sf"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_FOOT, BP_R_FOOT, BP_L_HAND, BP_R_HAND, BP_TORSO)

/datum/bodyset_marking/tesh/teshari_coat
	name = "Teshari coat"
	id = "marking_teshari_coat"
	icon_state = "teshi_coat"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_TORSO, BP_HEAD)

/datum/bodyset_marking/tesh/teshari_pattern_male
	name = "Teshari male pattern"
	id = "marking_teshari_pattern_m"
	icon_state = "teshi_pattern_male"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_TORSO, BP_GROIN, BP_HEAD)

/datum/bodyset_marking/tesh/teshari_pattern_female
	name = "Teshari female pattern"
	id = "marking_teshari_pattern_f"
	icon_state = "teshi_pattern_fem"
	color_uses_blend_add = FALSE
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_TORSO, BP_GROIN, BP_HEAD)
