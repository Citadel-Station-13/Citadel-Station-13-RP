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
 * get affected things
 */
/datum/announcer/proc/GetAffected()
	return location?.get_affected_atoms() || list()

/**
 * sends text in an announcement
 *
 * @params
 * - source - source name, e.g. central command
 * - name - e.g. research director's desk announcement, proximity alarm, etc
 * - message - message body. **supports HTML**
 * - affected - affected atoms. used to optimize.
 */
/datum/announcer/proc/SendText(source, name, message, list/affected = location?.get_affected_atoms())
	// no default implementation
	CRASH("Default announcer SendText called")

/**
 * sends sound in an announcement
 *
 * @params
 * - SB - soundbyte datum
 * - channel - channel to use. used for reservation/synchronization.
 * - affected - affected atoms. used to optimize.
 * - volume - volume override for sound.
 * - sound_environment - true/false - if true, allow playsound_local to use local environment.
 */
/datum/announcer/proc/SendSound(datum/soundbyte/SB, channel, list/affected = location?.get_affected_atoms(), volume, sound_environment = TRUE)
	// default implementation given since we only care for players
	var/sound/S = SB.instance_sound()
	for(var/mob/M in affected)
		M.playsound_local(turf_source = sound_environment? get_turf(M) : null, soundin = S, channel = channel, vol = volume, wait = FALSE)

