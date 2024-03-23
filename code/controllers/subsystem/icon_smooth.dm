SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	wait = 0
	init_order = INIT_ORDER_ICON_SMOOTHING
	priority = FIRE_PRIORITY_SMOOTHING
	subsystem_flags = SS_HIBERNATE

	///Blueprints assemble an image of what pipes/manifolds/wires look like on initialization, and thus should be taken after everything's been smoothed
	// var/list/blueprint_queue = list()
	var/list/smooth_queue = list()
	var/list/deferred = list()

/datum/controller/subsystem/icon_smooth/PreInit()
	. = ..()
	hibernate_checks = list(
		NAMEOF(src, smooth_queue),
		NAMEOF(src, deferred)
	)

/datum/controller/subsystem/icon_smooth/Initialize()
	var/list/queue = smooth_queue
	smooth_queue = list()

#ifndef FASTBOOT_DISABLE_SMOOTHING
	while(length(queue))
		var/atom/smoothing_atom = queue[length(queue)]
		queue.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED) || !smoothing_atom.z)
			continue
		smoothing_atom.smooth_icon()
		CHECK_TICK
#endif

	return ..()

/datum/controller/subsystem/icon_smooth/fire()
	var/list/smooth_queue_cache = smooth_queue
	while(length(smooth_queue_cache))
		var/atom/smoothing_atom = smooth_queue_cache[length(smooth_queue_cache)]
		smooth_queue_cache.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED))
			continue
		if(smoothing_atom.atom_flags & ATOM_INITIALIZED)
			smoothing_atom.smooth_icon()
		else
			deferred += smoothing_atom
		if (MC_TICK_CHECK)
			return

	if (!smooth_queue_cache.len && deferred.len)
		smooth_queue = deferred
		deferred = smooth_queue_cache

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	if(thing.smoothing_flags & SMOOTH_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	thing.smoothing_flags &= ~SMOOTH_QUEUED
	smooth_queue -= thing
	// if(blueprint_queue)
	// 	blueprint_queue -= thing
	deferred -= thing
