/**
 * announcement datums
 * encapsulates data needed to make an announcement
 */
/datum/announcement

/datum/announcement/New()

/datum/announcement/proc/Announce(datum/announcer/announcer)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	Run(announcer)

/datum/announcement/proc/Run(datum/announcer/announcer)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	CRASH("Base /datum/announcement Run() called.")

/**
 * automatically reserves a channel for x time
 */
/datum/announcement/proc/ReserveSoundChannelFor(time = 0)
	. = SSsounds.reserve_sound_channel_datumless()
	if(!.)
		CRASH("Failed to reserve channel.")
	addtimer(CALLBACK(SSsounds, /datum/controller/subsystem/sounds/proc/free_sound_channel, .), time)
