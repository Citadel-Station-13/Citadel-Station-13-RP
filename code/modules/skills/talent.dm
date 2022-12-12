GLOBAL_LIST_INIT(skillsystem_talents, _create_skillsystem_talents())

/proc/_create_skillsystem_talents()
	#warn impl

/**
 * barotrauma-like talents
 * these are **global singletons** to better do things like synchronization
 * make sure to gc your stuff properly on Destroy().
 */
/datum/talent
	var/id

/datum/talent/proc/attach(mob/M)

/datum/talent/proc/detach(mob/M)
