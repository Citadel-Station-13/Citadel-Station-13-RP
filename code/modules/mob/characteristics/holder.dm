/**
 * holds characteristics data
 *
 * can be just used as a holder datum but can also be used as a 1:1 with a mind
 * downsides: can only be associated with one mind at a time, for now.
 * if this belongs to a mind the mind has free reign to qdel it. you have been warned.
 */
/datum/characteristics_holder
	//! ownership
	/// current mind that holds us; **CAN BE NULL**
	var/datum/mind/mind

	//! characteristics
	/// skill ids associated to values
	var/list/skills
	/// stat ids associated to values
	var/list/stats
	/// talent ids associated to arbitrary metadata, usually just 1 for assoc lookup; said metadata should eval to true in logic.
	var/list/talents
	// todo: modifiers

/datum/characteristics_holder/Destroy()
	if(mind)
		disassociate_from_mind(mind)
	return ..()

/datum/characteristics_holder/proc/associate_with_mind(datum/mind/M)
	if(M.current)
		associate_with_mob(M.current)
	if(M.characteristics)
		stack_trace("mind already had characteristics")
	M.characteristics = src
	for(var/id in talents)
		var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
		talent.gain(M, talents[id])

/datum/characteristics_holder/proc/disassociate_from_mind(datum/mind/M)
	if(M.current)
		disassociate_from_mob(M.current)
	if(M.characteristics != src)
		stack_trace("mind characteristics was not self")
	for(var/id in talents)
		var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
		talent.lose(M, talents[id])
	M.characteristics = null

/datum/characteristics_holder/proc/associate_with_mob(mob/M)
	for(var/id in talents)
		var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
		talent.attach(M, talents[id])

/datum/characteristics_holder/proc/disassociate_from_mob(mob/M)
	for(var/id in talents)
		var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
		talent.detach(M, talents[id])

/datum/characteristics_holder/proc/set_stat(datum/characteristic_stat/id_or_typepath, val)
	LAZYINITLIST(stats)
	stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] = val

/datum/characteristics_holder/proc/set_skill(datum/characteristic_skill/id_or_typepath, val)
	LAZYINITLIST(skills)
	skills[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] = val

/datum/characteristics_holder/proc/get_stat(datum/characteristic_stat/id_or_typepath)
	. = stats?[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/datum/characteristics_holder/proc/get_skill(datum/characteristic_skill/id_or_typepath)
	. = skills?[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] || CHARACTER_SKILL_UNTRAINED

/datum/characteristics_holder/proc/add_talent(datum/characteristic_talent/id_or_typepath, ...)
	var/id = ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath
	if(talents?[id])
		// do NOT allow overwrite!
		return FALSE
	var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
	talents[id] = talent.metadata(arglist(args.Copy(2)))
	if(mind)
		if(mind.current)
			talent.attach(mind.current, talents[id])
		talent.gain(mind, talents[id])

/datum/characteristics_holder/proc/remove_talent(datum/characteristic_talent/id_or_typepath)
	var/id = ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath
	if(!talents?[id])
		return FALSE
	var/datum/characteristic_talent/talent = resolve_characteristics_talent(id)
	if(mind)
		if(mind.current)
			talent.detach(mind.current, talents[id])
		talent.lose(mind, talents[id])
	talents -= id
	return TRUE

/datum/characteristics_holder/proc/has_talent(datum/characteristic_talent/id_or_typepath)
	return !!talents[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/**
 * apply a preset to us
 *
 * @params
 * - typepath_or_preset - typepath or preset datum
 * - overwrite - should we replace everything in us or instead raise / append if needed?
 */
/datum/characteristics_holder/proc/apply_preset(datum/characteristic_preset/typepath_or_preset, overwrite = FALSE)
	if(ispath(typepath_or_preset))
		typepath_or_preset = resolve_characteristics_preset(typepath_or_preset)
	if(typepath_or_preset.skills)
		LAZYINITLIST(skills)
		if(overwrite)
			skills = typepath_or_preset.skills.Copy()
		else
			for(var/id in typepath_or_preset.skills)
				skills[id] = max(skills[id], typepath_or_preset.skills[id])
	if(typepath_or_preset.stats)
		LAZYINITLIST(stats)
		if(overwrite)
			stats = typepath_or_preset.stats.Copy()
		else
			for(var/id in typepath_or_preset.stats)
				var/datum/characteristic_stat/stat = resolve_characteristics_stat(id)
				stats[id] = stat.greater_value(stats[id], typepath_or_preset.stats[id])
	if(typepath_or_preset.talents)
		LAZYINITLIST(talents)
		for(var/id in typepath_or_preset.talents)
			if(has_talent(id))
				continue
			if(typepath_or_preset.talents[id])
				add_talent(arglist(list(id) + typepath_or_preset.talents[id]))
			else
				add_talent(id)
	return TRUE

/**
 * clones
 */
/datum/characteristics_holder/proc/clone()
	RETURN_TYPE(/datum/characteristics_holder)
	var/datum/characteristics_holder/cloning = new
	cloning.skills = skills.Copy()
	cloning.stats = stats.Copy()
	cloning.talents = talents.Copy()
	return cloning
