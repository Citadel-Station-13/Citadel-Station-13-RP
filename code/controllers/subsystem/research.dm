SUBSYSTEM_DEF(research)
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_RESEARCH

	/// design lookup id = instance
	var/list/design_lookup

/datum/controller/subsystem/research/Initialize()
	#warn impl
	return ..()

/datum/controller/subsystem/research/Recover()
	#warn impl
	return ..()

/datum/controller/subsystem/research/proc/build_designs()
	#warn impl

/**
 * shove a design into lookup for the round
 *
 * you should know what you are doing before trying this
 * make sure you drop all references of the design from your end!
 */
/datum/controller/subsystem/research/proc/register_design(datum/design/registering)
	#warn impl

/**
 * gets a design datum
 *
 * *do not* modify the datum returned!
 */
/datum/controller/subsystem/research/proc/fetch_design(datum/design/id_or_typepath)
	#warn impl

/**
 * gets a list of design datums by id or typepath
 *
 * *do not* modify the datums returned!
 */
/datum/controller/subsystem/research/proc/fetch_designs(list/datum/design/id_or_typepaths)
	#warn impl
