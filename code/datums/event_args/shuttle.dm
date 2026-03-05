//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle events
 */
#warn update above
/datum/event_args/shuttle
	/// shuttle ref
	var/datum/shuttle/shuttle

	/// Are we forcefully attempting to proceed?
	var/forcing = FALSE
	/// Are we dangerously attempting to force?
	///
	/// * 'forcing' will only kick out non-dangerous hooks
	/// * 'dangerously_forcing' will kick out all hooks that can be forced
	var/dangerously_forcing = FALSE
	/// Are we recovering from a failed dock operation?
	var/recovering = FALSE
	/// did we succeed?
	var/succeeded = FALSE
	/// are we done?
	var/finished = FALSE

/datum/event_args/shuttle/New(datum/shuttle/shuttle)
	src.shuttle = shuttle

/datum/event_args/shuttle/Destroy()
	if(!finished)
		finish(FALSE)
	shuttle = null
	controller = null
	return ..()

/datum/event_args/shuttle/proc/begin(timeout)
	src.timeout_duration = timeout
	src.timeout_at = isnull(timeout)? null : world.time + timeout

/datum/event_args/shuttle/proc/force()
	if(forcing)
		return
	forcing = TRUE
	#warn impl

/datum/event_args/shuttle/proc/is_blocked()
	return blockable && length(waiting_on_hooks)

/**
 * implies [force()]
 */
/datum/event_args/shuttle/proc/dangerously_force()
	force()
	if(dangerously_forcing)
		return
	dangerously_forcing = TRUE
	#warn impl

/datum/event_args/shuttle/proc/finish(success)
	succeeded = success
	finished = TRUE

	for(var/datum/shuttle_hook/hook in waiting_on_hooks)
		release(hook)

/datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
	. = FALSE
	if(!blockable)
		// it is YOUR job to check if an event is blockable.
		CRASH("attempted to block an unblockable event")
	ASSERT(!(src in hook.blocking))
	LAZYADD(hook.blocking, src)
	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)
	if(dangerous)
		forcing_could_be_dangerous = TRUE
	return TRUE

/datum/event_args/shuttle/proc/release(datum/shuttle_hook/hook)
	waiting_on_hooks -= hook
	LAZYREMOVE(hook.blocking, src)

/datum/event_args/shuttle/proc/update(datum/shuttle_hook/hook, list/reason_or_reasons)
	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)

/**
 * Shuttle docking event
 *
 * ## Order of Operations
 *
 * Docking
 * * Docking fired
 * * On success, post-docking is fired
 * * On failure, post-undocking is fired with recovery
 *
 * Undocking
 * * Undocking fired
 * * On success, post-undocking is fired
 * * On failure, post-docking is fired with recovery
 *
 * Takeoff
 * * Takeoff fired
 * * On success, post-takeoff is fired
 * * On failure, post-landing is fired on the dock the shuttle was taking off from with recovery.
 * * On failure, post-takeoff is fired on the dock the shuttle was landing on with recovery.
 *
 * Landing
 * * Landing fired
 * * On success, post-landing is fired
 * * On failure, post-takeoff is fired on the dock the shuttle was landing onwith recovery.
 * * On failure, post-landing is fired on the dock the shuttle was taking off from with recovery.
 *
 * ## Notes
 *
 * * Only called by controller and managed transit cycles. This is not a low-level hook
 * * Direct shuttle translation calls will not call this.
 * * For things that reference each other / connect to a shuttle, please hook translation hooks to ensure disconnection.
 */
#warn how to deal with takeoff/landing?
/datum/event_args/shuttle/dock
	/// controller ref
	var/datum/shuttle_controller/controller
	/// shuttle port being used, if any
	var/obj/shuttle_port/shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/dock
	/// hint: how much time does the shuttle have left to leaving / needing the next step?
	///
	/// e.g. if takeoff_time is 3 seconds, you set this to 3 seconds for 'departing'
	/// so things like hanger doors open only before the end
	var/duration_to_next
	/// for the above, the world.time we were fired
	/// so things that require checking elapsed time work
	var/started_at

