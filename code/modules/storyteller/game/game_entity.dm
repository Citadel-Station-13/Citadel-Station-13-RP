/**
 * wraps an entity
 */
/datum/game_entity
	abstract_type = /datum/game_entity
	/// expected type
	var/expected_type

/datum/game_entity/proc/resolve()
	CRASH("abstract proc not implemented")

#warn impl

/datum/game_entity/overmap
	expected_type = /obj/overmap/entity
	/// target
	var/obj/overmap/entity/target

/datum/game_entity/overmap/resolve()
	RETURN_TYPE(/obj/overmap/entity)

/datum/game_entity/movable
	expected_type = /obj/overmap/entity
	/// target
	var/atom/movable/target

/datum/game_entity/movable/resolve()
	RETURN_TYPE(/atom/movable)
