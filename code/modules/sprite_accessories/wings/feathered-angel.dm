/datum/sprite_accessory/wing/angel
	name = "angel wings"
	id = "angelwings"
	icon = 'icons/mob/sprite_accessory/wings/feathered-angel.dmi'
	icon_state = "angel"
	do_colouration = TRUE
	legacy_use_additive_color_matrix = FALSE
	icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND

//64x48 Wings
/datum/sprite_accessory/wing/seraph
	name = "seraphim wings (colorable)"
	id = "wing_seraph"
	icon = 'icons/mob/sprite_accessory/wings/feathered-angel-64x48.dmi'
	icon_state = "seraph"
	variations = list(
		SPRITE_ACCESSORY_VARIATION_SPREAD = "seraph-spr"
	)
	do_colouration = 1
	legacy_use_additive_color_matrix = FALSE

/datum/sprite_accessory/wing/seraph_eyes
	name = "seraphim wings (colorable, eyes)"
	id = "wing_serapheye"
	icon = 'icons/mob/sprite_accessory/wings/feathered-angel-64x48.dmi'
	icon_state = "seraph_eye"
	variations = list(
		SPRITE_ACCESSORY_VARIATION_SPREAD = "seraph_eye-spr"
	)
	//do_colouration = 1	//Maybe some day we'll allow multi-coloration and I'll make this colorable again too so the eyes can get colors.
	//legacy_use_additive_color_matrix = FALSE
