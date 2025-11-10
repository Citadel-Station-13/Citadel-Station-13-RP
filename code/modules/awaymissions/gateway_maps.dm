// todo: overengineer this instead of having it be one proc
/proc/createRandomGatewayLevel()
	if(awaydestinations.len) //crude, but it saves another var!
		return
#ifdef UNIT_TESTS
	return
#endif

	if(!SSmapping.loaded_station.conf_load_gateway_mission)
		return

	// Add your new gateway level to this list to add it into the spawn randomization.
	// Keep it alphabetical you heathen
	var/list/potentialGatewayLevels = subtypesof_non_abstract(/datum/map/gateway)
	for(var/datum/map/gateway/casted as anything in potentialGatewayLevels)
		if(casted.width > world.maxx)
			potentialGatewayLevels -= casted
		if(casted.height > world.maxy)
			potentialGatewayLevels -= casted

	//TODO: repair /datum/map/gateway/zoo_197x305

	var/gateway_map = SAFEPICK(potentialGatewayLevels)
	if(!gateway_map)
		log_world("No valid gateway missions found. (all either too big, or skipped)")
		return

	log_world("Gateway mission picked: [gateway_map]")
	LAZYADD(SSmapping.loaded_station.lateload, gateway_map)

// This landmark sets spawn locations for Gateway missions before the away gateway is recalibrated by explorers.
/obj/landmark/gateway_scatter
	name = "uncalibrated gateway destination"
/obj/landmark/gateway_scatter/Initialize(mapload)
	. = ..()
	awaydestinations += src

/obj/landmark/event_scatter
	name = "uncalibrated gateway destination"
/obj/landmark/event_scatter/Initialize(mapload)
	. = ..()
	eventdestinations += src
