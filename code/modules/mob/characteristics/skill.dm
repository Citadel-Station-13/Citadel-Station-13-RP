GLOBAL_LIST_INIT(characteristics_skills, _create_characteristics_skills())

/proc/_create_characteristics_skills()
	. = list()
	for(var/datum/characteristic_skill/skill in subtypesof(/datum/characteristic_skill))
		if(is_abstract(skill))
			continue
		. = new skill
		if(isnull(skill.id))
			stack_trace("null id on [skill.type]")
			continue
		if(.[skill.id])
			stack_trace("collision on id [skill.id] between types [skill.type] and [.[skill.id]:type]")
			continue
		.[skill.id] = skill

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
	//? basics
	/// unique id
	var/id
	/// name
	var/name = "ERROR"
	/// desc
	var/desc = "An unknown skill. Someone needs to set this!"
	/// category - just strings for now, don't need defines yet
	var/category = "Unsorted"

	//? values
	/// what to return if characteristics are disabled
	var/baseline_value = CHARACTER_SKILL_ENUM_MIN
	/// max skill value
	var/max_value = CHARACTER_SKILL_ENUM_MAX

	//? costs - these are additive!
	var/cost_novice = 0
	var/cost_trained = 0
	var/cost_experienced = 0
	var/cost_professional = 0

	var/tmp/total_cost_novice
	var/tmp/total_cost_trained
	var/tmp/total_cost_experienced
	var/tmp/total_cost_professional

	//? descriptions
	var/desc_untrained = "ERR: NO UNTRAINED DESC"
	var/desc_novice = "ERR: NO NOVICE DESC"
	var/desc_trained = "ERR: NO TRAINED DESC"
	var/desc_experienced = "ERR: NO EXPERIENCED DESC"
	var/desc_professional = "ERR: NO PROFESSIONAL DESC"

/datum/characteristic_skill/New()
	compute_caches()

/datum/characteristic_skill/proc/total_cost(level)
	switch(level)
		if(CHARACTER_SKILL_UNTRAINED)
			return 0
		if(CHARACTER_SKILL_NOVICE)
			. = total_cost_novice
		if(CHARACTER_SKILL_TRAINED)
			. = total_cost_trained
		if(CHARACTER_SKILL_EXPERIENCED)
			. = total_cost_experienced
		if(CHARACTER_SKILL_PROFESSIONAL)
			. = total_cost_professional

/datum/characteristic_skill/proc/compute_caches()
	var/total = 0
	total_cost_novice = round(total, 1)
	total_cost_trained = round(total, 1)
	total_cost_experienced = round(total, 1)
	total_cost_professional = round(total, 1)

/datum/characteristic_skill/proc/level_description(level)
	switch(level)
		if(CHARACTER_SKILL_UNTRAINED)
			return desc_untrained
		if(CHARACTER_SKILL_NOVICE)
			return desc_novice
		if(CHARACTER_SKILL_TRAINED)
			return desc_trained
		if(CHARACTER_SKILL_EXPERIENCED)
			return desc_experienced
		if(CHARACTER_SKILL_PROFESSIONAL)
			return desc_professional
