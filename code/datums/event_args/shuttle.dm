//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle events
 *
 * These are emitted by shuttles as various things happen during their lifecycle.
 */
/datum/event_args/shuttle
	/// shuttle ref
	var/datum/shuttle/shuttle

/datum/event_args/shuttle/New(datum/shuttle/shuttle)
	src.shuttle = shuttle

/**
 * Hints if the event can be blocked.
 * This is not enforced by the event system; attempts to block an unblockable
 * shuttle transit stage will simply be ignored.
 */
/datum/event_args/shuttle/proc/is_blockable()
	return FALSE

/datum/event_args/shuttle/Destroy()
	shuttle = null
	return ..()

/**
 * Shuttle docking event
 *
 * * Fired by shuttle controllers. This is not a low-level hook.
 *   The only exception is 'dock departed', 'dock undocked'; a shuttle will always
 *   trigger this when they move away, even if the controller doesn't exist, as
 *   aligned translation will tell the dock to do this.
 * * This will be fired on both the shuttle and dock sides.
 * * Direct shuttle translation calls will not call this.
 * * For things that reference each other / connect to a shuttle, please hook translation hooks to ensure disconnection.
 *   While these events *usually* have well-defined correlation to each other, nothing is promised
 *   as docking is a social construct but unironically.
 */
/datum/event_args/shuttle/dock
	/// controller ref
	var/datum/shuttle_controller/controller
	/// transit stage
	var/datum/shuttle_transit_stage/stage
	/// the dock in question
	var/obj/shuttle_dock/dock
	/// shuttle port being used, if any
	var/obj/shuttle_aligner/port/port

/datum/event_args/shuttle/dock/New(datum/shuttle/shuttle, datum/shuttle_transit_stage/stage, obj/shuttle_dock/dock, obj/shuttle_aligner/port/port)
	..()
	src.controller = shuttle.controller
	src.dock = dock
	src.shuttle_port = port
	src.stage = stage

/datum/event_args/shuttle/dock/Destroy()
	controller = null
	dock = null
	port = null
	stage = null
	return ..()

/**
 * Fired when a shuttle is attempting to perform traversal into the dock.
 * * Shuttles will be in a holding pattern, but inside the overmap entity, while this
 *   occurs.
 */
/datum/event_args/shuttle/dock/arriving

/**
 * Fired when a shuttle has traversed into the dock's bounding box to dock.
 * * Docking only occurs if docking codes are valid.
 */
/datum/event_args/shuttle/dock/arrived

/**
 * Fired when a shuttle is attempting to perform traversal out of the dock.
 * * Shuttles will not move until this happens. They will be in a holding pattern,
 *   inside the last overmap entity, while this occurs.
 */
/datum/event_args/shuttle/dock/departing
/**
 * Fired when a shuttle has traversed out of the dock's bounding box.
 * * Undocking only occurs if a shuttle was successfully docked in the first place.
 * * The backend promises that this will always be called if a shuttle was in the dock,
 *   even if the shuttle controller doesn't exist.
 */
/datum/event_args/shuttle/dock/departed

/**
 * Fired when a shuttle is attempting to dock.
 * * At this point, the shuttle already moved onto the dock. This is for stuff like airlocks.
 */
/datum/event_args/shuttle/dock/docking

/**
 * Fired when a shuttle is attempting to undock.
 */
/datum/event_args/shuttle/dock/undocking

/**
 * Fired when a shuttle has successfully docked.
 */
/datum/event_args/shuttle/dock/docked

/**
 * Fired when a shuttle has successfully undocked.
 */
/datum/event_args/shuttle/dock/undocked

/**
 * * Fired by shuttle controllers. This is not a low-level hook.
 * * This will be fired on both the shuttle and dock sides.
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
/datum/event_args/shuttle/traversal
	/// controller ref
	var/datum/shuttle_controller/controller
	/// transit stage
	var/datum/shuttle_transit_stage/stage

/datum/event_args/shuttle/traversal/New(datum/shuttle/shuttle, datum/shuttle_transit_stage/stage)
	..()
	src.controller = shuttle.controller
	src.stage = stage

/datum/event_args/shuttle/traversal/Destroy()
	controller = null
	stage = null
	return ..()

/datum/event_args/shuttle/traversal/web
	/// old node
	/// * nullable
	var/datum/shuttle_web_node/from_node
	/// new node
	var/datum/shuttle_web_node/to_node
	/// * nullable

/datum/event_args/shuttle/traversal/web/New(datum/shuttle/shuttle, datum/shuttle_transit_stage/stage, datum/shuttle_web_node/from_node, datum/shuttle_web_node/to_node)
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

/datum/event_args/shuttle/traversal/overmap/New(datum/shuttle/shuttle, datum/shuttle_transit_stage/stage, obj/overmap/entity/old_inside_entity, obj/overmap/entity/new_inside_entity)

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

/datum/event_args/shuttle/translation/is_blockable()
	return FALSE

/datum/event_args/shuttle/translation/pre_move
/datum/event_args/shuttle/translation/post_move
