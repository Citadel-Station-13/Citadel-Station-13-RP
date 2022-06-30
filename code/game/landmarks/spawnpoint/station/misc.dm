/obj/landmark/spawnpoint/latejoin/station
	faction = JOB_FACTION_STATION
	method = LATEJOIN_METHOD_DEFAULT

/obj/landmark/spawnpoint/latejoin/station/arrivals_shuttle
	method = LATEJOIN_METHOD_ARRIVALS_SHUTTLE
	announce_template = "%NAME%, %JOB%, has arrived on the installation."

/obj/landmark/spawnpoint/latejoin/station/arrivals_shuttle/OnSpawn(mob/M, client/C)
	. = ..()
	// var/obj/structure/chair/_C = locate() in GetSpawnLoc()
	// if(C && !length(_C.buckled_mobs))
	// 	_C.buckle_mob(M, FALSE, FALSE)
	// if(SSshuttle.arrivals.mode == SHUTTLE_CALL)
	// 	var/atom/movable/screen/splash/Spl = new(C, TRUE)
	// 	Spl.Fade(TRUE)
	// 	M.playsound_local(get_turf(M), 'sound/voice/ApproachingTG.ogg', 25)


/obj/landmark/spawnpoint/latejoin/station/shuttle_dock
	method = LATEJOIN_METHOD_SHUTTLE_DOCK
	announce_template = "%NAME%, %JOB%, has arrived by shuttle."

/obj/landmark/spawnpoint/latejoin/station/gateway
	method = LATEJOIN_METHOD_GATEWAY
	announce_template = "%NAME%, %JOB%, has arrived by short-range teleport."

/obj/landmark/spawnpoint/latejoin/station/elevator
	method = LATEJOIN_METHOD_DEFAULT
	announce_template = "%NAME%, %JOB%, has arrived from the residential district."

/obj/landmark/spawnpoint/latejoin/station/cryogenics
	method = LATEJOIN_METHOD_CRYOGENIC_STORAGE
	announce_template = "%NAME%, %JOB%, has complated cryogenic revival."

/obj/landmark/spawnpoint/latejoin/station/cyborg
	method = LATEJOIN_METHOD_ROBOT_STORAGE
	announce_template = "%NAME% has been retrieved from robotics storage."

/obj/landmark/spawnpoint/latejoin/station/tram
	method = LATEJOIN_METHOD_TRAM
	announce_template = "%NAME%, %JOB%, has arrived on the tram."

/obj/landmark/spawnpoint/overflow/station
	faction = JOB_FACTION_STATION
