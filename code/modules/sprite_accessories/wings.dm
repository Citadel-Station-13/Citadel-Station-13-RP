/datum/sprite_accessory/wing
	abstract_type = /datum/sprite_accessory/wing
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/wings.dmi'
	icon_dimension_x = 64
	icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_BOTTOM
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	legacy_use_additive_color_matrix = TRUE // Only appliciable if do_coloration = 1

/datum/sprite_accessory/wing/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation)
	var/image/rendered = ..()

	if(do_colouration && ishuman(for_whom))
		var/mob/living/carbon/human/casted_human = for_whom
		if(casted_human.grad_wingstyle)
			var/image/gradient = image('icons/mob/hair_gradients.dmi', GLOB.hair_gradients[casted_human.grad_style])
			gradient.color = rgb(casted_human.r_grad, casted_human.g_grad, casted_human.b_grad)
			gradient.blend_mode = BLEND_INSET_OVERLAY
			rendered.overlays += gradient

	if(has_add_state)
		// if we have that don't do legacy behavior
	else if(icon_add_legacy)

	return rendered


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
