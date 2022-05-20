SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	subsystem_flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun

/datum/controller/subsystem/parallax/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	if(times_fired % 5)		// lazy tick
		while(length(currentrun))
			var/client/processing_client = currentrun[currentrun.len]
			currentrun.len--
			if (QDELETED(processing_client) || !processing_client.eye)
				if (MC_TICK_CHECK)
					return
				continue
			processing_client.parallax_holder?.Update()
			if (MC_TICK_CHECK)
				return
	else	// full tick
		while(length(currentrun))
			var/client/processing_client = currentrun[currentrun.len]
			currentrun.len--
			if (QDELETED(processing_client) || !processing_client.eye)
				if (MC_TICK_CHECK)
					return
				continue
			processing_client.parallax_holder?.Update(TRUE)
			if (MC_TICK_CHECK)
				return

	currentrun = null

/**
 * Gets parallax type for zlevel.
 */
/datum/controller/subsystem/parallax/proc/get_parallax_type(z)
	return /datum/parallax/space

/**
 * Gets parallax for zlevel.
 */
/datum/controller/subsystem/parallax/proc/get_parallax_datum(z)
	var/type = get_parallax_type(z)
	return new type(z)

/**
 * Gets parallax added vis contents for zlevel
 */
/datum/controller/subsystem/parallax/proc/get_parallax_vis_contents(z)
	. = list()
	// overmaps
	var/obj/effect/overmap/visitable/v = get_overmap_sector(z)
	if(istype(v))
		for(var/obj/effect/overmap/other in v.loc)
			if(other == v)
				continue
			var/atom/movable/AM = other.get_parallax_image()
			if(AM)
				. += AM
	// events
	var/list/image/event_images = list()
	for(var/datum/event/E in SSevents.active_events)
		if(!(z in E.affecting_z))
			continue
		event_images += E.get_parallax_image()
	if(event_images.len)
		// this is snowflakey as fuck but we are reworking overmaps soon
		// .... right?
		var/atom/movable/overmap_skybox_holder/holder = new
		holder.overlays = event_images
		. += holder

/**
 * Gets parallax motion for a zlevel
 *
 * Returns null or list(speed, dir deg clockwise from north, windup, turnrate)
 * THE RETURNED LIST MUST BE A 4-TUPLE, OR PARALLAX WILL CRASH.
 * DO NOT SCREW WITH THIS UNLESS YOU KNOW WHAT YOU ARE DOING.
 *
 * This will override area motion
 */
/datum/controller/subsystem/parallax/proc/get_parallax_motion(z)
	// right now we only care about overmaps
	var/obj/effect/overmap/visitable/ship/V = get_overmap_sector(z)
	if(!istype(V))
		return
	if(V.is_still())
		return
	return list(
		60,
		dir2angle(V.fore_dir),
		60,
		0
	)

/**
 * updates all parallax for clients on a z
 */
/datum/controller/subsystem/parallax/proc/update_clients_on_z(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.Update(TRUE)

/**
 * resets all parallax for clients on a z
 */
/datum/controller/subsystem/parallax/proc/reset_clients_on_z(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.Reset()

/**
 * resets vis contents for clients on a z
 */
/datum/controller/subsystem/parallax/proc/update_z_vis_contents(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.SyncVisContents()

/**
 * updates motion of all clients on z
 */
/datum/controller/subsystem/parallax/proc/update_z_motion(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.UpdateMotion()

/**
 * queues a zlevel for update of vis contents
 * ALWAYS USE THIS PROC FROM THINGS LIKE EVENTS AND OVERMAPS!
 * z
 */
/datum/controller/subsystem/parallax/proc/queue_z_vis_update(z)
	addtimer(CALLBACK(src, .proc/update_z_vis_contents, z), flags = TIMER_UNIQUE)
