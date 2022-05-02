SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	flags = SS_TICKER
	wait = 1
	priority = FIRE_PRIORITY_OVERMAPS
	init_order = INIT_ORDER_OVERMAPS

	// overmaps
	/// all overmaps in world
	var/static/list/datum/overmap/overmaps = list()

	// hard simulation config
	/// max entity sim speed in overmaps dist units/second
	var/static/max_entity_speed = 80 * OVERMAP_DISTANCE_PIXEL
	/// desired movement accuracy in pixels/tick
	var/movement_accuracy = 4
	/// movement speed modifier - this will be used to multiply normal simspeed, but still cannot exceed max entity speed!
	var/global_entity_speed_mod = 1

/datum/controller/subsystem/overmaps/Initialize()
	RecalculatePhysicsLimits()
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

/proc/build_overmap()
	if(!GLOB.using_map.use_overmap)
		return 1

	testing("Building overmap...")
	world.increment_max_z()
	GLOB.using_map.overmap_z = world.maxz

	testing("Putting overmap on [GLOB.using_map.overmap_z]")
	var/area/overmap/A = new
	for (var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z)))
		var/turf/T = square
		if(T.x == 1 || T.y == 1 || T.x == GLOB.using_map.overmap_size || T.y == GLOB.using_map.overmap_size)
			T = T.ChangeTurf(/turf/overmap/edge)
		else
			T = T.ChangeTurf(/turf/overmap)
		ChangeArea(T, A)

	GLOB.using_map.sealed_levels |= GLOB.using_map.overmap_z

	testing("Overmap build complete.")
	return 1

/datum/controller/subsystem/overmaps/proc/fire(resumed)
	// physics tick every single tick
	var/time = (subsystem_flags & SS_TICKER)? wait * world.tick_lag : wait
	for(var/datum/overmap/O as anything in overmaps)
		O.PhysicsTick(time)

/datum/controller/subsystem/overmaps/proc/RecalculatePhysicsLimits()
	// we calculate max entity speed to avoid physics clipping issues because this is byond
	// and we obviously can't do some fancy algorithm to stop this
	max_entity_speed = world.fps * movement_accuracy
