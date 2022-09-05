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
	if(!uid)
		return

	var/map_id = persist_static_loaded_map_id || SSpersistence._map_id_of_z(persist_flags & ATOM_PERSIST_UNWRAPS_ONTO_TURF? get_z(src) : z)
	if(!map_id)
		return

	persist_static_loaded_map_id = map_id
	var/list/data = SSpersistence.FetchStaticObjectData(uid, map_id)
	if(!data)
		return

	persistence_load(data, PERSIST_OP_STATIC_LOAD)
	persist_flags |= ATOM_PERSIST_LOADED

/**
 * saves static data to the map
 */
/atom/proc/save_static_persistence(uid = persist_static_uid)
	if(!uid)
		return

	#warn ATOM_PERSIST_STATIC_IS_MAP_AGNOSTIC check

	var/map_id = SSpersistence._map_id_of_z(persist_flgas & ATOM_PERSIST_UNWRAPS_ONTO_TURF? get_z(src) : z)

	if(map_id && persist_static_loaded_map_id)
		if(map_id != persist_static_loaded_map_id)
			if(!(persist_flags & ATOM_PERSIST_SURVIVE_STATIC_OFFMAP))
				SSpersistence.WipeStaticObjectData(uid, persist_static_loaded_map_id)
				return

	if((persist_flags & ATOM_PERSIST_LOADED) && persist_static_loaded_map_id)
		if(map_id)

/**
 * called in Destroy if we have static uid
 */
/atom/proc/qdestroying_static_persistence(uid = persist_static_uid)


#warn impl + have checks to make sure dynamic/static persistence can't both fire on an atom

/**
 * initializes or re-asserts dynamic persistence
 */
/atom/proc/persist(flags = (PERSIST_OP_CHECK_SEMANTIC_SURVIVAL | PERSIST_OP_AGGRESSIVE_SURVIVAL_CHECK))
	if(persist_static_uid)
		// static already handles it so
		save_static_persistence()
		return
	#warn impl

/**
 * saves dynamic data to the map
 */
/atom/proc/save_dynamic_persistence(uid = persist_dynamic_uid)

/**
 * called in Destroy if we have dynamic uid
 */
/atom/proc/qdestroying_dynamic_persistence(uid = persist_dynamic_uid)

//! ATOM INSTANTIATION, LOADING, SAVING

/datum/controller/subsystem/persistence/proc/_generic_atom_instantiate(type, x, y, z, list/data, flags)

/**
 * call from containers that want to save their data
 */
/datum/controller/subsystem/persistence/proc/serialize_nested_movable(atom/A, flags)

/**
 * call from containers that want to then load their data
 */
/datum/controller/subsystem/persistence/proc/deserialize_nested_movable(list/data, flags)

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
