/**
 * embodies a relative location from the center of the galaxy
 */
/datum/stellar_location
	/// name of location
	var/name = "???"
	/// real desc of location
	var/desc = "???"

	/// degrees clockwise of galactic "north"
	var/degrees = 0
	/// lightyears from center
	var/distance = 0
	/// degrees above/below galactic horizon
	var/elevation = 0

/datum/stellar_location/New(name = "???", desc = "???", degrees = 0, distance = 0, elevation = 0)
	src.name = name
	src.desc = desc
	src.degrees = degees
	src.distance = distance
	src.elevation = elevation

/datum/stellar_location/proc/distance_to(datum/stellar_location/other)
	#warn impl

/datum/stellar_location/proc/render_distance_to(datum/stellar_location/other, accuracy = 0.001)
	return "[round(distance_to, accuracy)] ly"
