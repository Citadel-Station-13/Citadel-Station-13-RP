//? file contains mob helpers and whatnot

//! direct lookup
/**
 * checks if we have a characteristic talent
 *
 * @params
 * - typepath_or_id - typepath or id; prefer typepath during compile time
 *
 * @return TRUE/FALSE
 */
/mob/proc/has_characteristic_talent(datum/characteristic_talent/typepath_or_id)
	if(!characteristics_active())
		return FALSE
	return mind?.characteristics?.has_talent(typepath_or_id)

/**
 * checks the value of one of our characteristic stats
 *
 * @params
 * - typepath_or_id - typepath or id; prefer typepath during compile time
 *
 * @return raw value
 */
/mob/proc/get_characteristic_stat(datum/characteristic_stat/typepath_or_id)
	if(!characteristics_active())
		typepath_or_id = resolve_characteristics_stat(typepath_or_id)
		return typepath_or_id.baseline_value
	return mind?.characteristics?.get_stat(typepath_or_id)

/**
 * gets the skill value enum of one of our characteristic skills
 *
 * @params
 * - typepath_or_id - typepath or id; prefer typepath during compile time
 *
 * @return skill level
 */
/mob/proc/get_characteristic_skill(datum/characteristic_skill/typepath_or_id)
	if(!characteristics_active())
		typepath_or_id = resolve_characteristics_stat(typepath_or_id)
		return typepath_or_id.baseline_value
	return mind?.characteristics?.get_skill(typepath_or_id)

//! checks

//? no stat check ; stats are raw values

//? no talent check ; talents are boolean for checks

//? skill checks

/**
 * scales a number with requested skill scaling
 *
 * @params
 * * typepath_or_id - typepath or id of skill
 * * level - what level is wanted
 * * constant - constant for scaling
 * * method - skill scaling enum, see __DEFINES/mobs/characteristics.dm
 */
/mob/proc/characteristic_skill_scaling(datum/characteristic_skill/typepath_or_id, level, constant, method)
	var/diff = level - get_characteristic_skill(typepath_or_id)
	switch(method)
		if(SKILL_SCALING_EXPONENTIAL_HARD)
			return constant * (2 ** diff)
		if(SKILL_SCALING_EXPONENTIAL_SOFT)
			return constant * (1.5 ** diff)
		if(SKILL_SCALING_LINEAR)
			return diff * constant

/**
 * checks if we have a skill at a required level.
 *
 * @params
 * * typepath_or_id - typepath or id of skill
 * * level - what level is needed
 */
/mob/proc/characteristic_skill_check(datum/characteristic_skill/typepath_or_id, level)
	return level <= get_characteristic_skill(typepath_or_id)

/**
 * gets skill difference
 *
 * @params
 * * typepath_or_id - typepath or id of skill
 * * level - what level is needed
 */
/mob/proc/characteristic_skill_difference(datum/characteristic_skill/typepath_or_id, level)
	return level - get_characteristic_skill(typepath_or_id)

/**
 * get or create characteristics holder
 */
/mob/proc/characteristics_holder()
	if(!mind)
		mind_initialize()
	return mind.characteristics_holder()
