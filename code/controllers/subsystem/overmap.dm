SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

/datum/controller/subsystem/overmaps/Initialize()
	if(using_map_legacy.use_overmap)
		GLOB.overmap_event_handler.create_events(using_map_legacy.overmap_z, using_map_legacy.overmap_size, using_map_legacy.overmap_event_areas)
	rebuild_helm_computers()
	return ..()

/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in GLOB.machines)
		H.get_known_sectors()

/datum/controller/subsystem/overmaps/proc/queue_helm_computer_rebuild()
	if(!initialized)
		return
	addtimer(CALLBACK(src, .proc/rebuild_helm_computers), 0, TIMER_UNIQUE)
