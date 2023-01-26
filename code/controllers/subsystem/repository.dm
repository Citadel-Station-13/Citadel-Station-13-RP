// TODO: file unticked
// see [code/datums/prototype.dm] for why.

/**
 * global singleton storage and fetcher
 */
SUBSYSTEM_DEF(repository)
	name = "Repository"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_REPOSITORY

	///

/datum/controller/subsystem/repository/Initialize()
	#warn impl
	return ..()

/datum/controller/subsystem/repository/Recover()
	#warn impl
	return ..()

/datum/controller/subsystem/repository/proc/fetch(datum/prototype/type_or_id)

/datum/controller/subsystem/repository/proc/fetch_subtypes(path)

/datum/controller/subsystem/repository/proc/register(datum/prototype/instance)

/datum/controller/subsystem/repository/proc/unregister(datum/prototype/instance)

/datum/controller/subsystem/repository/proc/generate()
	#warn impl
