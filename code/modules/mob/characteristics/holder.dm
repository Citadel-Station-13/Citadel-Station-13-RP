/**
 * holds characteristics data
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
	#warn de-mind
	return ..()

/datum/characteristics_holder/proc/associate_with_mind(datum/mind/M)
	#warn impl

/datum/characteristics_holder/proc/disassociate_from_mind(datum/mind/M)
	#warn impl

/datum/characteristics_holder/proc/set_stat(datum/characteristic_stat/id_or_typepath, val)
	stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] = val

/datum/characteristics_holder/proc/set_skill(datum/characteristic_skill/id_or_typepath, val)
	stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] = val

/datum/characteristics_holder/proc/get_stat(datum/characteristic_stat/id_or_typepath)
	return stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/datum/characteristics_holder/proc/get_skill(datum/characteristic_skill/id_or_typepath)
	return stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/datum/characteristics_holder/proc/add_talent(datum/characteristic_talent/id_or_typepath, ...)
	#warn impl

/datum/characteristics_holder/proc/remove_talent(datum/characteristic_talent/id_or_typepath)
	#warn impl

/datum/characteristics_holder/proc/has_talent(datum/characteristic_talent/id_or_typepath)
	return !!talents[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]
