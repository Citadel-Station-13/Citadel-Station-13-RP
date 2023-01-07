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
	/// talent typepaths or ids
	var/list/talents
