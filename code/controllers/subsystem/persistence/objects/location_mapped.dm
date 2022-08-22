/**
 * ! Location Mapped Persistence
 *
 * ? Requires SQL to be enabled.
 *
 * the cheapest form of persistence
 * uses singleton datums to handle all creation/destruction
 * things are stored by location and packed where possible
 *
 * low level helpers are available for those who know how to use them, but usually
 * it'll be stored by coordinates.
 *
 * ? Saving is far faster when done for all levels at once, as opposed to one at a time.
 * ! Location mapped persistence only supports things on turfs.
 * ! There's no reason to do otherwise, and this speeds up things considerably.
 */
/datum/controller/subsystem/persistence
	/// location mapped serializers/deserializers - these are ephemeral and WILL reset on crashes because they shouldn't really be runtime modified in the first place!
	var/list/datum/mass_persistence_handler/mass_persistence_handlers

/datum/controller/subsystem/persistence/InitPersistence()
	_create_mass_persistence_handlers()
	return ..()

/datum/controller/subsystem/persistence/proc/_create_mass_persistence_handlers()
	if(islist(mass_persistence_handlers))
		for(var/datum/mass_persistence_handler/handler in mass_persistence_handlers)
			qdel(handler)
	mass_persistence_handlers = list()
	var/list/id_unique = list()
	for(var/path in subtypesof(/datum/mass_persistence_handler))
		var/datum/mass_persistence_handler/handler = path
		if(initial(handler.abstract_type) == path)
			continue
		handler = new path
		mass_persistence_handlers += handler
		if(id_unique[handler.id])
			var/datum/mass_persistence_handler/other = id_unique[handler.id]
			stack_trace("id collision on [path] and [other.type]")
		else
			id_unique[handler.id] = handler

/datum/controller/subsystem/persistence/proc/LoadAllLocationMappedObjects()
	if(!SSdbcore.Connect())
		return
	for(var/id in _all_loaded_map_ids())
		LoadLocationMappedObjects(id)

/datum/controller/subsystem/persistence/proc/SaveAllLocationMappedObjects()
	if(!SSdbcore.Connect())
		return

/datum/controller/subsystem/persistence/proc/DeleteAllLocationMappedObjects(loaded_only = TRUE)

/datum/controller/subsystem/persistence/proc/SaveLocationMappedObjects(level_id, handler_id)

/datum/controller/subsystem/persistence/proc/LoadLocationMappedObjects(level_id, handler_id)

/datum/controller/subsystem/persistence/proc/DeleteLocationMappedObjects(level_id, handler_id)

/datum/controller/subsystem/persistence/proc/WipeLocationMappedObjects(level_id, handler_id)
	if(IsAdminAdvancedProcCall())
		// this isn't to stop admins from wiping shit, this is to stop admins from fucking around and finding out
		to_chat(usr, "Wiping location mapped objects manually is disallowed..")
		return

/datum/controller/subsystem/persistence/proc/LoadMassPersistenceLevelData(level_id)
	RETURN_TYPE(/datum/mass_persistence_level_data)


/datum/controller/subsystem/persistence/proc/SaveMassPersistenceLevelData(datum/mass_persistence_level_data)

/datum/controller/subsystem/persistence/proc/SaveMassPersistenceFragment(handler_id, level_id, index, data)

/datum/controller/subsystem/persistence/proc/LoadMassPersistenceFragment(handler_id, level_id, index)

/**
 * struct for SQL ops
 */
/datum/mass_persistence_level_data
	/// level id
	var/level_id
	/// handler id
	var/handler_id
	/// level x size
	var/size_x
	/// level y size
	var/size_y
	/// flags
	var/flags
	/// current revision
	var/revision

/**
 * singleton datum that handles save/loading of "mass persisted" objects
 * see [code/controllers/subssyetm/persistence/objects/location_mapped.dm] for more info
 *
 * table stores:
 * saved time
 * handler id (so we know what handler to use)
 * level id (we can't rely on z indexes)
 * fragment (so we don't save/load everything in one go which might be detrimental to performance)
 * data (just the data the handler uses)
 *
 * store:
 * - gather objects, either all or filter to z
 * - for every level, split into fragments
 * - gather data for fragments
 * - pack fragments, write to SQL
 *
 * load:
 * - map id, zlevel, passed into handler
 * - handler parses through fragments and unpacks one by one
 * - object instantiation
 *
 * erase:
 * - everything based on a level id or handler id or both or neither is erased
 */
/datum/mass_persistence_handler
	/// name
	var/name = "Unknown Handler"
	/// user friendly desc
	var/desc = "You shouldn't see this description."
	/// abstract type
	var/abstract_type = /datum/mass_persistence_handler
	/// id - **must** be unique
	var/id

