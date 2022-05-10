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

/**
 * sends text in an announcement
 *
 * @params
 * - source - source name, e.g. central command
 * - name - e.g. research director's desk announcement, proximity alarm, etc
 * - message - message body. **supports HTML**
 */
/datum/announcer/proc/SendText(source, name, message)

/**
 * sends sound in an announcement
 *
 * @params
 * - SB - soundbyte datum, id, or alias. it is ensured within the announcer that the soundbyte is synchronized.
 */
/datum/announcer/proc/SendSound(datum/soundbyte/SB)

#warn imp
