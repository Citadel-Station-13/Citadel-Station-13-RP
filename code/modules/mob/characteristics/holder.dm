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
	skills[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] = val

/datum/characteristics_holder/proc/get_stat(datum/characteristic_stat/id_or_typepath)
	. = stats[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/datum/characteristics_holder/proc/get_skill(datum/characteristic_skill/id_or_typepath)
	. = skills[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath] || CHARACTER_SKILL_UNTRAINED

/datum/characteristics_holder/proc/add_talent(datum/characteristic_talent/id_or_typepath, ...)
	#warn impl

/datum/characteristics_holder/proc/remove_talent(datum/characteristic_talent/id_or_typepath)
	#warn impl

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
	#warn impl
