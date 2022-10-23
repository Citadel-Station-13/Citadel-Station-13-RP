var/list/datum/spawnpoint/spawntypes = list()

/proc/populate_spawn_points()
	spawntypes = list()
	for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
		var/datum/spawnpoint/S = new type()
		spawntypes[S.display_name] = S

// pending removal
/datum/spawnpoint
	// join method
	var/method
	var/display_name //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null
	var/announce_channel = "Common"

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

/datum/spawnpoint/proc/get_spawn_position(faction)
	return SSjob.GetLatejoinSpawnpoint(faction = faction, method = method)

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	method = LATEJOIN_METHOD_ARRIVALS_SHUTTLE

/datum/spawnpoint/gateway
	display_name = "Gateway"
	method = LATEJOIN_METHOD_GATEWAY

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	disallow_job = list("Cyborg")
	method = LATEJOIN_METHOD_CRYOGENIC_STORAGE

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	restrict_job = list("Cyborg")
	method = LATEJOIN_METHOD_ROBOT_STORAGE
