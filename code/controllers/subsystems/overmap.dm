SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS
	/// Helm computers queued for rebuild

/datum/controller/subsystem/overmaps/Initialize()
	rebuild_helm_computers()
	return ..()

/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in global.machines)
		H.get_known_sectors()

/datum/controller/subsystems/overmaps/proc/queue_helm_computer_rebuild()
	if(!subsystem_initialized)
		return
	addtimer(CALLBACK(src, .proc/rebuild_helm_computers), 0, TIMER_UNIQUE)
