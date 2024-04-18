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
	/// our globally persistent-unique identifier string
	var/id

	//* Composition
	/// our shuttle controller
	var/datum/shuttle_controller/controller
	/// our physical shuttle object
	var/obj/shuttle_anchor/anchor
	/// our physical shuttle port objects
	var/list/obj/shuttle_port/ports
	/// the areas in our shuttle, associated to a truthy value
	var/list/area/shuttle/areas

	//* Docking
	/// where we are docked, if any
	var/obj/shuttle_dock/docked
	/// in-progress dock/undock operation
	var/datum/event_args/shuttle/dock/currently_docking
	/// in-progress move operation
	var/datum/event_args/shuttle/movement/currently_moving
	/// the port we're using
	var/obj/shuttle_port/docked_via_port

	//* Movement - Ephemeral / In-Move
	/// current direction of motion, used to calculate things like visuals and roadkill
	var/translating_physics_direction
	/// [x or y] cache (perpendicular to considered movement direction)
	/// of 'first non shuttle turf'
	/// used to cache calculations when ramming things out of our way
	/// if lookup fails, associate to FALSE, not null
	/// this is an indexed list, with 1 to n for n width shuttle from left to right
	/// with the relative perpsective of its physics direction.
	var/list/translating_pepsi_man_lookup_cache
	/// [x or y] backup cache (perpendicular to considered movement direction)
	/// of 'closest clear non shuttle turf'
	/// used when we can't find a proper lookup because it's blocked and need somewhere
	/// to kick people to anyways
	/// this is an indexed list, with 1 to n for n width shuttle from left to right
	/// with the relative perpsective of its physics direction.
	var/list/translating_garbage_disposal_lookup_cache
	/// queued throws
	var/list/translating_needs_to_be_thrown_away
	/// queued objs needing to be damaged
	var/list/translating_needs_to_be_damaged

	//* Hooks
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	//* Identity
	/// player-facing name
	var/display_name

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

//* Initialization *//

/**
 * Called after all areas are made and all turfs are there,
 * but before atoms initialization.
 *
 * Used to auto-register everything
 *
 * **Extremely dangerous proc. Don't call it unless you know what you're doing.**
 */
/datum/shuttle/proc/before_bounds_init(datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/area/shuttle/area_cache = list()
	areas = list()
	ports = list()
	anchor = null
	// we do our own calculations always, because we cannot assume the map template is trimmed properly.
	var/bottomleft_x = INFINITY
	var/bottomleft_y = INFINITY
	var/topright_x = -INFINITY
	var/topright_y = -INFINITY
	// scan turfs & collect
	for(var/turf/scanning in from_reservation.get_unordered_turfs())
		if(!istype(scanning.loc, /area/shuttle))
			continue
		if(!area_cache[scanning.loc])
			var/area/shuttle/initializing = scanning.loc
			area_cache[scanning.loc] = initializing
			initializing.before_bounds_initializing(src, from_reservation, from_template)
		bottomleft_x = min(bottomleft_x, scanning.x)
		bottomleft_y = min(bottomleft_y, scanning.y)
		topright_x = max(topright_x, scanning.x)
		topright_y = max(topright_y, scanning.y)
		// make superstructure
		new /obj/shuttle_structure(scanning)
		// todo: probably make sure baseturfs are fine
		var/static/list/cared_about_typecache = typecacheof(list(
			/obj/shuttle_anchor,
			/obj/shuttle_port,
		))
		for(var/atom/movable/AM as anything in scanning.contents)
			if(!cared_about_typecache[AM.type])
				continue
			if(istype(AM, /obj/shuttle_anchor))
				if(!isnull(anchor))
					stack_trace("duplicate anchor during init scan")
				anchor = AM
			else if(istype(AM, /obj/shuttle_port))
				ports += AM
	// collect areas
	for(var/area/scanning in area_cache)
		areas[scanning] = TRUE
	// if we don't have an anchor, make one
	if(isnull(anchor))
		var/turf/center = from_reservation.get_approximately_center_turf()
		anchor = new(center)
	anchor.calculate_bounds(bottomleft_x, bottomleft_y, topright_x, topright_y, from_template.facing_dir)
	for(var/obj/shuttle_port/port in ports)
		port.before_bounds_initializing(src, from_reservation, from_template)
	anchor.before_bounds_initializing(src, from_reservation, from_template)
	#warn hook

/**
 * Called after the bounds have initialized their atoms/areas
 *
 * **Extremely dangerous proc. Don't call / override it unless you know what you're doing.**
 */
/datum/shuttle/proc/after_bounds_init(datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	return
	#warn hook

//* Bounding Box *//

/**
 * returns with the current direction of the shuttle
 */
/datum/shuttle/proc/aabb_ordered_turfs_here()
	return anchor.aabb_ordered_turfs_here()

/datum/shuttle/proc/aabb_ordered_turfs_at(turf/anchor, direction)
	return src.anchor.aabb_ordered_turfs_at(anchor, direction)

/datum/shuttle/proc/shuttle_turfs_here()
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_here())

/datum/shuttle/proc/shuttle_turfs_at(turf/anchor, direction)
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_at(anchor, direction))

