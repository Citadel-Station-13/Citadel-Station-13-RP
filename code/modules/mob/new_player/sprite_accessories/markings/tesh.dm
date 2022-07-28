//Tesh stuff.
/datum/sprite_accessory/marking/tesh
	icon = "icons/mob/sprite_accessories/markings/tesh_stuff.dmi"

/datum/sprite_accessory/marking/tesh/teshi_heterochromia
	name = "Teshari Heterochromia"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE
/datum/sprite_accessory/marking/tesh/tesh_feathers
	name = "Teshari Feathers"
	icon_state = "tesh-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)
/datum/sprite_accessory/marking/tesh/teshi_fluff
	name = "Teshari underfluff"
	icon_state = "teshi_fluff"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/tesh/teshi_small_feathers
	name = "Teshari small wingfeathers"
	icon_state = "teshi_sf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)
/datum/sprite_accessory/marking/tesh/teshari_large_eyes
	name = "Teshari large eyes"
	icon_state = "teshlarge_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_coat
	name = "Teshari coat"
	icon_state = "tesh_coat"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_pattern_male
	name = "Teshari male pattern"
	icon_state = "tesh-pattern-male"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_pattern_female
	name = "Teshari female pattern"
	icon_state = "tesh-pattern-fem"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE
