/////////////
//Vox stuff//
/////////////
/datum/bodyset_marking/vox
	abstract_type = /datum/bodyset_marking/vox
	icon = "icons/mob/sprite_accessories/markings/vox_stuff.dmi"
	bodyset_group_restricted = /datum/bodyset/organic/vox::group_id

/datum/bodyset_marking/vox/vox_coloration
	name = "Vox Two Tone"
	id = "marking_vox_2tone"
	icon_state = "vox_dual"
	body_parts = list(BP_HEAD,BP_L_HAND,BP_R_HAND,BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/bodyset_marking/vox/vox_alt
	name = "Vox Alternate"
	id = "marking_vox_alt"
	icon_state = "bay_vox"
	body_parts = list (BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/bodyset_marking/vox/vox_alt_eyes
	name = "Alternate Vox Eyes"
	id = "marking_vox_alt_eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/bodyset_marking/vox/voxscales
	name = "Vox Scales"
	id = "marking_vox_scales"
	icon_state = "Voxscales"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_HEAD)

/datum/bodyset_marking/vox/voxclaws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	id = "marking_vox_claws"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/bodyset_marking/vox/voxbeak
	name = "Vox Beak"
	id = "marking_vox_beak"
	icon_state = "Voxscales"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)
