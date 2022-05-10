/proc/simple_announcement(datum/announcer/announcer, source = "Installation Annoucement", name = "General Alert", message = "Test message, please ignore.", sound_preamble, sound_main)
	#warn defaults
	var/datum/announcement/simple/A = new(announcer, source, name, message, sound_preamble, sound_main)
	A.Announce()

/**
 * simple one-off announcement
 * supports:
 * - source
 * - name
 * - message
 * - preamble soundbyte
 * - announcement sonud
 */
/datum/announcement/simple
	/// announcer source - e.g. "Facility PA"
	var/source
	/// announcer topic - e.g. "Research Director's Desk", "Bridge Announcement", "ATC Proximity Alert"
	var/name
	/// main message - e.g. "Unidentified ship detected", etc. **Should support HTML.**
	var/message
	/// preamble soundbyte - **must** have "length" argument if provided - can be typepath - message delayed until after this, if supported
	var/datum/soundbyte/sound_preamble
	/// main soundbyte - synced to message
	var/datum/soundbyte/sound_main

/datum/announcement/simple/New(datum/announcer/announcer, source, name, message, preamble, main)
	. = ..(announcer)
	src.source = source
	src.name = name
	src.message = message
	src.sound_preamble = SSsounds.fetch_soundbyte(preamble)
	src.sound_main = SSsounds.fetch_soundbyte(main)

/datum/announcement/simple/Run()
	var/delay = (istype(sound_preamble) && sound_preamble.length) || 0
	if(sound_preamble)
		announcer.
	addtimer
	if(delay)

	else

	#warn impl