//! Mass Persistence Handlers - Loading- do not override unless you know what you are doing!
//! Blackboard is null if not a mass load operation, otherwise it'll be shared by all. Use to collate stuff like for(x in world).

/datum/mass_persistence_handler/proc/Load(level_id, z, force, list/blackboard)
	// process arguments
	if(!level_id && !z)
		CRASH("no level id or z")
	if(!level_id)
		level_id = _map_id_of_z(z)
		if(!level_id)
			CRASH("no level ID")
	if(!z)
		z = _z_of_map_id(level_id)
		if(!z)
			CRASH("no z")
	// load metadata
	var/datum/mass_persistence_level_data/metadata = SSpersistence.LoadMassPersistenceLevelData(level_id)
	// check data
	if(!force && ((metadata.size_x != world.maxx) || (metadata.size_y != world.maxy)))
		SSpersistence.subsystem_log("Handler [id] failed to load with args [level_id], [z] due to size mismatch. Expected: [metadata.size_x] by [metadata.size_y], actual [world.maxx] by [world.maxy]")
		return

	#warn finish

/datum/mass_persistence_handler/proc/_Unpack(data, list/blackboard)

/datum/mass_persistence_handler/proc/_InstantiateAndDeserialize(list/data, list/blackboard)

//! Mass Persistence Handlers - Saving - do not override unless you know what you are doing!
//! Blackboard is null if not a mass save operation, otherwise it'll be shared by all. Use to collate stuff like for(x in world).

/datum/mass_persistence_handler/proc/SaveSpecific(level_id, z, list/blackboard)
	// process arguments
	if(!level_id && !z)
		CRASH("no level id or z")
	if(!level_id)
		level_id = _map_id_of_z(z)
		if(!level_id)
			CRASH("no level ID")
	if(!z)
		z = _z_of_map_id(level_id)
		if(!z)
			CRASH("no z")

	#warn finish

/datum/mass_persistence_handler/proc/SaveAll(list/blackboard)

/**
 * gets all atoms
 */
/datum/mass_persistence_handler/proc/_Collect(z_filter, list/blackboard)

/**
 * filters out atoms not in a zlevel
 */
/datum/mass_persistence_handler/proc/_LevelFilter(list/atom/entities, z_filter, list/blackboard)
	RETURN_TYPE(/list)
	. = list()

/**
 * groups atoms by zlevels, filtering out any zlevels without level ids
 *
 * returns list of lists associated to map ids
 */
/datum/mass_persistence_handler/proc/_MassFilter(list/atom/entities, list/blackboard)
	RETURN_TYPE(/list)
	// prep lists
	var/list/assembled = list()
	for(var/i in 1 to world.maxz)
		assembled[++assembled.len] = list()
	// get levels we care about
	var/list/relevant = _full_z_to_map_id_lookup()
	// inject atoms we care about
	for(var/atom/A as anything in entities)
		if(!relevant[A.z])
			continue
		assembled[A.z] += A
	// prep final list
	. = list()
	// inject assembled, associating to map id
	for(var/i in 1 to world.maxz)
		if(!length(assembled[i]))
			continue
		.[relevant[i]] = assembled[i]

/**
 * splits atoms from a specific level into fragments
 */
/datum/mass_persistence_handler/proc/_Split(list/atom/entities, fragment_size, list/blackboard)
	if(!fragment_size)
		fragment_size = CONFIG_GET(number/persistence_mass_fragment_size)
		if(!fragment_size)
			CRASH("couldn't get fragment size")

/**
 * gather data of atoms in fragment
 */
/datum/mass_persistence_handler/proc/_Serialize(list/atom/entities, list/blackboard)
	RETURN_TYPE(/list)

/**
 * packs everything into a string for SQL
 */
/datum/mass_persistence_handler/proc/_Pack(list/data, list/blackboard)

//! this is the stuff you should actually override
//! once again, blackboard is not null during mass operations, so use it to stage for(atom type in world)!

/datum/mass_persistence_handler/proc/GetObjects(list/blackboard)

/**
 * faster way to get objects
 * usually NOT_IMPLEMENTED because z checks are genuinely awful
 * and there's no way to make a generic method to do this.
 */
/datum/mass_persistence_handler/proc/GetObjectsOnLevel(z, list/blackboard)
	return NOT_IMPLEMENTED

/datum/mass_persistence_handler/proc/Serialize(atom/A)
	RETURN_TYPE(/list)

/datum/mass_persistence_handler/proc/Instantiate(type, x, y, z, list/data)
