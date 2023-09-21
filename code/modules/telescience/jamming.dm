/datum/bluespace_jamming
	/// attached atom
	var/atom/host
	/// for quick access: our level
	var/z_index
	/// jamming power; negative for boost instead of jam
	var/power = 0
	/// boost jamming power; this is pretty powerful
	var/boost = 0
	/// 

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
	#warn impl

/datum/bluespace_jamming/proc/unregister(atom/host)
	#warn impl

/datum/bluespace_jamming/proc/z_changed(datum/source, old_z, new_z)
	#warn impl

/**
 * Gets power coefficient to target
 */
/datum/bluespace_jamming/proc/coefficient(turf/target)
	return 0

/**
 * flat, full-zlevel
 */
/datum/bluespace_jamming/flat

/datum/bluespace_jamming/flat/coefficient(turf/target)
	return 1

/**
 * quadratic falloff
 */
/datum/bluespace_jamming/quadratic

/datum/bluespace_jamming/quadratic/coefficient(turf/target)
	var/turf/us = get_turf(host)
	return (1/2) ** get_dist(us, target)

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
	var/dist = get_dist(us, target)
	if(grace >= dist)
		return 1
	return max(0, 1 - ((dist - grace) * falloff))
