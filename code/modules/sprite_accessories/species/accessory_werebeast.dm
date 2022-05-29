/**
 * =---------------------------------=
 * == Werebeast Marking Definitions ==
 * =---------------------------------=
 */

/datum/sprite_accessory/marking/werewolf
	name = "Werewolf face"
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/werewolf/nose
	name = "Werewolf nose"
	icon_state = "werewolf_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/werewolf/belly
	name = "Werewolf belly"
	icon_state = "werewolf"
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/werewolf/socks
	name = "Werewolf socks"
	icon_state = "werewolf"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
