

/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	//Enhanced colours and hair for all
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE
	var/icon_add = 'icons/mob/human_face.dmi'
	var/hair_flags
	/// without this, we don't put the _s at the end of the state
	/// added to allow legacy hairs to work.
	var/append_s_at_end = FALSE

/datum/sprite_accessory/hair/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side)
	var/image/rendered = ..()
	
	if(do_colouration)
		

	return rendered

/datum/sprite_accessory/hair/legacy
	append_s_at_end = TRUE
