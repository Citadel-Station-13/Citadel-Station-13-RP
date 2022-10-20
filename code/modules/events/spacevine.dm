/var/global/spacevines_spawned = 0

/datum/event/spacevine
	announceWhen = 120

/datum/event/spacevine/start()
	spacevine_infestation()
	spacevines_spawned = 1

/datum/event/spacevine/announce()
	level_seven_announcement()
