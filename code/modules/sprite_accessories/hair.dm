

/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	//Enhanced colours and hair for all
	legacy_use_additive_color_matrix = FALSE
	apply_restrictions = FALSE

	/// ignored if new has_add_state is specified
	var/icon_add_legacy = 'icons/mob/human_face.dmi'
	var/hair_flags
	/// without this, we don't put the _s at the end of the state
	/// added to allow legacy hairs to work.
	var/append_s_at_end = FALSE

/datum/sprite_accessory/hair/New()
	..()
	if(append_s_at_end)
		icon_state = "[icon_state]_s"

/datum/sprite_accessory/hair/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation)
	var/list/image/layers = ..()

	for(var/image/rendered as anything in layers)
		if(do_colouration && ishuman(for_whom))
			var/mob/living/carbon/human/casted_human = for_whom
			if(casted_human.grad_style)
				var/image/gradient = image('icons/mob/hair_gradients.dmi', GLOB.hair_gradients[casted_human.grad_style])
				gradient.color = list(
					0, 0, 0, 0,
					0, 0, 0, 0,
					0, 0, 0, 0,
					0, 0, 0, 1,
					casted_human.r_grad / 255, casted_human.g_grad / 255, casted_human.b_grad / 255, 0,
				)
				gradient.blend_mode = BLEND_INSET_OVERLAY
				rendered.overlays += gradient

		if(has_add_state)
			// if we have that don't do legacy behavior
		else if(icon_add_legacy)
			var/image/adding = image(icon_add_legacy, icon_state = icon_state)
			adding.blend_mode = BLEND_ADD
			rendered.overlays += adding

	return layers

/datum/sprite_accessory/hair/legacy
	abstract_type = /datum/sprite_accessory/hair/legacy
	append_s_at_end = TRUE
