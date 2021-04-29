SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

/datum/controller/subsystem/overmaps/Initialize()
	if(GLOB.using_map.use_overmap)
		GLOB.overmap_event_handler.create_events(GLOB.using_map.overmap_z, GLOB.using_map.overmap_size, GLOB.using_map.overmap_event_areas)
	rebuild_helm_computers()
	return ..()

/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in global.machines)
		H.get_known_sectors()

/datum/controller/subsystem/overmaps/proc/queue_helm_computer_rebuild()
	if(!subsystem_initialized)
		return
	addtimer(CALLBACK(src, .proc/rebuild_helm_computers), 0, TIMER_UNIQUE)
