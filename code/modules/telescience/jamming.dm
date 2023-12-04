//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/bluespace_jamming
	/// attached atom
	var/atom/host
	/// for quick access: our level
	var/z_index
	/// jamming power; negative for boost instead of jam
	var/power = 0
	/// boost jamming power; this is pretty powerful
	var/boost = 0
	/// instability power; this is pretty powerful
	var/instability = 0
	/// inaccuracy power; this is pretty powerful
	var/inaccuracy = 0
	/// lensing power - how much this jamming field affects teleportation destinations. negative repels, positive attracts.
	var/lensing = 0
	/// maximum distance this still affects something
	var/max_distance = INFINITY

/datum/bluespace_jamming/New(atom/host)
	set_host(host)

/datum/bluespace_jamming/Destroy()
	set_host(null)
	return ..()

/datum/bluespace_jamming/proc/set_host(atom/what)
	unregister(host)
	host = what
	if(isnull(host))
		return
	register(host)

/datum/bluespace_jamming/proc/register(atom/host)
	RegisterSignal(host, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(z_changed))
	z_index = get_z(host)
	SStelesci.register_bluespace_jamming(src)

/datum/bluespace_jamming/proc/unregister(atom/host)
	UnregisterSignal(host, COMSIG_MOVABLE_Z_CHANGED)
	SStelesci.unregister_bluespace_jamming(src)
	z_index = null

/datum/bluespace_jamming/proc/z_changed(datum/source, old_z, new_z)
	z_index = new_z
	SStelesci.z_change_bluespace_jamming(src, old_z, new_z)

/**
 * Gets power coefficient to target
 */
/datum/bluespace_jamming/proc/coefficient(turf/target)
	return 0

/**
 * rebuild everything; call this after modifying *any* variables.
 */
/datum/bluespace_jamming/proc/rebuild()
	return

/**
 * flat, full-zlevel
 */
/datum/bluespace_jamming/flat

/datum/bluespace_jamming/flat/coefficient(turf/target)
	return 1

/**
 * exponential falloff
 */
/datum/bluespace_jamming/exponential
	/// distance between falloff begins
	var/grace = 5
	var/exponent = 1/2
	var/factor = 1

/datum/bluespace_jamming/exponential/coefficient(turf/target)
	var/turf/us = get_turf(host)
	var/dist = game_range_to(us, target)
	if(grace >= dist)
		return 1
	return exponent ** (dist * factor)

/**
 * linear falloff
 */
/datum/bluespace_jamming/linear
	/// distance between falloff begins
	var/grace = 5
	/// falloff per tile as multiplier. 0.05 = 5% falloff of total per tile.
	var/falloff = 0.15

/datum/bluespace_jamming/linear/coefficient(turf/target)
	var/turf/us = get_turf(host)
	var/dist = game_range_to(us, target)
	if(grace >= dist)
		return 1
	return max(0, 1 - ((dist - grace) * falloff))
