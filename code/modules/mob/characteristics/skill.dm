GLOBAL_LIST_INIT(characteristics_skills, _create_characteristics_skills())

/proc/_create_characteristics_skills()

/**
 * gets a skill datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_skill(datum/characteristic_skill/typepath_or_id)
	RETURN_TYPE(/datum/characteristic_skill)
	return GLOB.characteristics_skills[ispath(typepath_or_id)? initial(typepath_or_id.id) : typepath_or_id]

/**
 * skills - more enum-like numerics/whatnot than boolean-like talents
 * are held in skill holder
 *
 * skills are untrained when unset, and baseline when characteristics are disabled
 */
/datum/characteristic_skill
	abstract_type = /datum/characteristic_skill
	//! basics
	/// unique id
	var/id
	/// name
	var/name = "ERROR"
	/// desc
	var/desc = "An unknown skill. Someone needs to set this!"
	/// category - just strings for now, don't need defines yet
	var/category = "Unsorted"

	//! values
	/// what to return if characteristics are disabled
	var/baseline_value = CHARACTER_SKILL_ENUM_MIN
	/// max skill value
	var/max_value = CHARACTER_SKILL_ENUM_MAX

	//! costs
	var/cost_basic = 2
	var/cost_novice = 4
	var/cost_trained = 6
	var/cost_experienced = 8
	var/cost_professional = 10

	//! descriptions
	var/desc_untrained = "ERR: NO UNTRAINED DESC"
	var/desc_basic = "ERR: NO BASIC DESC"
	var/desc_novice = "ERR: NO NOVICE DESC"
	var/desc_trained = "ERR: NO TRAINED DESC"
	var/desc_experienced = "ERR: NO EXPERIENCED DESC"
	var/desc_professional = "ERR: NO PROFESSIONAL DESC"


	#warn specializations?

	#warn scaling

/datum/characteristic_skill/proc/level_cost(level)

/datum/characteristic_skill/proc/level_description(level)
	switch(level)
		if(CHARACTER_SKILL_UNTRAINED)
			return desc_untrained
		if(CHARACTER_SKILL_BASIC)
			return desc_basic
		if(CHARACTER_SKILL_NOVICE)
			return desc_novice
		if(CHARACTER_SKILL_TRAINED)
			return desc_trained
		if(CHARACTER_SKILL_EXPERIENCED)
			return desc_experienced
		if(CHARACTER_SKILL_PROFESSIONAL)
			return desc_professional
