/datum/species/proc/construct_character_species()
	var/datum/character_species/template = new
	// copy basics
	template.name = display_name || name
	template.uid = uid
	if(id != uid)
		template.is_subspecies = TRUE
		template.superspecies_id = id
	template.category = category
	template.desc = blurb
	template.species_spawn_flags = species_spawn_flags
	template.real_species_type = type
	template.genders = genders.Copy()
	template.min_age = min_age
	template.max_age = max_age
	template.our_bodytype = default_bodytype
	// copy mechanics
	template.species_flags = species_flags
	// copy appearance
	template.species_appearance_flags = species_appearance_flags
	// copy lore/culture
	template.default_origin = default_origin
	template.default_citizenship = default_citizenship
	template.default_faction = default_faction
	template.default_religion = default_religion
	template.species_fluff_flags = species_fluff_flags
	// copy language
	template.default_language = default_language
	template.name_language = name_language
	template.max_additional_languages = max_additional_languages
	template.whitelist_languages = islist(whitelist_languages)? whitelist_languages.Copy() : whitelist_languages
	template.intrinsic_languages = islist(intrinsic_languages)? intrinsic_languages.Copy() : intrinsic_languages
	template.galactic_language = galactic_language
	return template

/**
 * since we're a server of snowflakes, we have this to embody character species
 *
 * they store real species UID so we can change species, and allow us to tweak the species on spawn.
 *
 * /datum/character_species is a singleton type stored on SScharacters.
 */
/datum/character_species
	/// Abstract type (i'm addicted to abstract types) @silicons
	abstract_type = /datum/character_species

	//! Intrinsics
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
	/// spawn flags
	var/species_spawn_flags = SPECIES_SPAWN_CHARACTER
	/// real species type
	var/real_species_type = /datum/species/custom
	/// species fluff flags - read species_flags.dm in __DEFINES
	var/species_fluff_flags = NONE
	/// species appearance flags - read species_flags.dm in __DEFINES
	var/species_appearance_flags = NONE
	/// species main flags - read species_flags.dm in __DEFINES
	var/species_flags = NONE
	/// allowed genders
	var/list/genders = list(MALE, FEMALE)
	/// minimum age
	var/min_age = 18
	/// maximum age
	var/max_age = 90

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

	//! Languages - IDs only, as typepaths are too expensive to resolve
	/// has galactic common? you better not disable this unless you know what you're doing
	var/galactic_language = TRUE
	/// additional languages we always have, regardless of background - list or ID
	var/list/intrinsic_languages
	/// name language is from for randomgen - id - null to use vanilla ss13 randomgen
	var/name_language
	/// languages we are always allowed to learn, even if restricted (obviously overridden by intrinsic languages) - list or ID
	var/list/whitelist_languages
	/// additional anguages we can learn (ontop of any we get from us, and from culture datums)
	var/max_additional_languages = 3
	/// default language when talking; this should probably be part of intrinsics!
	var/default_language = LANGUAGE_ID_COMMON

/datum/character_species/proc/tweak(datum/species/S)
	// we need this
	S.default_bodytype = our_bodytype
	// while we technically don't *need* this, we want this incase someone starts reading from these fields mid game
	// for non customization purposes later.
	S.galactic_language = galactic_language
	S.intrinsic_languages = get_intrinsic_language_ids()	// forces it to be a list
	S.name_language = name_language
	S.whitelist_languages = get_whitelisted_language_ids()	// forces it to a list
	S.max_additional_languages = max_additional_languages
	S.default_language = default_language

/datum/character_species/proc/get_default_origin_id()
	return SScharacters.resolve_origin(default_origin).id

/datum/character_species/proc/get_default_citizenship_id()
	return SScharacters.resolve_citizenship(default_citizenship).id

/datum/character_species/proc/get_default_faction_id()
	return SScharacters.resolve_faction(default_faction).id

/datum/character_species/proc/get_default_religion_id()
	return SScharacters.resolve_religion(default_religion).id

/datum/character_species/proc/get_intrinsic_language_ids()
	RETURN_TYPE(/list)
	. = intrinsic_languages? (islist(intrinsic_languages)? intrinsic_languages.Copy() : list(intrinsic_languages)) : list()
	if(galactic_language)
		. |= LANGUAGE_ID_COMMON

/datum/character_species/proc/get_name_language_id()
	return name_language

/datum/character_species/proc/get_max_additional_languages()
	return max_additional_languages

/datum/character_species/proc/get_whitelisted_language_ids()
	RETURN_TYPE(/list)
	return whitelist_languages? (islist(whitelist_languages)? whitelist_languages.Copy() : list(whitelist_languages)) : list()

/datum/character_species/proc/get_default_language_id()
	return default_language

/datum/character_species/proc/real_species_uid()
	var/datum/species/S = SScharacters.resolve_species_path(real_species_type)
	return S.uid

//! LORE PEOPLE, SHOVE YOUR SNOWFLAKE HERE
