/**
 * super simplified waves
 * no falloff
 * just -1 range per tick from a center turf
 *
 * does **not** set acting_turfs.
 */
/datum/automata/scan
	/// range
	var/radius
	/// current
	var/current_radius

/datum/automata/scan/setup_auto(turf/T, radius, speed)
	src.speed = speed
	src.radius = radius
	src.current = 0

/datum/automata/scan/tick()
	#warn impl

/datum/automata/scan/proc/act(turf/T, dist)
	return
