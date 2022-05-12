/datum/announce_location/global_announcement
	name = "Global Announcement"
	desc = "The entire server/all players can see this."

/datum/announce_location/global_announcement/get_affected_levels()
	. = list()
	for(var/z in 1 to world.maxz)
		. += z
