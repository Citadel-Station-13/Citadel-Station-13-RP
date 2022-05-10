/**
 * announcement datums
 * encapsulates data needed to make an announcement
 */
/datum/announcement
	/// announcer used
	var/datum/announcer/announcer

/datum/announcement/New(datum/announcer/announcer)
	src.announcer = announcer

/datum/announcement/proc/Announce()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	ASSERT(announcer)
	Run()

/datum/announcement/proc/Run()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	CRASH("Base /datum/announcement Run() called.")
