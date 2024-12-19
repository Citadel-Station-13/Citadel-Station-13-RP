SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	init_stage = INIT_STAGE_WORLD
	subsystem_flags = SS_NO_FIRE

	/// A stack of list(source, desired initialized state)
	/// We read the source of init changes from the last entry, and assert that all changes will come with a reset
	var/list/initialized_state = list()
	var/base_initialized

	var/list/late_loaders = list()

	var/list/BadInitializeCalls = list()

	///initAtom() adds the atom its creating to this list iff InitializeAtoms() has been given a list to populate as an argument
	var/list/created_atoms

	/// Atoms that will be deleted once the subsystem is initialized
	var/list/queued_deletions = list()

	var/init_start_time

	#ifdef PROFILE_MAPLOAD_INIT_ATOM
	var/list/mapload_init_times = list()
	#endif

	/// Status to use for atom New() / Initialize().
	var/atom_init_status = ATOM_INIT_IN_SUBSYSTEM

/datum/controller/subsystem/atoms/Initialize(timeofday)
	init_start_time = world.time

	atom_init_status = ATOM_INIT_IN_NEW_MAPLOAD
	InitializeAtoms()
	atom_init_status = ATOM_INIT_IN_NEW_REGULAR

	return SS_INIT_SUCCESS

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms, list/atoms_to_return)
	if(atom_init_status == ATOM_INIT_IN_SUBSYSTEM)
		return

	// Generate a unique mapload source for this run of InitializeAtoms
	var/static/uid = 0
	uid = (uid + 1) % (SHORT_REAL_LIMIT - 1)
	var/source = "subsystem init [uid]"
	set_tracked_initalized(ATOM_INIT_IN_NEW_MAPLOAD, source)

	// This may look a bit odd, but if the actual atom creation runtimes for some reason, we absolutely need to set atom_init_status BACK
	CreateAtoms(atoms, atoms_to_return, source)
	clear_tracked_initalize(source)

	if(late_loaders.len)
		for(var/I in 1 to late_loaders.len)
			var/atom/A = late_loaders[I]
			//I hate that we need this
			if(QDELETED(A))
				continue
			A.LateInitialize()
			CHECK_TICK
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

	if (created_atoms)
		atoms_to_return += created_atoms
		created_atoms = null

	for (var/queued_deletion in queued_deletions)
		qdel(queued_deletion)

	testing("[queued_deletions.len] atoms were queued for deletion.")
	queued_deletions.Cut()

	#ifdef PROFILE_MAPLOAD_INIT_ATOM
	rustg_file_write(json_encode(mapload_init_times), "[GLOB.log_directory]/init_times.json")
	#endif

/// Actually creates the list of atoms. Exists solely so a runtime in the creation logic doesn't cause initialized to totally break
/datum/controller/subsystem/atoms/proc/CreateAtoms(list/atoms, list/atoms_to_return = null, mapload_source = null)
	if (atoms_to_return)
		LAZYINITLIST(created_atoms)

	#ifdef TESTING
	var/count
	#endif

	var/list/mapload_arg = list(TRUE)

	if(atoms)
		#ifdef TESTING
		count = atoms.len
		#endif

		for(var/I in 1 to atoms.len)
			var/atom/A = atoms[I]
			if(!(A.atom_flags & ATOM_INITIALIZED))
				// Unrolled CHECK_TICK setup to let us enable/disable mapload based off source
				if(TICK_CHECK)
					clear_tracked_initalize(mapload_source)
					stoplag()
					if(mapload_source)
						set_tracked_initalized(ATOM_INIT_IN_NEW_MAPLOAD, mapload_source)
				PROFILE_INIT_ATOM_BEGIN()
				InitAtom(A, TRUE, mapload_arg)
				PROFILE_INIT_ATOM_END(A)
	else
		#ifdef TESTING
		count = 0
		#endif

		for(var/atom/A as anything in world)
			if(!(A.atom_flags & ATOM_INITIALIZED))
				PROFILE_INIT_ATOM_BEGIN()
				InitAtom(A, FALSE, mapload_arg)
				PROFILE_INIT_ATOM_END(A)
				#ifdef TESTING
				++count
				#endif
				if(TICK_CHECK)
					clear_tracked_initalize(mapload_source)
					stoplag()
					if(mapload_source)
						set_tracked_initalized(ATOM_INIT_IN_NEW_MAPLOAD, mapload_source)

	testing("Initialized [count] atoms")

/**
 * immediately creates and inits an atom
 *
 * @params
 * * path - typepath
 * * mapload - treat as mapload?
 * * where - location to init at
 * * ... - rest of args are passed to new() / Initialize().
 */
