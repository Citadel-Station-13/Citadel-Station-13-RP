

/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	//Enhanced colours and hair for all
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE
	var/icon_add = 'icons/mob/human_face.dmi'
	var/hair_flags

/datum/sprite_accessory/hair/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side)
	var/image/rendered = ..()
