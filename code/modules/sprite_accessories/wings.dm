/datum/sprite_accessory/wing
	abstract_type = /datum/sprite_accessory/wing
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/wings.dmi'
	icon_dimension_x = 64
	icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_BOTTOM
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	legacy_use_additive_color_matrix = TRUE // Only appliciable if do_coloration = 1

/datum/sprite_accessory/wing/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation, flattened)
	var/list/image/layers = ..()

	if(flattened)
		return layers

	for(var/image/rendered as anything in layers)
		if(do_colouration && ishuman(for_whom))
			var/mob/living/carbon/human/casted_human = for_whom
			if(casted_human.grad_wingstyle && casted_human.grad_wingstyle != "None")
				var/image/gradient_icon = image(hair_gradient_icon(id, rendered, casted_human.grad_wingstyle, icon_dimension_x))
				gradient_icon.color = rgb(
					casted_human.r_gradwing,
					casted_human.g_gradwing,
					casted_human.b_gradwing,
				)
				gradient_icon.blend_mode = BLEND_OVERLAY
				rendered.overlays += gradient_icon

	return layers

/datum/sprite_accessory/wing/flat_cache_keys(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation, flattened)
	. = ..()
	if(!ishuman(for_whom))
		return
	var/mob/living/carbon/human/casted_human = for_whom
	. += casted_human.grad_wingstyle
	. += rgb(
		casted_human.r_gradwing,
		casted_human.g_gradwing,
		casted_human.b_gradwing,
	)

// todo: sort ears by something that makes sense
// todo: tgui choice menu should be modular
// todo: and include way to do categories
//! right now the categories are way too sparse, we'll combine them later.

//? AND YES, I AM SHITPOSTING WITH THE CATEGORY .DM NAMES
//? Deal with it, I'll deal with this in the emissives PR
//? Seriously I'm not categorizing our 500 kinds of wings.

//? If anyone wants to sort it, obviously, PLEASE, be my guest, but I just don't have the energy to do the stuff I did
//? in /ears. It just isn't working out for me, sorry.

//? Potential nomenclatures:
//? - by animal (real or fakefurrysona) type
//? - "Animal", "Species", "Robotic", "Misc"
//? etc

//? PLEASE HELP WITH THIS.
