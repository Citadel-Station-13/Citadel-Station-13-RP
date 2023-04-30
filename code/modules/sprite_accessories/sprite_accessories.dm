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

	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// A custom preview state for whatever reason.
	var/preview_state

	/// The preview name of the accessory.
	var/name

	/// Determines if the accessory will be skipped or included in random hair generations.
	var/gender = NEUTER

	/// Restrict some styles to specific species.
	var/list/species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN)

	/// Whether or not the accessory can be affected by colouration.
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.

	/// use front/behind, citadel snowflake for now; only usable on wings/tails
	var/front_behind_system = FALSE

	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null
	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	var/center = FALSE
	var/dimension_x = 32
	var/dimension_y = 32
	/// id
	var/id
	// these two are moved up for now
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
