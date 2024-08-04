/datum/sprite_accessory/tail
	abstract_type = /datum/sprite_accessory/tail
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/tails.dmi'
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	legacy_use_additive_color_matrix = TRUE // Only appliciable if do_coloration = 1
	var/show_species_tail = 0 // If false, do not render species' tail.
	var/clothing_can_hide = 1 // If true, clothing with HIDETAIL hides it
	var/desc = "You should not see this..."
	//! legacy
	var/ani_state // State when wagging/animated
	//! legacy
	var/extra_overlay_w // Wagging state for extra overlay
	//! legacy
	var/extra_overlay2_w // Tertiary wagging.
	var/list/hide_body_parts = list() //Uses organ tag defines. Bodyparts in this list do not have their icons rendered, allowing for more spriter freedom when doing taur/digitigrade stuff.
	var/icon/clip_mask_icon = null //Icon file used for clip mask.
	var/clip_mask_state = null //Icon state to generate clip mask. Clip mask is used to 'clip' off the lower part of clothing such as jumpsuits & full suits.
	var/icon/clip_mask = null //Instantiated clip mask of given icon and state

/datum/sprite_accessory/tail/New()
	. = ..()
	if(clip_mask_icon && clip_mask_state)
		clip_mask = icon(icon = clip_mask_icon, icon_state = clip_mask_state)

/datum/sprite_accessory/tail/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation, flattened)
	// awful? yes. :skull:
	// please don't ever copy this pattern anywhere else.
	if(with_variation == SPRITE_ACCESSORY_VARIATION_WAGGING && ani_state)
		var/old1 = icon_state
		var/old2 = extra_overlay
		var/old3 = extra_overlay2
		icon_state = ani_state
		extra_overlay = extra_overlay_w
		extra_overlay2 = extra_overlay2_w
		. = ..()
		icon_state = old1
		extra_overlay = old2
		extra_overlay2 = old3
	else
		return ..()

//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	abstract_type = /datum/sprite_accessory/tail/special
	icon = 'icons/effects/species_tails_vr.dmi'

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

/datum/sprite_accessory/tail/invisible
	name = "Invisible (hide species-sprite tail)"
	id = "tail_abstract"
	icon = null
	icon_state = null