//* Docking - Control *//

/**
 * checks if have docking codes for a dock
 */
/datum/shuttle/proc/has_codes_for(obj/shuttle_dock/dock)
	return controller?.has_codes_for(dock)

//* Docking - Action Helpers *//


/datum/shuttle/proc/

#warn AAAAAAAAAAAAAAAAAAAAAAAAA

//* Docking - Handling *//

/**
 * handles when an overlap occurs
 *
 * overlap always occurs on any turfs in the way
 * overlap always occurs on any movables that are non abstract and considered a game object
 */
/datum/shuttle/proc/overlap_handler(atom/entity, turf/from_turf, turf/to_turf)
	#warn impl

//* Docking - Backend; Don't mess with these. *//

/**
 * immediate shuttle move to a turf
 *
 * all translations must use this.
 *
 * optionally, align a port with that turf instead of aligning our anchor to that turf
 *
 * aligned = the port / anchor (if no port specified) is on the turf, and faces the same way,
 * respecting all necessary offsets.
 * ports should generally be centered.
 */
/datum/shuttle/proc/unsafe_aligned_translation(turf/move_to, direction, obj/shuttle_port/align_with_port, list/use_before_turfs, list/use_after_turfs)
	// todo: more physics directions
	translating_physics_direction = direction
	// set up translating process caches
	var/overall_width = anchor.overall_width(direction)
	translating_pepsi_man_lookup_cache = new /list(overall_width)
	translating_garbage_disposal_lookup_cache = new /list(overall_width)
	translating_needs_to_be_thrown_away = list()
	translating_needs_to_be_damaged = list()
	if(isnull(use_before_turfs))
		// assume both are empty
		// get aabb boxes
		use_before_turfs = aabb_ordered_turfs_here()
		use_after_turfs = align_with_port? align_with_port.aabb_ordered_turfs_at(move_to, direction) : anchor.aabb_ordered_turfs_at(move_to, direction)
		// filter for less work
		SSgrids.null_filter_ordered_turfs_in_place_via_area(areas, use_before_turfs, use_after_turfs)
	#warn move anchor first
	#warn move ports
	// prepped, move.
	SSgrids.translate(
		use_before_turfs,
		use_after_turfs,
		anchor.dir,
		direction,
		NONE,
		/turf/baseturf_skipover/shuttle,
		docked.base_area_instance(),
		null,
		null,
		CALLBACK(src, PROC_REF(overlap_handler)),
	)
	#warn throw shit and damage shit but also throw shit after damaging shit
	// clear caches
	translating_physics_direction = null
	translating_pepsi_man_lookup_cache = null
	translating_garbage_disposal_lookup_cache = null
	translating_needs_to_be_thrown_away = null
	translating_needs_to_be_damaged = null

//* Docking - Bounding Checks *//

/**
 * check bounding boxes
 *
 * @params
 * * dock - dock to dock to
 * * port - port to align with dock; if null, we do a centered docking
 * * hard_checks_only - only check hard faults, allow trampling anything else.
 * * use_ordered_turfs - check these ordered turfs; you usually use this when about to translate.
 *
 * @return SHUTTLE_DOCKING_BOUNDING_X result define
 */
/datum/shuttle/proc/check_bounding(obj/shuttle_dock/dock, obj/shuttle_port/with_port, hard_checks_only, list/use_ordered_turfs)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/ordered_turfs
	#warn check for overlap with zlevel borders - the last 3 turfs should be reserved
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
/datum/shuttle/proc/check_bounding_overlap(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs)
	SHOULD_NOT_OVERRIDE(TRUE)
	for(var/turf/T in ordered_turfs)
		if(istype(T.loc, /area/shuttle))
			return FALSE
	return TRUE

/**
 * soft bounding check - override this for your own checks.
 *
 * @return FALSE if trampling sometihng we don't want to trample
 */
/datum/shuttle/proc/check_bounding_trample(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs)
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
	return SSshuttle.send_shuttle_to_transit(src, force, immediate)
