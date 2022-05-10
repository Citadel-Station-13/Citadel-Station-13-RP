/**
 * announcer datums:
 * handles processing /datum/announcement's
 */
/datum/announcer
	/// our name
	var/name = "Generic Announcer"
	/// our desc
	var/desc = "What is this?"
	/// our location
	var/datum/announce_location/location

/datum/announcer/New(datum/announce_location/location)
	src.location = location

#warn impl
