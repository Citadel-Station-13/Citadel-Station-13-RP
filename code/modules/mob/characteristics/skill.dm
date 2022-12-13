GLOBAL_LIST_INIT(characteristics_skills, _create_characteristics_skills())

/proc/_create_characteristics_skills()

/**
 * gets a skill datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_skill(datum/characteristic_skill/typepath_or_id)
	if(ispath(typepath_or_id))
		return GLOB.characteristics_skills[initial(typepath_or_id[id])]
	ASSERT(istext(typepath_or_id))
	return GLOB.characteristics_skills[typepath_or_id]

/**
 * skills - more enum-like numerics/whatnot than boolean-like talents
 * are held in skill holder
 */
/datum/characteristic_skill
	abstract_type = /datum/characteristic_skill
	/// unique id
	var/id


