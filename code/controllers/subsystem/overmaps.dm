SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_OVERMAPS
	init_order = INIT_ORDER_OVERMAPS
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	subsystem_flags = SS_KEEP_TIMING

	/// did you know? shuttle flight levels are free!
	/// that means you can just take one!
	///
	/// * this is the list of currently unallocated/free'd up shuttle flight levels
	/// * we don't use zclear system so overmaps is even-more-decoupled from SSmapping.
	var/list/datum/map_level/shuttle/free_flight_levels = list()
	/// currently in-use shuttle flight levels
	var/list/datum/map_level/shuttle/used_flight_levels = list()

/datum/controller/subsystem/overmaps/proc/assign_flight_level(obj/overmap/entity/visitable/ship/landable/leader)
	if(length(free_flight_levels))
		var/datum/map_level/shuttle/level = free_flight_levels[1]
	var/datum/map_level/shuttle/creating = new
	SSmapping.load_level(creating)
	src.owned_level = creating
	. = creating
	ASSERT(creating.loaded)
	#warn impl

/datum/controller/subsystem/overmaps/proc/dispose_flight_level(datum/map_level/shuttle/level, obj/overmap/entity/visitable/ship/landable/last_to_leave)
	#warn impl
	clear_flight_level(level, last_to_leave)

// todo: SSzclear when?
/datum/controller/subsystem/overmaps/proc/clear_flight_level(datum/map_level/shuttle/level, obj/overmap/entity/visitable/ship/landable/last_to_leave)
	ASSERT(level.initialized)
	ASSERT(level.z_index)

	var/list/turf/clearing_turfs = Z_TURFS(level.z_index)
	var/list/atom/movable/clearing_movables = list()
	var/area/move_to_area = unique_area_of_type(/area/space)
	var/deleted = 0
	var/cycles_so_far = 0
	var/clean = FALSE

	do
		// no check tick on this one
		for(var/turf/T as anything in clearing_turfs)
			for(var/atom/movable/AM as anything in T)
				if(AM.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
					continue
				clearing_movables += AM

		clean = !length(clearing_turfs)
		if(clean)
			continue

		// yes check tick on this one
		for(var/atom/movable/AM as anything in clearing_movables)
			// WELCOME TO HELL: this is how we handle atoms
			if(isliving(AM))
				var/mob/living/victim = AM
				var/throw_them_out_of_the_sky = FALSE
				// if they have a mind, they're probably relevant
				if(victim.mind)
					throw_them_out_of_the_sky = TRUE
				else if(victim.ckey)
					stack_trace("victim [victim] with ckey [victim.ckey] but no mind ([victim.type])")
					throw_them_out_of_the_sky = TRUE
				if(!throw_them_out_of_the_sky)
					// Bye Bye!
					qdel(victim)
					continue
				#warn uh oh
			else
				// * objs
				// * /mob, but not /mob/living
				// Bye Bye!
				qdel(AM)
				continue

	while(!clean && cycles_so_far <= 5)

	if(cycles_so_far >= 5)
		stack_trace("aborted clearing level due to taking more than 5 cycles to do so.")

	// finished, finalize
	move_to_area.take_turfs(clearing_turfs)
	// deal with turfs
	var/level_baseturf = level.base_turf
	if(!ispath(level_baseturf, /turf))
		level_baseturf = world.turf
	for(var/turf/T as anything in clearing_turfs)
		CHECK_TICK
		if(istype(T, level_baseturf))
			continue
		T.ChangeTurf(level_baseturf, level_baseturf)
	return deleted

/datum/controller/subsystem/overmaps
//* LEGACY STUFF BELOW THIS LINE
//* So, everything
//* Yes, I'm staging this early for overmaps rewrite

	/// Whether ships can move on the overmap; used for adminbus.
	var/static/overmap_halted = FALSE
	/// List of all ships.
	var/static/list/ships = list()

	/**
	 *! I made these shitty vars so we don't search for these in GOD DAMN WORLD
	 *! If I find these are still here in 2023 I'll be very upset.
	 * @Zandario
	 *
	 *? it's 2023 owned liked and subscribed lmao
	 *? @silicons
	 *
	 *? it's 2024 now please send help i'm losing it
	 *? @silicons
	 */

	var/list/unary_engines = list()
	var/list/ion_engines = list()

/datum/controller/subsystem/overmaps/Initialize()
	if((LEGACY_MAP_DATUM).use_overmap)
		GLOB.overmap_event_handler.create_events((LEGACY_MAP_DATUM).overmap_z, (LEGACY_MAP_DATUM).overmap_size, (LEGACY_MAP_DATUM).overmap_event_areas)
	rebuild_helm_computers()
	initialize_engines_legacy()
	return ..()

/datum/controller/subsystem/overmaps/proc/initialize_engines_legacy()
	//! citadel edit - initialize overmaps shuttles here until we rewrite overmaps to not be a dumpster fire god damnit
	for(var/obj/machinery/atmospherics/component/unary/engine/E in unary_engines)
		if(E.linked)
			continue
		E.link_to_ship()
	for(var/obj/machinery/ion_engine/E in ion_engines)
		if(E.linked)
			continue
		E.link_to_ship()

/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in GLOB.machines)
		H.get_known_sectors()

/datum/controller/subsystem/overmaps/proc/queue_helm_computer_rebuild()
	if(!initialized)
		return
	addtimer(CALLBACK(src, PROC_REF(rebuild_helm_computers)), 0, TIMER_UNIQUE)

// Admin command to halt/resume overmap
/datum/controller/subsystem/overmaps/proc/toggle_overmap(new_setting)
	if(overmap_halted == new_setting)
		return
	overmap_halted = !overmap_halted
	for(var/ship in ships)
		var/obj/overmap/entity/visitable/ship/ship_effect = ship
		overmap_halted ? ship_effect.halt() : ship_effect.unhalt()
