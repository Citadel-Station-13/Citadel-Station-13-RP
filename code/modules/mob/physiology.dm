/**
 * physiology holder
 */
/datum/physiology

/datum/physiology/proc/apply(datum/physiology_modifier/modifier)

/datum/physiology/proc/revert(datum/physiology_modifier/modifier)

/**
 * physiology modifier
 */
/datum/physiology_modifier

/**
 * subtype for hardcoded physiology modifiers
 */
/datum/physiology_modifier/intrinsic

/mob/proc/init_physiology()
	for(var/i in 1 to length(physiology_modifiers))
		if(ispath(physiology_modifiers[i]))
			physiology_modifiers[i] = new physiology_modifiers[i]
	rebuild_physiology()

/mob/proc/add_physiology_modifier(datum/physiology_modifier/modifier)
	ASSERT(!(modifier in physiology_modifiers))
	physiology_modifiers += modifier
	physiology.apply(modifier)

/mob/proc/remove_physiology_modifier(datum/physiology_modifier/modifier)
	ASSERT(modifier in physiology_modifiers)
	physiology_modifiers -= modifier
	physiology.revert(modifier)

/mob/proc/rebuild_physiology()
	physiology = new
	for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
		if(!istype(modifier))
			physiology_modifiers -= modifier
			continue
		physiology.apply(modifier)
