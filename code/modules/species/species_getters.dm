//! IDs
/**
 * get species id; subspecies returns main species
 */
/datum/species/proc/get_species_id()
	return id || uid

/**
 * get exact species id; subspecies does NOT return main species
 */
/datum/species/proc/get_exact_species_id()
	return uid

//? Bodytypes
/**
 * get effective bodytype
 */
/datum/species/proc/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	return default_bodytype

//? Languages
/datum/species/proc/get_default_language_id()
	var/datum/language/L = default_language
	return ispath(L)? initial(L.id) : L

/datum/species/proc/get_intrinsic_language_ids()
	RETURN_TYPE(/list)
	if(!intrinsic_languages)
		return galactic_language? list(LANGUAGE_ID_COMMON) : list()
	. = list()
	if(islist(intrinsic_languages))
		for(var/datum/language/id_or_path as anything in intrinsic_languages)
			. += ispath(id_or_path)? initial(id_or_path.id) : id_or_path
	else
		var/datum/language/L = intrinsic_languages
		. += ispath(L)? initial(L.id) : L
	if(galactic_language)
		. |= LANGUAGE_ID_COMMON

/datum/species/proc/get_name_language_id()
	var/datum/language/L = name_language
	return ispath(name_language)? initial(L.id) : name_language

/datum/species/proc/get_max_additional_languages()
	return max_additional_languages

/datum/species/proc/get_whitelisted_language_ids()
	RETURN_TYPE(/list)
	if(!whitelist_languages)
		return list()
	. = list()
	if(islist(whitelist_languages))
		for(var/datum/language/id_or_path as anything in whitelist_languages)
			. += ispath(id_or_path)? initial(id_or_path.id) : id_or_path
	else
		var/datum/language/L = whitelist_languages
		. += ispath(L)? initial(L.id) : L

//? misc

/datum/species/proc/get_valid_shapeshifter_forms(mob/living/carbon/human/H)
	return list()

/datum/species/proc/get_additional_examine_text(mob/living/carbon/human/H)
	return

/datum/species/proc/get_tail(mob/living/carbon/human/H)
	return tail

/datum/species/proc/get_tail_animation(mob/living/carbon/human/H)
	return tail_animation

/datum/species/proc/get_tail_hair(mob/living/carbon/human/H)
	return tail_hair

/datum/species/proc/get_blood_mask(mob/living/carbon/human/H)
	return blood_mask

/datum/species/proc/get_damage_overlays(mob/living/carbon/human/H)
	return damage_overlays

/datum/species/proc/get_damage_mask(mob/living/carbon/human/H)
	return damage_mask

/datum/species/proc/get_icobase(mob/living/carbon/human/H, get_deform)
	return (get_deform ? deform : icobase)

/datum/species/proc/get_husk_icon(mob/living/carbon/human/H)
	return husk_icon

// used for limb caching
// todo: rework limbs and get rid of this, numerical static keys are dumb as fuck,
// limbs should use their own types!
/datum/species/proc/get_race_key(mob/living/carbon/human/H)
	return real_race_key(H)

/datum/species/proc/real_race_key(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_bodytype_legacy(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_worn_legacy_bodytype(mob/living/carbon/human/H)
	return override_worn_legacy_bodytype || name

/datum/species/proc/get_knockout_message(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/datum/species/proc/get_death_message(mob/living/carbon/human/H)
	if(config_legacy.show_human_death_message)
		return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)
	else
		return "no message"

/datum/species/proc/get_ssd(mob/living/carbon/human/H)
	if(H)
		if(H.looksSynthetic())
			return "flashing a 'system offline' light"
		else if(!H.ai_holder)
			return show_ssd
		else
			return

/datum/species/proc/get_blood_colour(mob/living/carbon/human/H)
	if(H)
		var/datum/robolimb/company = H.isSynthetic()
		if(company)
			return company.blood_color
		else
			return blood_color

/datum/species/proc/get_blood_name(mob/living/carbon/human/H)
	if(H)
		var/datum/robolimb/company = H.isSynthetic()
		if(company)
			return company.blood_name
		else
			return blood_name

/datum/species/proc/get_virus_immune(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? 1 : virus_immune)

/datum/species/proc/get_flesh_colour(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/datum/species/proc/get_environment_discomfort(mob/living/carbon/human/H, msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.is_holding(clothes))
			continue
		if((clothes.body_cover_flags & UPPER_TORSO) && (clothes.body_cover_flags & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				to_chat(H, SPAN_DANGER("[pick(cold_discomfort_strings)]"))
		if("heat")
			if(covered)
				to_chat(H, SPAN_DANGER("[pick(heat_discomfort_strings)]"))

/datum/species/proc/get_random_name(gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/datum/language/species_language = SScharacters.resolve_language_id(get_name_language_id())
	if(!species_language)
		species_language = SScharacters.resolve_language_id(default_language)
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/get_vision_flags(mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/get_wing_hair(mob/living/carbon/human/H) //I have no idea what this is even used for other than teshari, but putting it in just in case.
	return wing_hair //Since the tail has it.

/datum/species/proc/get_wing(mob/living/carbon/human/H)
	return wing

/datum/species/proc/get_wing_animation(mob/living/carbon/human/H)
	return wing_animation

//! ## Names
/datum/species/proc/get_true_name(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_display_name(mob/living/carbon/human/H)
	return display_name || name

/datum/species/proc/get_examine_name(mob/living/carbon/human/H)
	return examine_name || name
