/datum/sprite_accessory/wing
	abstract_type = /datum/sprite_accessory/wing
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/wings.dmi'
	dimension_x = 64
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	legacy_use_additive_color_matrix = TRUE // Only appliciable if do_coloration = 1
	var/spr_state // State when spreading wings w/o anim


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
