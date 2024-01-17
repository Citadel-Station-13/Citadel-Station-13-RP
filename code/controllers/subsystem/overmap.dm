SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_OVERMAPS
	init_order = INIT_ORDER_OVERMAPS
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	subsystem_flags = SS_KEEP_TIMING

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
	 */

	var/list/unary_engines = list()
	var/list/ion_engines = list()

/datum/controller/subsystem/overmaps/Initialize()
	if((LEGACY_MAP_DATUM).use_overmap)
		GLOB.overmap_event_handler.create_events((LEGACY_MAP_DATUM).overmap_z, (LEGACY_MAP_DATUM).overmap_size, (LEGACY_MAP_DATUM).overmap_event_areas)
	rebuild_helm_computers()
	return ..()

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
