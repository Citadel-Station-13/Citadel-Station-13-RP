
/**
 * 'dumbly' wraps something in a hard reference, automatically unlinking from it if it's deleted
 */
/datum/game_entity/basic
	/// target entity
	var/datum/target
	/// expected type to return from resolve()
	var/expected_type = /datum

/datum/game_entity/basic/New(datum/what)
	if(isnull(what))
		return
	wrap(what)

/datum/game_entity/basic/proc/wrap(datum/what)
	target = what
	RegisterSignal(what, COMSIG_PARENT_QDELETING, PROC_REF(target_deleted))

/datum/game_entity/basic/proc/target_deleted(datum/source)
	if(source != target)
		return
	target = null

/datum/game_entity/basic/resolve()
	RETURN_TYPE(/datum)
	return target

/datum/game_entity/basic/overmap
	expected_type = /obj/overmap/entity

/datum/game_entity/basic/overmap/resolve()
	RETURN_TYPE(/obj/overmap/entity)
	return ..()

/datum/game_entity/basic/movable
	expected_type = /atom/movable

/datum/game_entity/basic/movable/resolve()
	RETURN_TYPE(/atom/movable)
	return ..()
