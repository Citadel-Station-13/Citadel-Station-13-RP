SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

	/// overmap by id
	//  todo: recover
	var/static/list/datum/overmap/overmap_by_id = list()

	/// im so sorry bros dont hurt me please--
	/// (eventually we'll have proper bindings but for now, uh, this is how it is!)
	var/const/default_overmap_id = "main"

/datum/controller/subsystem/overmaps/Initialize()
	make_default_overmap()
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

/datum/controller/subsystem/overmaps/proc/make_default_overmap()
	#warn screaming above/below

/proc/build_overmap()
	if(!(LEGACY_MAP_DATUM).use_overmap)
		return 1

	ASSERT(!(LEGACY_MAP_DATUM).overmap_z)
	testing("Building overmap...")
	(LEGACY_MAP_DATUM).overmap_z = SSmapping.allocate_level().z_index

	testing("Putting overmap on [(LEGACY_MAP_DATUM).overmap_z]")
	var/area/overmap/A = new
	for (var/square in block(locate(1,1,(LEGACY_MAP_DATUM).overmap_z), locate((LEGACY_MAP_DATUM).overmap_size,(LEGACY_MAP_DATUM).overmap_size,(LEGACY_MAP_DATUM).overmap_z)))
		var/turf/T = square
		if(T.x == 1 || T.y == 1 || T.x == (LEGACY_MAP_DATUM).overmap_size || T.y == (LEGACY_MAP_DATUM).overmap_size)
			T = T.ChangeTurf(/turf/overmap/edge)
		else
			T = T.ChangeTurf(/turf/overmap)
		ChangeArea(T, A)

	(LEGACY_MAP_DATUM).sealed_levels |= (LEGACY_MAP_DATUM).overmap_z

	testing("Overmap build complete.")
	return 1
