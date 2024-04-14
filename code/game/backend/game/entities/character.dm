
/**
 * binds to an IC character
 *
 * persists through mind swaps
 *
 * prefer this to basic for things like protect/kill objectives.
 *
 * todo: make this actually work lol for now it's just /basic
 */
/datum/game_entity/character
	/// target entity
	var/mob/target

/datum/game_entity/character/New(datum/whom)
	if(isnull(whom))
		return
	wrap(whom)

/datum/game_entity/character/proc/wrap(datum/whom)
	ASSERT(istype(whom, /mob))
	target = whom
	RegisterSignal(whom, COMSIG_PARENT_QDELETING, PROC_REF(target_deleted))

/datum/game_entity/basic/proc/target_deleted(datum/source)
	if(source != target)
		return
	target = null

/datum/game_entity/character/resolve()
	RETURN_TYPE(/datum/mind)
	return target.mind
