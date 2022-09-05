/**
 * oh god,
 * oh
 * fuck.
 *
 * datum persistence
 *
 * why didn't i listen to lohikar and just use persistencestation's serializer?
 *
 * supports both wrapping/unwrapping shared datums, as well as single copy datums like gas mixtures.
 *
 * To facilitate typepath refactors, this requires the loading object specify what path to load.
 * The same is done with datum_key, which should be a define.
 */
/datum/controller/subsystem/persistence

#warn impl

/**
 * saves datums that should be copied per object
 *
 * returns the id to use for loading.
 */
/datum/controller/subsystem/persistence/proc/SaveDatum(datum/D, datum_key)

/**
 * loads datums that should be copied per object.
 *
 * returns the datum.
 */
/datum/controller/subsystem/persistence/proc/LoadDatum(datum/D, datum_key, path)

/**
 * saves datums that should be shared per object
 *
 * the subsystem will handle referencing these datums.
 *
 * returns the id to use for loading.
 */
/datum/controller/subsystem/persistence/proc/SaveSharedDatum(datum/D, datum_key)

/**
 * loads datums that should be shared per object.
 *
 * the subsystem will provide a cached datum is available.
 *
 * returns the datum.
 */
/datum/controller/subsystem/persistence/proc/LoadSharedDatum(datum/D, datum_key, path)

/**
 * returns a list of data to save.
 *
 * **Do not use from /atom's**. Use the atom helpers for that.
 * These are strictly for value-type datums.
 */
/datum/proc/Serialize(shared)
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	.[NAMEOF(src, type)] = type

/**
 * called with a list of data to load.
 *
 * **Do not use from /atom's**. Use the atom helpers for that.
 * These are strictly for value-type datums.
 */
/datum/proc/Deserialize(list/data, shared)
	SHOULD_CALL_PARENT(TRUE)
	if(text2path(data[NAMEOF(src, type)]) != type)
		SSpersistence.subsystem_log("[REF(src)] loading type mismatch [type] vs expected [data[NAMEOF(src, type)]]")

/atom/Serialize(shared)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Atom Serialize() called; this is only a valid call on /datum.")

/atom/Deserialize(shared)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Atom Deserialize() called; this is only a valid call on /datum.")
