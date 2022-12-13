GLOBAL_LIST_INIT(characteristics_talents, _create_characteristics_talents())

/proc/_create_characteristics_talents()
	#warn impl


/**
 * gets a talent datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_talent(datum/characteristic_talent/typepath_or_id)
	if(ispath(typepath_or_id))
		return GLOB.characteristics_talents[initial(typepath_or_id[id])]
	ASSERT(istext(typepath_or_id))
	return GLOB.characteristics_talents[typepath_or_id]

/**
 * barotrauma-like talents
 * these are **global singletons** to better do things like synchronization
 * make sure to gc your stuff properly on Destroy().
 */
/datum/characteristic_talent
	var/id

/datum/characteristic_talent/proc/gain(datum/mind/M)

/datum/characteristic_talent/proc/lose(datum/mind/M)

/datum/characteristic_talent/proc/attach(mob/M)

/datum/characteristic_talent/proc/detach(mob/M)
