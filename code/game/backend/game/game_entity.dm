/**
 * # Game Entity
 *
 * smart wrappers for entities so we can avoid direct-referencing otherwise volatile objects that can be destroyed.
 */
/datum/game_entity
	abstract_type = /datum/game_entity

/datum/game_entity/proc/resolve()
	CRASH("abstract proc not implemented")

/**
 * called to specially check if we're in a location, overriding automatic checks.
 *
 * @return non null TRUE/FALSE to override
 */
/datum/game_entity/proc/special_in_location(datum/game_location/location)
	return
