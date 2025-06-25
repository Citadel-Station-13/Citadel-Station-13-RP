/**
 * WIP
 * TODO: /datum/prototype/role
 * TODO: unified role system
 *
 * * Roles are associated to a mind, nto a mob.
 */
/datum/role
	abstract_type = /datum/role

	/// unique id
	var/id

/datum/role/proc/on_gain(datum/mind/mind)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/datum/role/proc/on_lost(datum/mind/mind)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * * Avoid using this. This is an escape hatch.
 */
/datum/role/proc/on_mob_associate(datum/mind/mind, mob/character)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * * Avoid using this. This is an escape hatch.
 */
/datum/role/proc/on_mob_disassociate(datum/mind/mind, mob/character)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
