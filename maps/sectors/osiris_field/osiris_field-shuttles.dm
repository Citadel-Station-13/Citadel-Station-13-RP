//
// Hudge Vessel
//

//Colonial Liner
/datum/shuttle/autodock/overmap/osiris/colonial
	name = "Colonial Liner"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/osiris/colonial)
	docking_controller_tag = "colonial_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/osiris/colonial
	name = "Colonial Liner"
	desc = "A Liner made to carry people."
	scanner_name = "Colonial Liner"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Colonial Liner XXIII
[i]Transponder[/i]: Transmitting (CIV), Originialy registered as a Wreck since the Osiris Incident.
[b]Notice[/b]: It was destroyed in August 2568."}
	color = "#4b768f"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Colonial Liner"

/obj/machinery/computer/shuttle_control/explore/colonial
	name = "short jump console"
	shuttle_tag = "Colonial Liner"

/area/shuttle/osiris/colonial
	name = "Colonial Liner"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/colonial
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_colonial_start"
	shuttle_type = /datum/shuttle/autodock/overmap/osiris/colonial

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/colonial/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Colonial Liner"] = list(landmark_tag)
	. = ..()


//Battlestar
/datum/shuttle/autodock/overmap/osiris/battlestar
	name = "Wrecked Mercenary Battlecruiser Dedalios"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/osiris/battlestar)
	docking_controller_tag = "battlestar_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/osiris/battlestar
	name = "Wrecked Mercenary Battlecruiser Dedalios"
	desc = "A damaged military vessel."
	scanner_name = "Wrecked Mercenary Battlecruiser Dedalios"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Dedalios BS2004
[i]Transponder[/i]: Transmitting (CIV), Originialy registered as a Wreck since the Osiris Incident.
[b]Notice[/b]: It was destroyed in August 2568, when responding to a pirate incursion. It was operated by a small merc company, but they went out of business after the incident."}
	color = "#646464"
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Colonial Liner"

/obj/machinery/computer/shuttle_control/explore/battlestar
	name = "short jump console"
	shuttle_tag = "Wrecked Mercenary Battlecruiser Dedalios"

/area/shuttle/osiris/battlestar
	name = "Wrecked Mercenary Battlecruiser Dedalios"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/battlestar
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_osiris/battlestar_start"
	shuttle_type = /datum/shuttle/autodock/overmap/osiris/battlestar

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/battlestar/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Wrecked Mercenary Battlecruiser Dedalios"] = list(landmark_tag)
	. = ..()

//Cargoravan

/datum/shuttle/autodock/overmap/trade/cargoravana
	name = "Spacena Cargoravana Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/cargoravana)
	current_location = "tradeport_cargoravana"
	docking_controller_tag = "tradeport_cargoravana_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/cargoravana
	name = "Spacena Cargoravana Shuttle"
	desc = "A cheap shuttle made for people wanting to live and work in their shuttle."
	scanner_name = "Spacena Cargoravana Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Cargoravana Shuttle
[i]Transponder[/i]: Transmitting (CIV)
[b]Notice[/b]: Cargoravana shuttle, a few went missing during the Osiris Incident."}
	color = "#a2c118"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Cargoravana Shuttle"

/obj/machinery/computer/shuttle_control/explore/cargoravana
	name = "short jump console"
	shuttle_tag = "Spacena Cargoravana Shuttle"

/area/shuttle/cargoravana
	name = "Cargoravana"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/cargoravana
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_osiris/cargoravana_start"
	shuttle_type = /datum/shuttle/autodock/overmap/trade/cargoravana

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/cargoravana/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Spacena Cargoravana Shuttle"] = list(landmark_tag)
	. = ..()

//Salvager

/datum/shuttle/autodock/overmap/osiris/scavenger
	name = "FTV Adala"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/osiris/scavenger)
	docking_controller_tag = "scavenger_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/osiris/scavenger
	name = "FTV Adala"
	desc = "A legal Salvager vessel."
	scanner_name = "FTV Adala"
	scanner_desc = @{"[i]Registration[/i]: Free Trade Union - Guardian Salvager - Adala - FTV 003
[i]Class[/i]: Mega-Tug + Salvager trailer
[i]Transponder[/i]: Transmitting (CIV), Free trade Union shuttle, Guardian Salvager subsidiary.
[b]Notice[/b]: A Guardian Salvager company vessel, operated by the FTU. Able to carry small to big one decker vessels. Their scavenging permit as been confirm by CC and the local governement."}
	color = "#f8e300"
	fore_dir = EAST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "FTV Adala"

/obj/machinery/computer/shuttle_control/explore/scavenger
	name = "short jump console"
	shuttle_tag = "FTV Adala"

/area/shuttle/osiris/scavenger
	name = "FTV Adala"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/scavenger
	name = "Tradeport"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "tradeport/scavenger_start"
	shuttle_type = /datum/shuttle/autodock/overmap/osiris/scavenger

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/scavenger/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["FTV Adala"] = list(landmark_tag)
	. = ..()

//UMS

/datum/shuttle/autodock/overmap/trade/scavengerutilitymicro
	name = "Scavenging Utility Micro Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/scavengerutilitymicro)
	current_location = "tradeport_scavengerutilitymicro"
	docking_controller_tag = "tradeport_scavengerutilitymicro_docker"
	fuel_consumption = 1
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/scavengerutilitymicro
	name = "Scavenging Utility Micro Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	color = "#ffee6e"
	fore_dir = WEST
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Scavenging Utility Micro Shuttle"

/obj/machinery/computer/shuttle_control/explore/scavengerutilitymicro
	name = "short jump console"
	shuttle_tag = "Scavenging Utility Micro Shuttle"

/area/shuttle/scavengerutilitymicro
	name = "SUMS"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/scavengerutilitymicro
	name = "Tradeport"
	base_area = /area/space
	base_turf = /turf/space
	shuttle_type = /datum/shuttle/autodock/overmap/trade/scavengerutilitymicro

/obj/effect/shuttle_landmark/shuttle_initializer/osiris/scavengerutilitymicro/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints[name = "Scavenging Utility Micro Shuttle"] = list(landmark_tag)
	. = ..()
