/////////////
//Vox stuff//
/////////////
/datum/sprite_accessory/marking/vox
	abstract_type = /datum/sprite_accessory/marking/vox
	icon = "icons/mob/sprite_accessories/markings/vox_stuff.dmi"

/datum/sprite_accessory/marking/vox/vox_coloration
	name = "Vox Two Tone"
	id = "marking_vox_2tone"
	icon_state = "vox_dual"
	body_parts = list(BP_HEAD,BP_L_HAND,BP_R_HAND,BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/vox_alt
	name = "Vox Alternate"
	id = "marking_vox_alt"
	icon_state = "bay_vox"
	body_parts = list (BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/vox_alt_eyes
	name = "Alternate Vox Eyes"
	id = "marking_vox_alt_eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/voxscales
	name = "Vox Scales"
	id = "marking_vox_scales"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_HEAD)

/datum/sprite_accessory/marking/vox/voxclaws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	id = "marking_vox_claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vox/voxbeak
	name = "Vox Beak"
	id = "marking_vox_beak"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
