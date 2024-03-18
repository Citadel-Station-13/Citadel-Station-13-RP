/**
 *
 * Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
 * facial hair, and possibly tattoos and stuff somewhere along the line. This file is
 * intended to be friendly for people with little to no actual coding experience.
 * The process of adding in new hairstyles has been made pain-free and easy to do.
 * Enjoy! - Doohl
 *
 *
 * Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
 * have to define any UI values for sprite accessories manually for hair and facial
 * hair. Just add in new hair types and the game will naturally adapt.
 *
 * !!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
 * to the point where you may completely corrupt a server's savefiles. Please refrain
 * from doing this unless you absolutely know what you are doing, and have defined a
 * conversion in savefile.dm
 */

// TODO: actual better way to do these
// TODO: actual better way to do "can we use this" checks because one whitelist list and a var is fucking horrible to maintain what the fuck

/datum/sprite_accessory
	abstract_type = /datum/sprite_accessory
	
	//* basics *//
	/// The preview name of the accessory.
	var/name
	/// id; must be unique globally amongst /datum/sprite_accessory's!
	var/id

	//* character setup *//
	/// Determines if the accessory will be skipped or included in random hair generations.
	/// if set, someone must be this gender to receive it
	var/random_generation_gender

	//* icon location & base state *//
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// sidedness; how many more states we need to inject for it to work
	var/icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_NONE
	#warn impl

	//* icon dimensions & alignment *//
	var/icon_dimension_x = 32
	var/icon_dimension_y = 32
	/// alignment; how we should align the sprite to the mob
	/// we will always be able to be re-aligned by the mob for obvious reasons, especially if their
	/// bodyparts are misaligned when the bodyparts in question are considered our anchors.
	var/icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_IGNORE
	#warn impl

	//* legacy below



	/// Restrict some styles to specific species.
	var/list/species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN)

	/// Whether or not the accessory can be affected by colouration.
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.

	/// use front/behind, citadel snowflake for now; only usable on wings/tails
	var/front_behind_system_legacy = FALSE

	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null
	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	var/center = FALSE
	var/dimension_x = 32
	var/dimension_y = 32
	// these two are moved up for now
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
	var/can_be_hidden = TRUE
