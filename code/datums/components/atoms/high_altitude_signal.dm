//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// TODO: can this be combined with the gps signal system? it's silly to have both.

GLOBAL_LIST_EMPTY(high_altitude_signals)

/**
 * handles world size updates
 */
/proc/assert_high_altitude_signal_list()
	if(GLOB.high_altitude_signals.len > world.maxz)
		CRASH("How? We just tried to shrink the GPS list!")
	GLOB.high_altitude_signals.len = world.maxz
	for(var/i in 1 to GLOB.high_altitude_signals.len)
		if(!islist(GLOB.high_altitude_signals[i]))
			GLOB.high_altitude_signals[i] = list()

/**
 * for when admins do an oopsy woopsy and fuck up royally.
 */
/proc/rebuild_high_altitude_signals()
	GLOB.high_altitude_signals = list()
	GLOB.high_altitude_signals.len = world.maxz
	for(var/i in 1 to GLOB.high_altitude_signals.len)
		GLOB.high_altitude_signals[i] = list()
	// the forbidden `in world`
	for(var/datum/component/high_altitude_signal/sig in world)
		sig.registered = FALSE
		sig.register_transmitter()

/**
 * high altitude signal components
 *
 * controlling it unfortunately will require GetComponents for now,
 * because it's sort of pointless to add signals for the sole purpose of
 * controlling them.
 *
 * sorry, not sorry.
 */
/datum/component/high_altitude_signal
	dupe_mode = COMPONENT_DUPE_ALLOWED
	registered_type = /datum/component/high_altitude_signal
	/// our visible name
	var/visible_name
	/// registered in list?
	var/registered = FALSE
	/// Callback to check if we're active
	/// * Invoked with (src)
	/// * Returns TRUE / FALSE
	var/datum/callback/on_is_active
	/// Callback to get our effective turf
	/// * Invoked with (src)
	/// * Allowed to return null.
	var/datum/callback/on_get_effective_turf
	/// require high altitude visibility of the **effective** turf
	var/require_effective_turf_high_altitude_visibility = FALSE

/datum/component/high_altitude_signal/Initialize(visible_name = "high altitude signal")
	if(!isatom(parent) || ((. = ..()) == COMPONENT_INCOMPATIBLE))
		return COMPONENT_INCOMPATIBLE
	src.gps_tag = gps_tag

/datum/component/high_altitude_signal/RegisterWithParent()
	. = ..()
	if(ismovable(parent))
		RegisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_transit))
	register_transmitter()

/datum/component/high_altitude_signal/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED)
	unregister_transmitter()

/datum/component/high_altitude_signal/proc/on_z_transit(datum/source, old_z, new_z)
	SIGNAL_HANDLER
	update_transmitter(old_z, new_z)

/datum/component/high_altitude_signal/proc/register_transmitter()
	var/atom/A = parent
	var/turf/T = get_turf(A)
	if(!T)
		return
	ASSERT(!registered)
	GLOB.high_altitude_signals[T.z] += src
	registered = TRUE

/datum/component/high_altitude_signal/proc/unregister_transmitter()
	var/atom/A = parent
	var/turf/T = get_turf(A)
	if(!T)
		return
	ASSERT(registered)
	GLOB.high_altitude_signals[T.z] -= src
	registered = FALSE

/datum/component/high_altitude_signal/proc/update_transmitter(old_z, new_z)
	if(old_z)
		GLOB.high_altitude_signals[old_z] -= src
	if(new_z)
		GLOB.high_altitude_signals[new_z] += src

/datum/component/high_altitude_signal/proc/set_visible_name(new_name)
	visible_name = new_name

/datum/component/high_altitude_signal/proc/is_active()
	SHOULD_NOT_SLEEP(TRUE)
	return on_is_active ? on_is_active.invoke_no_sleep(src) : TRUE

/datum/component/high_altitude_signal/proc/get_effective_turf()
	var/turf/effective = on_get_effective_turf ? on_get_effective_turf.invoke_no_sleep(src) : get_turf(parent)
	if(!effective)
		return null
	if(require_effective_turf_high_altitude_visibility && !SSmap_sectors.is_turf_visible_from_high_altitude(effective))
		return null
	return effective
