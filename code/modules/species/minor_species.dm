/datum/species/proc/construct_character_species()
	var/datum/character_species/template = new
	template.name = display_name
	template.uid = uid
	if(id != uid)
		template.is_subspecies = TRUE
		template.superspecies_id = id
	template.category = category
	template.desc = blurb
	template.whitelisted = !!(species_spawn_flags & SPECIES_SPAWN_WHITELISTED)
	template.real_species_type = type
	template.default_origin = default_origin
	template.default_citizenship = default_citizenship
	template.default_faction = default_faction
	template.default_religion = default_religion

/**
 * since we're a server of snowflakes, we have this to embody character species
 *
 * they store real species UID so we can change species, and allow us to tweak the species on spawn.
 *
 * /datum/character_species is a singleton type stored on SScharacters.
 */
/datum/character_species
	//! Intrinsics
	/// abstract type (i'm addicted to abstract types)
	var/abstract_type = /datum/character_species
	/// uid (this must be unique with both species and minor species, don't be outrageous with it, don't be stupid)
	var/uid
	/// master species id
	var/superspecies_id
	/// is subspecies of master species
	var/is_subspecies = FALSE
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

	//! Defaults to set for visuals
	/// default ear path
	var/ear_style_default
	/// default tail path
	var/tail_style_default
	/// default wing path
	var/wing_style_default
	/// set species bodytype to this
	var/our_bodytype = BODYTYPE_DEFAULT

	//! Defaults to set for background - typepaths allowed
	/// default origin
	var/default_origin = /datum/lore/character_background/origin/custom
	/// default citizenship
	var/default_citizenship = /datum/lore/character_background/citizenship/custom
	/// default faction
	var/default_faction = /datum/lore/character_background/faction/nanotrasen
	/// default religion
	var/default_religion = /datum/lore/character_background/religion/custom

	//! Languages
	/// has galactic common? you better not disable this unless you know what you're doing
	var/language_galactic_common = FALSE
	/// additional languages we always have, regardless of background
	var/list/language_species = list()
	/// name language is from for randomgen - id
	var/name_language

	#warn impl in general

	#warn impl defaults on species datums and consider #defining or allowing typepaths

/datum/character_species/proc/tweak(datum/species/S)
	S.default_bodytype = our_bodytype

/datum/character_species/proc/get_default_origin_id()
	return SScharacters.resolve_origin(default_origin).id

/datum/character_species/proc/get_default_citizenship_id()
	return SScharacters.resolve_citizenship(default_citizenship).id

/datum/character_species/proc/get_default_faction_id()
	return SScharacters.resolve_faction(default_faction).id

/datum/character_species/proc/get_default_religion_id()
	return SScharacters.resolve_religion(default_religion).id

/datum/character_species/proc/get_default_language_ids()
	#warn impl

//! LORE PEOPLE, SHOVE YOUR SNOWFLAKE HERE

