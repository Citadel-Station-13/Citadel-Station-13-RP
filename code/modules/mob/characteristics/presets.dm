GLOBAL_LIST_EMPTY(characteristics_presets)

/**
 * gets a skill-holder preset
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_preset(datum/characteristic_preset/typepath_or_instance)
	RETURN_TYPE(/datum/characteristic_preset)
	if(istype(typepath_or_instance))
		return typepath_or_instance
	. = GLOB.characteristics_presets[typepath_or_instance]
	if(!.)
		return (GLOB.characteristics_presets[typepath_or_instance] = (new typepath_or_instance))

/**
 * holds presets for skills/whatont
 */
/datum/characteristic_preset
	/// name for debugging ; optional
	var/name

	/// skill tpyepaths or ids associated to values
	var/list/skills
	/// stat typepaths or ids associated to values
	var/list/stats
	/// talent typepaths or ids associated to lists (or null) of what to pass in for arglist in talent add.
	var/list/talents

/datum/characteristic_preset/New(list/skills = list(), list/stats = list(), list/talents = list())
	src.skills = skills.Copy()
	src.stats = stats.Copy()
	src.talents = talents.Copy()
	transform()

/**
 * flatten everything into ids
 */
/datum/characteristic_preset/proc/transform()
	var/datum/characteristic_skill/skillpath_or_id
	var/datum/characteristic_stat/statpath_or_id
	var/datum/characteristic_talent/talentpath_or_id
	for(var/i in 1 to length(skills))
		skillpath_or_id = skills[i]
		if(ispath(skillpath_or_id))
			skills[i] = initial(skillpath_or_id.id)
	for(var/i in 1 to length(stats))
		statpath_or_id = stats[i]
		if(ispath(statpath_or_id))
			stats[i] = initial(statpath_or_id.id)
	for(var/i in 1 to length(talents))
		talentpath_or_id = talents[i]
		if(ispath(talentpath_or_id))
			talents[i] = initial(talentpath_or_id.id)