/datum/controller/subsystem/atoms/proc/instance_atom_immediate(path, mapload, atom/where, ...)
	SHOULD_NOT_SLEEP(TRUE)
	var/old_init_status = atom_init_status
	atom_init_status = mapload? ATOM_INIT_IN_NEW_MAPLOAD : ATOM_INIT_IN_NEW_REGULAR
	var/atom/created = new path(arglist(args.Copy(3)))
	atom_init_status = old_init_status
	return created

/**
 * immediately creates and inits an atom with a preloader callback.
 *
 * @params
 * * path - typepath
 * * mapload - treat as mapload?
 * * preload_call - callback to invoke with (created) for the created atom. This is not allowed to sleep.
 * * where - location to init at
 * * ... - rest of args are passed to new() / Initialize().
 */
/datum/controller/subsystem/atoms/proc/instance_atom_immediate_with_preloader(path, mapload, datum/callback/preload_call, atom/where, ...)
	SHOULD_NOT_SLEEP(TRUE)
	var/old_init_status = atom_init_status
	atom_init_status = ATOM_INIT_IN_SUBSYSTEM
	var/atom/created = new path(arglist(args.Copy(4)))
	preload_call.invoke_no_sleep(created)
	atom_init_status = mapload? ATOM_INIT_IN_NEW_MAPLOAD : ATOM_INIT_IN_NEW_REGULAR
	// this sets 'where' to if we should be mapload.
	// this is acceptable because args[4] ('where') is not used again.
	args[4] = mapload
	InitAtom(created, FALSE, args.Copy(4))
	atom_init_status = old_init_status
	return created

/datum/controller/subsystem/atoms/proc/map_loader_begin(source)
	set_tracked_initalized(ATOM_INIT_IN_SUBSYSTEM, source)

/datum/controller/subsystem/atoms/proc/map_loader_stop(source)
	clear_tracked_initalize(source)

/// Returns the source currently modifying SSatom's init behavior
/datum/controller/subsystem/atoms/proc/get_initialized_source()
	var/state_length = length(initialized_state)
	if(!state_length)
		return null
	return initialized_state[state_length][1]

/// Use this to set initialized to prevent error states where the old initialized is overridden, and we end up losing all context
/// Accepts a state and a source, the most recent state is used, sources exist to prevent overriding old values accidentally
/datum/controller/subsystem/atoms/proc/set_tracked_initalized(state, source)
	if(!length(initialized_state))
		base_initialized = atom_init_status
	initialized_state += list(list(source, state))
	atom_init_status = state

/datum/controller/subsystem/atoms/proc/clear_tracked_initalize(source)
	if(!length(initialized_state))
		return
	for(var/i in length(initialized_state) to 1 step -1)
		if(initialized_state[i][1] == source)
			initialized_state.Cut(i, i+1)
			break

	if(!length(initialized_state))
		atom_init_status = base_initialized
		base_initialized = ATOM_INIT_IN_NEW_REGULAR
		return
	atom_init_status = initialized_state[length(initialized_state)][2]

/// Returns TRUE if anything is currently being initialized
/datum/controller/subsystem/atoms/proc/initializing_something()
	return length(initialized_state) > 1

/datum/controller/subsystem/atoms/proc/init_map_bounds(list/bounds)
	if (atom_init_status == ATOM_INIT_IN_SUBSYSTEM)
		return	// Let proper initialisation handle it later

	var/prev_shuttle_queue_state = SSshuttle.block_init_queue
	SSshuttle.block_init_queue = TRUE

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(
		locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
		locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]),
	)

	for(var/L in turfs)
		var/turf/B = L
		B.queue_zone_update()
		QUEUE_SMOOTH(B)
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice("<span class='danger'>Initializing newly created atom(s) in submap.</span>", R_DEBUG)
	InitializeAtoms(atoms)

	admin_notice("<span class='danger'>Initializing atmos pipenets and machinery in submap.</span>", R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all machines in loaded areas get notified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	SSshuttle.block_init_queue = prev_shuttle_queue_state
	SSshuttle.process_init_queues()	// We will flush the queue unless there were other blockers, in which case they will do it.

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)


/datum/controller/subsystem/atoms/Recover()
	atom_init_status = SSatoms.atom_init_status
	if(atom_init_status == ATOM_INIT_IN_NEW_MAPLOAD)
		InitializeAtoms()
	initialized_state = SSatoms.initialized_state
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize(mapload)\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd before Initialize proc ran\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/// Prepares an atom to be deleted once the atoms SS is initialized.
/datum/controller/subsystem/atoms/proc/prepare_deletion(atom/target)
	if (atom_init_status == ATOM_INIT_IN_NEW_REGULAR)
		// Atoms SS has already completed, just kill it now.
		qdel(target)
	else
		queued_deletions += WEAKREF(target)

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[GLOB.log_directory]/initialize.log")
