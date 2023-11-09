/**
 * wraps an entity
 */
/datum/game_entity
	abstract_type = /datum/game_entity
	/// expected type to return from resolve()
	var/expected_type

/datum/game_entity/proc/resolve()
	CRASH("abstract proc not implemented")

/**
 * called to specially check if we're in a location, even if automatic handling fails
 *
 * @return non null TRUE/FALSE to override
 */
/datum/game_entity/proc/special_in_location(datum/game_location/location)
	return

/**
 * 'dumbly' wraps something in a hard reference, automatically unlinking from it if it's deleted
 */
/datum/game_entity/basic
	expected_type = /datum
	/// target entity
	var/datum/target

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

/datum/game_entity/basic/resolve()
	RETURN_TYPE(/atom/movable)
	return ..()
