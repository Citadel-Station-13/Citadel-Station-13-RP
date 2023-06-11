/datum/bluespace_jamming
	/// attached atom
	var/atom/host
	/// for quick access: our level
	var/z_index
	/// jamming power
	var/power = 0
	/// boost jamming power
	var/boost = 0
	/// actually boosts, instead of jams
	var/uno_reverse = FALSE

#warn impl

/datum/bluespace_jamming/proc/signal_coefficient(datum/bluespace_signal/signal)
	var/turf/them = get_turf(signal.attached)
	return coefficient(them)

/datum/bluespace_jamming/proc/coefficient(turf/target)
	return 0

/**
 * flat, full-zlevel
 */
/datum/bluespace_jamming/flat

/datum/bluespace_jamming/flat/signal_coefficient(datum/bluespace_signal/signal)
	return 1

/datum/bluespace_jamming/flat/coefficient(turf/target)
	return 1

/**
 * quadratic falloff
 */
/datum/bluespace_jamming/quadratic

/datum/bluespace_jamming/quadratic/coefficient(turf/target)
	var/turf/us = get_turf(src)
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
	var/turf/us = get_turf(src)
	var/dist = get_dist(us, target)
	if(grace >= dist)
		return 1
	return max(0, 1 - ((dist - grace) * falloff))
