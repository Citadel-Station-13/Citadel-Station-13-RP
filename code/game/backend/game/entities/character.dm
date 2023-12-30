
/**
 * binds to an IC character
 *
 * persists through mind swaps
 *
 * prefer this to basic for things like protect/kill objectives.
 */
/datum/game_entity/character
	#warn impl

/datum/game_entity/character/New(datum/what)
	if(isnull(what))
		return
	wrap(what)

/datum/game_entity/character/proc/wrap(datum/what)
	#warn impl

/datum/game_entity/character/resolve()
	RETURN_TYPE(/mob)
	#warn impl
