GLOBAL_LIST_INIT(characteristics_talents, _create_characteristics_talents())

/proc/_create_characteristics_talents()
	. = list()
	for(var/datum/characteristic_talent/talent in subtypesof(/datum/characteristic_talent))
		if(is_abstract(talent))
			continue
		. = new talent
		if(isnull(talent.id))
			stack_trace("null id on [talent.type]")
			continue
		if(.[talent.id])
			stack_trace("collision on id [talent.id] between types [talent.type] and [.[talent.id]:type]")
			continue
		.[talent.id] = talent

/**
 * gets a talent datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_talent(datum/characteristic_talent/typepath_or_id)
	RETURN_TYPE(/datum/characteristic_talent)
	return GLOB.characteristics_talents[ispath(typepath_or_id)? initial(typepath_or_id.id) : typepath_or_id]

/**
 * barotrauma-like talents
 * these are **global singletons** to better do things like synchronization
 * make sure to gc your stuff properly on Destroy().
 *
 * talents default to not being there when characteristics are disabled
 */
/datum/characteristic_talent
	abstract_type = /datum/characteristic_talent
	/// unique id
	var/id
	/// name
	var/name = "ERROR"
	/// desc
	var/desc = "An unknown talent. Someone needs to set this."

/**
 * called when we're put into a mind
 * attach for mobs is called separately by mind
 */
/datum/characteristic_talent/proc/gain(datum/mind/M, metadata)

/**
 * called when we're yanked out of a mind
 * detach for mobs is called separately by mind
 */
/datum/characteristic_talent/proc/lose(datum/mind/M, metadata)

/**
 * called when we're attaching to a mob
 */
/datum/characteristic_talent/proc/attach(mob/M, metadata)

/**
 * called when we're detaching from a mob
 */
/datum/characteristic_talent/proc/detach(mob/M, metadata)

/**
 * generates initial metadata for when we're being added to a holder
 *
 * @return anything that evals to true in logical expressions; defaults to TRUE if unimplemented
 */
/datum/characteristic_talent/proc/metadata(...)
	return TRUE
