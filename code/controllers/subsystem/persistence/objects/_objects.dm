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
 *
 */
/atom/proc/load_mapped_persistence(uid_override)

/**
 *
 */
/atom/proc/save_mapped_persistence(uid_override)

//! ATOM INSTANTIATION

/datum/controller/subsystem/persistence/proc/_generic_atom_instantiate(type, x, y, z, list/data, flags)

//! ATOM PROCS
//? These procs give us the ability to do dynamic persistence with a generic API for the subsystem to use into
//? Persistence must be hooked in manually, because far as the codebase is concerned, we are
//? still mostly a round based game (for now).
//? Therefore, we can't sacrifice performance in /New().

/atom/proc/persistence_store(flags)
	RETURN_TYPE(/list)
	return list()

/atom/proc/persistence_load(list/data, flags)

/**
 * checks if we should persist
 * see __DEFINES/controllers/persistence.dm for flags
 */
/atom/proc/should_persist(flags)
