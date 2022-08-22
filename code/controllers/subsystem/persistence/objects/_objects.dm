/**
 * ! Persistent Object Storage
 *
 * ? SQL is required. Savefiles are too unperformant for us to do generic object storage.
 *
 * ! Warning: Your SQL server should be the same box as your game server.
 * ! Due to threaded SQL being comically slow, we use non-async queries here,
 * ! which WILL slow your server to a crawl if your database is not localhost.
 *
 * ? Todo: RW caching to not require non-async calls.
 *
 * This folder contains most generic non-feature-specific storages
 *
 * If you want to do something regarding either
 * 1. persisting a lot of map objects
 * 2. persisting map objects generically
 * 3. persisting runtime objects generically and specifically
 * 4. persisting strings generically
 *
 * You have come to the right folder
 *
 * For more general server things like panic bunker, gamemodes, paintings, photos, etc,
 * please make new files for the code for them. Don't overload the object system with snowflake,
 * it's optimized specifically for these 4 use cases
 *
 * Yes, you can add more use cases, if you know what you're doing.
 * Considering I don't, you probably don't either.
 */
/datum/controller/subsystem/persistence

/**
 * Checks if the object storage module is online
 */
/datum/controller/subsystem/persistence/proc/ObjectStoreEnabled()
	return SSdbcore.Connect()

//! ATOM HELPERS
/**
 * loads static data from the map
 *
 * automatically called at time of writing from SSatoms initialization.
 */
/atom/proc/load_static_persistence(uid = persist_static_uid)

/**
 * saves static data to the map
 */
/atom/proc/save_static_persistence(uid = persist_static_uid)

/**
 * called in Destroy if we have static uid
 */
/atom/proc/qdestroying_static_persistence(uid = persist_static_uid)


#warn impl + have checks to make sure dynamic/static persistence can't both fire on an atom

/**
 * saves dynamic data to the map
 */
/atom/proc/save_dynamic_persistence(uid = persist_dynamic_uid)

/**
 * called in Destroy if we have dynamic uid
 */
/atom/proc/qdestroying_dynamic_persistence(uid = persist_dynamic_uid)

//! ATOM INSTANTIATION

/datum/controller/subsystem/persistence/proc/_generic_atom_instantiate(type, x, y, z, list/data, flags)

//! ATOM PROCS
//? These procs give us the ability to do dynamic persistence with a generic API for the subsystem to use into
//? Persistence must be hooked in manually, because far as the codebase is concerned, we are
//? still mostly a round based game (for now).
//? Therefore, we can't sacrifice performance in /New().

/**
 * stores data in a list
 * will be automatically packed with other data by the persistence system.
 */
/atom/proc/persistence_store(flags)
	RETURN_TYPE(/list)
	return list()

/**
 * loads data from a list.
 * some data will already be automatically loaded by the persistence system (like position/type, duh).
 */
/atom/proc/persistence_load(list/data, flags)

/**
 * checks if we should persist
 * see __DEFINES/controllers/persistence.dm for flags
 */
/atom/proc/should_persist(flags)
	return !QDELETED(src)
