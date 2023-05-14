/datum/sprite_accessory/tail
	abstract_type = /datum/sprite_accessory/tail
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/tails.dmi'

	do_colouration = FALSE // If true, enable coloration using the tail color.
	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1

	/// If false, do not render species' tail.
	var/show_species_tail = FALSE
	/// If true, clothing with HIDETAIL hides it.
	var/clothing_can_hide = TRUE
	/// A description of the tail.
	var/desc = "You should not see this..."
	/// State when wagging/animated.
	var/ani_state
	/// Wagging state for extra overlay.
	var/extra_overlay_w
	/// Tertiary wagging.
	var/extra_overlay2_w
	/// Uses organ tag defines. Bodyparts in this list do not have their icons rendered, allowing for more spriter freedom when doing taur/digitigrade stuff.
	var/list/hide_body_parts = list()
	/// Icon file used for clip mask.
	var/icon/clip_mask_icon
	/// Icon state to generate clip mask. Clip mask is used to 'clip' off the lower part of clothing such as jumpsuits & full suits.
	var/clip_mask_state
	/// Instantiated clip mask of given icon and state
	var/icon/clip_mask

/datum/sprite_accessory/tail/New()
	. = ..()
	if(clip_mask_icon && clip_mask_state)
		clip_mask = icon(icon = clip_mask_icon, icon_state = clip_mask_state)

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
