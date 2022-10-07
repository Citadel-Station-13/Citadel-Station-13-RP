/datum/species/proc/construct_character_species()
	var/datum/character_species/template = new
	template.name = display_name
	template.uid = uid
	template.category = category
	template.desc = blurb
	template.whitelisted = !!(spawn_flags & SPECIES_IS_WHITELISTED)
	template.real_species = uid

/**
 * since we're a server of snowflakes, we have this to embody character species
 *
 * they store real species UID so we can change species, and allow us to tweak the species on spawn.
 */
/datum/character_species
	//! Intrinsics
	/// abstract type (i'm addicted to abstract types)
	var/abstract_type = /datum/character_species
	/// uid (this must be unique with both species and minor species, don't be outrageous with it, don't be stupid)
	var/uid
	/// name (ALSO SETS THE PERSON'S CUSTOM RACE NAME!)
	var/name
	/// category
	var/category = "Minor Races"
	/// desc (lore fluff)
	var/desc
	/// are we an actual species as opposed to a demoted species? **DO NOT TOUCH THIS VAR.**
	var/is_real = FALSE
	/// is whitelisted (do someone need to be on alienwhitelist)
	var/whitelisted = FALSE
	/// real species type
	var/real_species_type = /datum/species/custom

	//! Defaults to set
	/// default ear path
	var/ear_style_default
	/// default tail path
	var/tail_style_default
	/// default wing path
	var/wing_style_default
	/// set species bodytype to this
	var/our_bodytype = BODYTYPE_DEFAULT

/datum/character_species/proc/tweak(datum/species/S)
	S.default_bodytype = our_bodytype

//! LORE PEOPLE, SHOVE YOUR SNOWFLAKE HERE

