/proc/createRandomGatewayLevel()
	if(awaydestinations.len) //crude, but it saves another var!
		return
#ifdef UNIT_TESTS
	return
#endif

	// Add your new gateway level to this list to add it into the spawn randomization.
	// Keep it alphabetical you heathen
	var/list/potentialGatewayLevels = list(
		/datum/map/gateway/carpfarm_140,
		/datum/map/gateway/listeningpost_140,
		/datum/map/gateway/snowfield_140,
		/datum/map/gateway/snow_outpost_140,
	)
	//TODO: repair /datum/map/gateway/zoo_197x305

	var/gateway_map = pick(potentialGatewayLevels)
	log_world("Gateway mission picked: [gateway_map]")
	SSmapping.loaded_station.lateload += gateway_map


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
