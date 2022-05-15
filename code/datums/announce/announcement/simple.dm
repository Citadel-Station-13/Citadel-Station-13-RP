/**
 * simple announcement proc
 * use for when you don't need to edit more variables in the announcement.
 *
 * @params
 * - announcer - announcer to use
 * - source - message source (not all announcers support this)
 * - name - name of report
 * - message - message body. supports HTML.
 * - sound_preamble - preamble sound, if any - either a sound datum, soundbyte, or soundbyte alias
 * - sound_main - ditto
 */
/proc/simple_announcement(datum/announcer/announcer, source = "Installation Annoucement", name = "General Alert", message = "Test message, please ignore.", sound_preamble = /datum/soundbyte/announcer/preamble, sound_main = /datum/soundbyte/announcer/notice)
	var/datum/announcement/simple/A = new(source, name, message, sound_preamble, sound_main)
	A.Announce(announcer)
	qdel(A)

/**
 * simple one-off announcement
 * supports:
 * - source - e.g. "Central Command Update", "ATC Proximity Alert", etc. Not all announcers support this.
 * - name - e.g. "Research Director's Desk", "Bridge Announcement", etc
 * - message - etc. "Unidentified ship detected"
 * - preamble soundbyte
 * - announcement sonud
 */
/datum/announcement/simple
	/// announcer source - e.g. "Central Command Update", "Facility Update", "Facility PA", etc
	var/source
	/// announcer topic - e.g. "Research Director's Desk", "Bridge Announcement", "ATC Proximity Alert"
	var/name
	/// main message - e.g. "Unidentified ship detected", etc. **Should support HTML.**
	var/message
	/// preamble soundbyte - **must** have "length" argument if provided - can be typepath - message delayed until after this, if supported
	var/datum/soundbyte/sound_preamble
	/// main soundbyte - synced to message
	var/datum/soundbyte/sound_main
	/// volume to play sounds at, if any
	var/sound_volume
	/// enable sound environments?
	var/sound_allow_environment = TRUE

/datum/announcement/simple/New(source, name, message, preamble, main)
	. = ..()
	src.source = source
	src.name = name
	src.message = message
	src.sound_preamble = SSsounds.fetch_soundbyte(preamble)
	src.sound_main = SSsounds.fetch_soundbyte(main)

/datum/announcement/simple/Destroy()
	sound_preamble = null
	sound_main = null
	return ..()

/datum/announcement/simple/Run(datum/announcer/announcer)
	var/delay = (istype(sound_preamble) && sound_preamble.length) || 0
	// if we aren't using soundbytes, reserve a channel for 15 seconds
	var/channel = ReserveSoundChannelFor(delay || (15 SECONDS))
	// get affected first so the announcer doesn't recheck 3 times
	var/list/affected = announcer.GetAffected()
	if(sound_preamble)
		announcer.SendSound(sound_preamble, channel, affected, sound_volume, sound_allow_environment)
	if(sound_main)
		addtimer(CALLBACK(announcer, /datum/announcer/proc/SendSound, sound_main, channel, affected, sound_volume, sound_allow_environment), delay)
	addtimer(CALLBACK(announcer, /datum/announcer/proc/SendText, source, name, message, affected), delay)
