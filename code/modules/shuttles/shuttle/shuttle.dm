//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * # Shuttles
 *
 * Core datum for shuttles.
 *
 * ## Controllers
 *
 * All shuttle behaviors are now in controllers whenever possible. The base datum just handles the actual shuttle itself.
 * Moving to transit and staying in transit? That's a controller thing. Temporary dynamic transit? That's a controller thing, too.
 *
 * todo: nestable-shuttle support ? e.g. transport ship on a shuttle ; this is not optimal for performance but sure is cool
 * todo: multi-z shuttles; is this even possible? very long term.
 * todo: areas is a shit system. this is probably not fixable, because how else would we do bounding boxes?
 * todo: it would sure be nice to be able to dynamically expand shuttles in-game though; probably a bad idea too.
 * todo: serialize/deserialize, but should it be on this side or the map tempalte side? we want save/loadable.
 */
/datum/shuttle
	//* Intrinsics
	/// real / code name
	var/name = "Unnamed Shuttle"
	/// are we mid-delete? controls whether we, and our components are immune to deletion.
	var/being_deleted = FALSE

	//* Composition
	/// our shuttle controller
	var/datum/shuttle_controller/controller
	/// our physical shuttle object
	var/obj/shuttle_anchor/master/anchor
	/// our physical shuttle port objects
	var/list/obj/shuttle_port/ports
	/// the areas in our shuttle
	var/list/areas

	//* Docking
	/// where we are docked, if any
	var/obj/shuttle_dock/docked
	/// in-progress dock/undock operation
	var/datum/event_args/shuttle/dock/currently_docking
	/// in-progress move operation
	var/datum/event_args/shuttle/movement/currently_moving
	/// the port we're using
	var/obj/shuttle_port/docked_via_port

	//* Hooks
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	//* Preview
	/// lower-left aligned preview overlay; used for shuttle dockers and similar
	var/mutable_appearance/preview_overlay

	//* Structure
	/// if set, we generate a ceiling above the shuttle of this type, on the bottom of the turf stack.
	var/ceiling_type = /turf/simulated/shuttle_ceiling

	//* Transit
	/// Shuttle is in transit
	var/in_transit = FALSE
	/// Current transit reservation
	var/datum/turf_reservation/in_transit_reservation
	/// Current transit dock
	var/obj/shuttle_dock/ephemeral/transit/in_transit_dock

	//* legacy stuff
	// todo: this should be a default, and engine/takeoff type (?) can override
	var/legacy_sound_takeoff = 'sound/effects/shuttles/shuttle_takeoff.ogg'
	var/legacy_sound_landing = 'sound/effects/shuttles/shuttle_landing.ogg'
	var/legacy_takeoff_knockdown = 1.5 SECONDS

#warn impl all

/**
 * Called after all areas are made and all turfs are there, etc etc
 * Used to auto-register everything
 */
/datum/shuttle/proc/initialize(datum/turf_reservation/loading_reservation)
	#warn impl

//* Bounding Box *//

/**
 * returns with the current direction of the shuttle
 */
/datum/shuttle/proc/bounding_ordered_turfs()
	return anchor.ordered_turfs_here()

//* Docking & Movement *//

/**
 * this only fails if we would interseect another shuttle. otherwise, this will trample anything in the way.
 *
 * @params
 * * dock - dock to dock to
 * * port - port to align with dock; if null, we do a centered docking
 *
 * @return TRUE / FALSE
 */
/datum/shuttle/proc/immediate_move(obj/shuttle_dock/dock, obj/shuttle_port/with_port)
	#warn impl

/**
 * check bounding boxes
 *
 * @params
 * * dock - dock to dock to
 * * port - port to align with dock; if null, we do a centered docking
 * * hard_checks_only - only check hard faults, allow trampling anything else.
 *
 * @return SHUTTLE_DOCKING_BOUNDING_X result define
 */
/datum/shuttle/proc/check_bounding(obj/shuttle_dock/dock, obj/shuttle_port/with_port, hard_checks_only)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/ordered_turfs
	var/list/heuristic_spots
	#warn check for overlap with zlevel borders - the lsat 3 turfs should be reserved
	#warn impl ordered turfs
	if(!check_bounding_overlap(dock, with_port, ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_HARD_FAULT
	if(hard_checks_only)
		return SHUTTLE_DOCKING_BOUNDING_CLEAR
	if(!check_bounding_trample(dock, with_port, ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	return SHUTTLE_DOCKING_BOUNDING_CLEAR

/**
 * hard bounding check - do not override this.
 *
 * @return FALSE if overlapping
 */
/datum/shuttle/proc/check_bounding_overlap(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs, list/heuristic_spots)
	SHOULD_NOT_OVERRIDE(TRUE)
	for(var/turf/T in heuristic_spots)
		if(istype(T.loc, /area/shuttle))
			return FALSE
	for(var/turf/T in ordered_turfs)
		if(istype(T.loc, /area/shuttle))
			return FALSE
	return TRUE

/**
 * soft bounding check - override this for your own checks.
 *
 * @return FALSE if trampling sometihng we don't want to trample
 */
/datum/shuttle/proc/check_bounding_trample(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs, list/heuristic_spots)
	#warn impl

//* Previews *//

/**
 * Get preview outline for docking and others.
 */
/datum/shuttle/proc/get_preview(regenerate)
	if(!isnull(preview_overlay) && !regenerate)
		return preview_overlay
	preview_overlay = new /mutable_appearance
	#warn impl

//* Transit

/**
 * @params
 * * force - hard force, ram everything out of the way on the destination side if needed
 * * immediate - blow past all docking procedures, do not block on anything IC fluff or otherwise
 */
/datum/shuttle/proc/move_to_transit(force = FALSE, immediate = FALSE)
	#warn impl
