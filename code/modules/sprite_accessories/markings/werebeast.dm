/datum/sprite_accessory/marking/werebeast
	abstract_type = /datum/sprite_accessory/marking/werebeast
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_WEREBEAST)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/werebeast/werewolf_nose
	name = "Werewolf nose"
	id = "marking_werebeast_nose"
	icon_state = "werewolf_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/werebeast/werewolf_face
	name = "Werewolf face"
	id = "marking_werebeast_face"
	icon_state = "werewolf"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/werebeast/werewolf_belly
	name = "Werewolf belly"
	id = "marking_werebeast_belly"
	icon_state = "werewolf"
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/werebeast/werewolf_socks
	name = "Werewolf socks"
	id = "marking_werebeast_socks"
	icon_state = "werewolf"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
