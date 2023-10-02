/datum/sprite_accessory/marking/diona
	abstract_type = /datum/sprite_accessory/marking/diona
	icon = "icons/mob/sprite_accessories/markings/diona.dmi"
	species_allowed = list(SPECIES_DIONA, SPECIES_ALRAUNE)

/datum/sprite_accessory/marking/diona/diona_leaves
	name = "Diona Leaves"
	id = "marking_diona_leaves"
	icon_state = "diona_leaves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_GROIN,BP_TORSO,BP_HEAD)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/diona/diona_thorns
	name = "Diona Thorns"
	id = "marking_diona_thorns"
	icon_state = "diona_thorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/diona/diona_flowers
	name = "Diona Flowers"
	id = "marking_diona_flowers"
	icon_state = "diona_flowers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/diona/diona_moss
	name = "Diona moss"
	id = "marking_diona_moss"
	icon_state = "diona_moss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)
	apply_restrictions = TRUE
