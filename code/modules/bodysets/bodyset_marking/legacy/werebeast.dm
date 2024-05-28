/datum/bodyset_marking/legacy/werebeast
	abstract_type = /datum/bodyset_marking/legacy/werebeast
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	color_uses_blend_add = FALSE
	bodyset_group_restricted = list(
		"werebeast"0,
	)

/datum/bodyset_marking/legacy/werebeast/werewolf_nose
	name = "Werewolf nose"
	id = "marking_werebeast_nose"
	icon_state = "werewolf_nose"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/legacy/werebeast/werewolf_face
	name = "Werewolf face"
	id = "marking_werebeast_face"
	icon_state = "werewolf"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/legacy/werebeast/werewolf_belly
	name = "Werewolf belly"
	id = "marking_werebeast_belly"
	icon_state = "werewolf"
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/bodyset_marking/legacy/werebeast/werewolf_socks
	name = "Werewolf socks"
	id = "marking_werebeast_socks"
	icon_state = "werewolf"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