/datum/event_args/shuttle/dock/New(datum/shuttle/shuttle, obj/shuttle_dock/dock, obj/shuttle_port/port)
	..()
	src.controller = shuttle.controller
	src.dock = dock
	src.shuttle_port = port

#warn transit cycle?

/datum/event_args/shuttle/dock/begin(timeout, spool_duration)
	. = ..()
	started_at = world.time
	duration_to_next = spool_duration

/**
 * negative returns mean that we have overshot the available time
 */
/datum/event_args/shuttle/dock/proc/time_to_next()
	return duration_to_next - (world.time - started_at)

/datum/event_args/shuttle/dock/docking
	blockable = TRUE

/datum/event_args/shuttle/dock/undocking
	blockable = TRUE

/datum/event_args/shuttle/dock/docked
	blockable = FALSE

/datum/event_args/shuttle/dock/undocked
	blockable = FALSE

/datum/event_args/shuttle/dock/departing
	blockable = TRUE

/datum/event_args/shuttle/dock/departed
	blockable = FALSE

/datum/event_args/shuttle/dock/arriving
	blockable = TRUE

/datum/event_args/shuttle/dock/arrived
	blockable = FALSE

/**
 * * Fired by shuttle controllers. This is not a low-level hook.
 * * The role of this is to be able to hook move events for things like point defense to fire at the shuttle.
 *
 * Order of operations:
 * * undock
 * * traversal - egress on leaving
 * * transit if necessary
 * * traversal - ingress on landing
 * * transit if necessary
 * * dock
 *
 * if traversal fails **befores** leaving the old location, the opposite event is called on the old location with 'recovery'
 * if traversal fails or is cancelled **after** leaving the old location, the opposite is called on the old location with 'recovery'
 */
#warn finalize what the fuck this is / is going to be
/datum/event_args/shuttle/dock/traversal
	/// controller ref
	var/datum/shuttle_controller/controller
	blockable = TRUE

/datum/event_args/shuttle/traversal/web
	/// old node
	/// * nullable
	var/datum/shuttle_web_node/from_node
	/// new node
	var/datum/shuttle_web_node/to_node
	/// * nullable

/datum/event_args/shuttle/traversal/web/New(datum/shuttle/shuttle, datum/shuttle_web_node/from_node, datum/shuttle_web_node/to_node)
	#warn impl

/datum/event_args/shuttle/traversal/web/ingress
/datum/event_args/shuttle/traversal/web/egress

/datum/event_args/shuttle/traversal/overmap
	/// old location
	/// * nullable; if null, is freeflight
	var/obj/overmap/entity/old_inside_entity
	/// new location
	/// * nullable; if null, is freeflight
	var/obj/overmap/entity/new_inside_entity

	#warn impl

/datum/event_args/shuttle/traversal/overmap/New(datum/shuttle/shuttle, obj/overmap/entity/old_inside_entity, obj/overmap/entity/new_inside_entity)

	#warn impl

/datum/event_args/shuttle/traversal/overmap/ingress
/datum/event_args/shuttle/traversal/overmap/egress

/**
 * Shuttle translation
 *
 * ## Order of Operations
 *
 * * pre_move called before aligned_translation()
 * * post_move called after aligned_translation()
 *
 * ## Notes
 *
 * * only called on shuttle side hooks
 * * cannot be blocked
 * * called even if a controller is not involved, as these are considered low-level hooks.
 */
/datum/event_args/shuttle/translation
	blockable = FALSE

	/// list(x, y, z, dir) of anchor pre-move
	var/list/old_anchor_location
	/// list(x, y, z, dir) of anchor post-move
	var/list/new_anchor_location

/**
 * * Anchor location lists passed in are copied, and are safe to modify after this call.
 */
/datum/event_args/shuttle/translation/New(datum/shuttle/shuttle, list/old_anchor_location, list/new_anchor_location)
	..()
	src.old_anchor_location = old_anchor_location.Copy()
	src.new_anchor_location = new_anchor_location.Copy()

/datum/event_args/shuttle/translation/pre_move

/datum/event_args/shuttle/translation/post_move
