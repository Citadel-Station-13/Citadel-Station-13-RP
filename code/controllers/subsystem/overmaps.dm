SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	wait = 1 SECONDS
	init_order = INIT_ORDER_OVERMAPS
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	subsystem_flags = SS_KEEP_TIMING

	//* Freeflight *//

	/// did you know? shuttle flight levels are free!
	/// that means you can just take one!
	///
	/// * this is the list of currently unallocated/free'd up shuttle flight levels
	/// * we don't use zclear system so overmaps is even-more-decoupled from SSmapping.
	var/list/datum/map_level/freeflight/free_flight_levels = list()
	/// currently in-use shuttle flight levels
	var/list/datum/map_level/freeflight/used_flight_levels = list()

	//* Global Tuning *//

	/// applied to all ship thrust
	var/global_thrust_multiplier = 2

//* Flight Levels *//

/**
 * The core issue this is solving is BYOND zlevels.
 *
 * When shuttles fly, they don't really move. They move the space around them, their zlevel,
 * on a virtual map.
 *
 * Flight levels are what we call those; and all of this is solving the problem of what
 * we do with that level when one flight level intersects another, or an entity during landing
 *
 * How this is done before (baystation / vorestation):
 * 1. shuttles own an exclusive level
 * 2. shuttles can only access that exclusive level or another thing's level
 * 3. interdictions: shuttles 'visiting' other shuttles land on that shuttle's exclusive level
 * 4. because shuttles have exclusive permanent levels, shuttles cannot escape from interdictions
 *
 * How we do it now:
 *
 * We try our best to solve the issues of,
 *
 * * interdictions: shuttles should be able to escape from them as per gameplay.
 * * level recycling: we have a lot more shuttles than the shuttles in use. we want to recycle levels whenever possible.
 * * balance / PvP: disengagement is considered here in terms of what happens
 *
 * What we arrived at is thus these following axioms:
 *
 * * Shuttles must always have a flight level while in freeflight, not transit
 * * Shuttles must always teardown their flightlevel when permanently leaving freeflight, or hand it off to another
 * * Objects left behind with MOVABLE_NO_LOST_IN_SPACE will have their continuity preserved, but will not necessarily survive.
 * * Objects left behind without that flag are treated as we please, up to and including usually just deleting it.
 * * Turfs left behind are implementation-defined for how we treat it. Players shouldn't be putting turfs outside of shuttles anyways.
 *
 * Thus, the following specs determine what happens and when.
 *
 * * visiting --> freeflight: shuttle allocates a new flight level
 * * freeflight --> freeflight (interdiction): shuttle merges their flight level into the victim's
 * * freeflight --> visiting: freeflight level is torn down and merged. planets = skyfall, non-planets = put on zlevel edges if possible.
 *
 * Here's what happens during merges
 *
 * * freeflight --> freeflight: direct x/y preserving merge. blocked turfs get their contents kicked to nearby turfs via algorithm
 * * freeflight --> visiting (planet): skyfall on outdoors
 * * freeflight --> visiting (non-planet): put on nearby turf to shuttle as debris cloud
 */
#warn /datum/component/recursive_freeflight_permeance

/datum/controller/subsystem/overmaps/proc/assign_flight_level(obj/overmap/entity/visitable/ship/landable/leader)
	// make sure they don't already have one
	ASSERT(!leader.flight_level)
	// get a free level or allocate a new one
	var/datum/map_level/freeflight/assigning
	if(length(free_flight_levels))
		assigning = free_flight_levels[free_flight_levels.len]
		free_flight_levels.len--
	else
		var/datum/map_level/freeflight/creating = new
		SSmapping.load_level(creating)
		assigning = creating
	// mark as used
	used_flight_levels += assigning
	// assign them their level
	leader.flight_level = assigning
	// done
	return TRUE

/**
 * called when a shuttle leaves their flight level
 *
 * we make a best estimate of where to send things on the level based on
 *
 * 1. who the leader is
 * 2. who is left on the level
 * 3. where the leaving shuttle is going
 *
 * @params
 * * level - the level now orphaned
 * * leaving - the shuttle who left
 * * moving_into - (optional) the overmap entity the leader is going into
 * * moving_to_level - (optional) the zlevel index the leader is goign to
 * * hand_off_to - (optional) forcefully set which entity to hand this off to. this doesn't need to be set, we can autodetect
 */
/datum/controller/subsystem/overmaps/proc/release_flight_level(
	datum/map_level/freeflight/level,
	obj/overmap/entity/visitable/ship/leaving,
	obj/overmap/entity/moving_into,
	moving_to_level,
	obj/overmap/entity/visitable/ship/hand_off_to,
)
	#warn stuff

/**
 * called when the last shuttle leaves a flight level
 */
/datum/controller/subsystem/overmaps/proc/dispose_flight_level(datum/map_level/freeflight/level, obj/overmap/entity/visitable/ship/landable/leaving, obj/overmap/entity/going_into)
	#warn impl
	clear_flight_level(level, leaving)

/**
 * internal proc: merges a flight level into another
 *
 * called by clear_flight_level
 *
 * * we don't move turfs or anything; non shuttle turfs are just left behind
 */
/datum/controller/subsystem/overmaps/proc/merge_flight_level_contents(datum/map_level/freeflight/disposing, datum/map_level/freeflight/merging_into, list/atom/movable/movables)

// todo: SSzclear when?
/**
 * internal proc: clears a flight level
 *
 * @params
 * * level - the level to clear
 * * handler - what to do with atoms
 * * live_handler - what to do with atoms to not destroy; called with (list/atom/movable/movables)
 * * dead_handler - what to do with atoms to destroy; called with (list/atom/movable/movables)
 */
/datum/controller/subsystem/overmaps/proc/clear_flight_level(datum/map_level/freeflight/level, datum/callback/live_handler, datum/callback/dead_handler)
	PRIVATE_PROC(TRUE)

	ASSERT(level.loaded)
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
				if(AM.atom_flags & (ATOM_ABSTRACT))
					continue
				clearing_movables += AM

		clean = !length(clearing_turfs)
		if(clean)
			continue

		// yes check tick on this one
		for(var/atom/movable/AM as anything in clearing_movables)
			// WELCOME TO HELL: this is how we handle atoms
			var/yeet_them_out_of_the_sky = AM.movable_flags & MOVABLE_NO_LOST_IN_SPACE
			if(!yeet_them_out_of_the_sky)
				if(isliving(AM))
					var/mob/living/victim = AM
					// if they have a mind, they're probably relevant
					if(victim.mind)
						yeet_them_out_of_the_sky = TRUE
					else if(victim.ckey)
						stack_trace("victim [victim] with ckey [victim.ckey] but no mind ([victim.type])")
						yeet_them_out_of_the_sky  = TRUE
			if(!yeet_them_out_of_the_sky)
				// Bye Bye!
				qdel(AM)
				continue
			#warn yuh YEET
			#warn deal with shuttle interdiction

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

//* LEGACY STUFF BELOW THIS LINE
//* So, everything
//* Yes, I'm staging this early for overmaps rewrite
/datum/controller/subsystem/overmaps

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
	return SS_INIT_SUCCESS

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
