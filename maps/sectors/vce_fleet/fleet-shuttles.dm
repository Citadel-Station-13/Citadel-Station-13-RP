//HERE COME THE SHUTTLES


// Entdecker Trade Shuttle. This is a Beruang replacement. Looks a bit like the NX 01 Enterprise.

/datum/shuttle/autodock/overmap/fleet/trade
	name = "Entdecker Trade Ship"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/fleet/trade_ship/cockpit, /area/shuttle/fleet/trade_ship/general)
	current_location = "fleet_trade_1"
	docking_controller_tag = "fleet_trade_docker"
	fuel_consumption = 5
	move_time = 10

/obj/effect/shuttle_landmark/fleet/trade
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_trade_1"
	docking_controller = "fleet_trade_dock"

/obj/overmap/entity/visitable/ship/landable/fleet/trade
	name = "Entdecker Trade Ship"
	desc = "You know our motto: 'We deliver!'"
	scanner_name = "Entdecker Trade Ship"
	scanner_desc = @{"[i]Registration[/i]: FTUV Entdecker
[i]Class[/i]: Fartrade Class
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile, armed with defensives anti border turrets.
[b]Notice[/b]: A old Skrellian / Human deep space exploration vessel refit into serving as a deep space trade vessel
Colonial Militia files state that this vessel is the main FTU Vessel in the area."}
	color = "#96d350" //Green
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Entdecker Trade Ship"

/obj/machinery/computer/shuttle_control/explore/fleet/trade
	name = "short jump console"
	shuttle_tag = "Entdecker Trade Ship"

/area/shuttle/fleet/trade_ship
	requires_power = 1
	icon_state = "shuttle2"
	area_flags = AREA_RAD_SHIELDED

/area/shuttle/fleet/trade_ship/general
	name = "\improper Entdecker Trade Shuttle"

/area/shuttle/fleet/trade_ship/cockpit
	name = "\improper Entdecker Trade Shuttle Cockpit"


//Scoophead trade Shuttle - Returning shuttle. Fits the place well, secondary trade shuttle.


/obj/effect/shuttle_landmark/fleet/trade2
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "tradeport_scoophead"
	docking_controller = "tradeport_scoophead_dock"

/datum/shuttle/autodock/overmap/fleet/trade/scoophead
	name = "Scoophead trade Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/fleet/scoophead/cockpit, /area/shuttle/fleet/scoophead/main, /area/shuttle/fleet/scoophead/engineering)
	current_location = "tradeport_scoophead"
	docking_controller_tag = "tradeport_scoophead_docker"
	fuel_consumption = 4
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/trade/scoophead
	name = "Scoophead trade Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to be a smaller trade ship, easier to land than the Beruang. The Free Trade Union will always deliver."
	scanner_name = "Entdecker Trade Ship"
	scanner_desc = @{"[i]Registration[/i]: FTUV Scoophead
[i]Class[/i]: ---
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile, armed with defensives anti border turrets.
[b]Notice[/b]: NT records state that the scoophead a smaller class of vessel often used in more pirate heavy areas."}
	color = "#703200" //Orange
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Scoophead trade Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/trade/scoophead
	name = "short jump console"
	shuttle_tag = "Scoophead trade Shuttle"

/area/shuttle/fleet/scoophead
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/area/shuttle/fleet/scoophead/cockpit
	name = "Scoophead Cockpit"

/area/shuttle/fleet/scoophead/main
	name = "Scoophead Trading Section"

/area/shuttle/fleet/scoophead/engineering
	name = "Scoophead Engine Bay"



//Ani Shuttle - Naboo Star-fighter misxed with the Naboo royal transport.

/obj/effect/shuttle_landmark/fleet/ani
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_ani"

/datum/shuttle/autodock/overmap/fleet/ani
	name = "Ani Runabout Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/ani)
	current_location = "fleet_ani"
	docking_controller_tag = "fleet_ani_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/ani
	name = "Ani Runabout Shuttle"
	desc = "A ex-racing shuttle, part of the Roseline Colonist fleet."
	scanner_name = "Ani Runabout Shuttle"
	scanner_desc = @{"[i]Registration[/i]: Ani Runabout Shuttle
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roseline, non-hostile
[b]Notice[/b]: Oldest notice dates back 2552, where the shuttle arrived 7 at a bunch of races in the sol system."}
	color = "#bcd6ff" //light blue
	fore_dir = WEST
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Ani Runabout Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/ani
	name = "short jump console"
	shuttle_tag = "Ani Runabout Shuttle"

/area/shuttle/fleet/ani
	name = "Ani Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//Deneb Shuttle - Inspired by a BSG Vessel, its class name.

/obj/effect/shuttle_landmark/fleet/deneb
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_deneb"

/datum/shuttle/autodock/overmap/fleet/deneb
	name = "Deneb Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/deneb)
	current_location = "fleet_deneb"
	docking_controller_tag = "fleet_deneb_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/deneb
	name = "Deneb Shuttle"
	desc = "A ex-trash and salvage collector shuttle, part of the Roseline Colonist fleet."
	scanner_name = "Deneb Shuttle"
	scanner_desc = @{"[i]Registration[/i]: Deneb Shuttle
[i]Class[/i]: Demetrius V1 trashing and salvage Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roseline Colonist Fleet, fighter launcher capable.
[b]Notice[/b]: Colonial Militia files state that this vessel was part of the Roseline Colonist fleet.
Previously the fleet's main trash and salvage shuttle used by the fleet, it was replaced with the JR Iweng, a bigger vessel.
Now used a private vessel available to colonist, files do note that the ship also briefly became the fleet flagship during a small incident."}
	color = "#69490c" //brown
	fore_dir = WEST
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Deneb Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/deneb
	name = "short jump console"
	shuttle_tag = "Deneb Shuttle"

/area/shuttle/fleet/deneb
	name = "Deneb Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Spacena Caravan Shuttle

/obj/effect/shuttle_landmark/fleet/caravan
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_caravan"


/datum/shuttle/autodock/overmap/fleet/caravan
	name = "Spacena Caravan Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/caravan)
	current_location = "fleet_caravan"
	docking_controller_tag = "fleet_caravan_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/caravan
	name = "Spacena Caravan Shuttle"
	desc = "A cheap shuttle made for people wanting to live in their shuttle or travel."
	scanner_name = "Spacena Caravan Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Caravan Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: Caravan shuttle, cheap, comfy, fragile.
Colonial Militia files state that this shuttle is one of the most popular vessel in the fleet, but is right behind his bigger variant, the cargocarvan, in terms of numbers."}
	color = "#8f6f4b" //Brown
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Caravan Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/caravan
	name = "short jump console"
	shuttle_tag = "Spacena Caravan Shuttle"

/area/shuttle/fleet/caravan
	name = "Caravan"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Runabout

/obj/effect/shuttle_landmark/fleet/runabout
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_runabout"


/datum/shuttle/autodock/overmap/fleet/runabout
	name = "Teshari Runabout Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/runabout)
	current_location = "fleet_runabout"
	docking_controller_tag = "fleet_runabout_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/runabout
	name = "Teshari Runabout Shuttle"
	desc = "A teshari Design... At least the hull is, probably found in a shipyard, after being decommisionned. This shuttle might have been once a scout vessel linked with a other bigger teshari or skrell ship, and as been modified for civilian use."
	color = "#aa499b"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Teshari Runabout Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/runabout
	name = "short jump console"
	shuttle_tag = "Teshari Runabout Shuttle"

/area/shuttle/fleet/runabout
	name = "Teshari Runabout"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Radio shuttle

/obj/effect/shuttle_landmark/fleet/starcutter
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "occulum_fleet"

/datum/shuttle/autodock/overmap/fleet/starcutter
	name = "ORS Starcutter Radio Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/starcutter)
	current_location = "occulum_fleet"
	docking_controller_tag = "occulum_safehouse_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/starcutter
	name = "ORS Starcutter Radio Shuttle"
	desc = "A Occulum vessel."
	scanner_name = "ORS Starcutter Radio Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ORS Crescend
[i]Class[/i]: Radio vessel, Kel'lakgan Class
[i]Transponder[/i]: Transmitting (CIV), Registered with the Occulum News network
[b]Notice[/b]: A occulum vessel, based on a tajaran design, bought from the roselin colonist fleet by occulum a few years ago."}
	color = "#bcfbff" //sky blue
	fore_dir = WEST
	vessel_mass = 6500
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "ORS Starcutter Radio Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/starcutter
	name = "short jump console"
	shuttle_tag = "ORS Starcutter Radio Shuttle"

/area/shuttle/fleet/starcutter
	name = "Starcutter"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Cargoravan

/obj/effect/shuttle_landmark/fleet/cargoravana
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "cargoravana_start"

/datum/shuttle/autodock/overmap/fleet/cargoravana
	name = "Spacena Cargoravana Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/cargoravana)
	current_location = "cargoravana_start"
	docking_controller_tag = "fleet_cargoravana_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/cargoravana
	name = "Spacena Cargoravana Shuttle"
	desc = "A cheap shuttle made for people wanting to live and work in their shuttle."
	scanner_name = "Spacena Cargoravana Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Cargoravana Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: A popular sight in the colonost fleet. Its cheap shuttle made for people wanting to live and work in their shuttle.\
This class of shuttle is the home of many fammilies."}
	color = "#a2c118"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Cargoravana Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/cargoravana
	name = "short jump console"
	shuttle_tag = "Spacena Cargoravana Shuttle"

/area/shuttle/fleet/cargoravana
	name = "Cargoravana"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Spacena adventurer Shuttle

/obj/effect/shuttle_landmark/fleet/adventurer
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_adventurer"

/datum/shuttle/autodock/overmap/fleet/adventurer
	name = "Spacena Adventurer Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/adventurer)
	current_location = "fleet_adventurer"
	docking_controller_tag = "fleet_adventurer_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/adventurer
	name = "Spacena adventurer Shuttle"
	desc = "A cheap shuttle, variant of the Spacena Caravan, made for more versatile use."
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena adventurer Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: A popular sight in the colonost fleet. Its a cheap shuttle made for people wanting to explore the area."}
	color = "#323f55" //Blue grey
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Adventurer Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/adventurer
	name = "short jump console"
	shuttle_tag = "Spacena Adventurer Shuttle"

/area/shuttle/fleet/adventurer
	name = "Adventurer"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Cargo tug Shuttle

/obj/effect/shuttle_landmark/fleet/tug
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_tug"

/datum/shuttle/autodock/overmap/fleet/tug
	name = "Cargo Tug Hauler Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/tug)
	current_location = "fleet_tug"
	docking_controller_tag = "fleet_tug_docker"
	fuel_consumption = 4
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/tug
	name = "Cargo Tug Hauler Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Cargo Tug Hauler Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: A utility shuttle made to transport large ammount or cargo."}
	color = "#6b6d52"
	fore_dir = WEST
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Cargo Tug Hauler Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/tug
	name = "short jump console"
	shuttle_tag = "Cargo Tug Hauler Shuttle"

/area/shuttle/fleet/tug
	name = "Tug"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Utility Micro Shuttle

/obj/effect/shuttle_landmark/fleet/micro
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_utilitymicro"

/datum/shuttle/autodock/overmap/fleet/utilitymicro
	name = "Utility Micro Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/utilitymicro)
	current_location = "fleet_utilitymicro"
	docking_controller_tag = "fleet_utilitymicro_docker"
	fuel_consumption = 1
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/utilitymicro
	name = "Utility Micro Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Utility Micro Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: A utility shuttle made to maintain other vessels of the fleet."}
	color = "#6b6d52"
	fore_dir = WEST
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Utility Micro Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/utilitymicro
	name = "short jump console"
	shuttle_tag = "Utility Micro Shuttle"

/area/shuttle/fleet/utilitymicro
	name = "UMS"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Utility Micro Shuttle 2

/obj/effect/shuttle_landmark/fleet/micro2
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_utilitymicro2"


/datum/shuttle/autodock/overmap/fleet/utilitymicro2
	name = "Utility Micro Shuttle 2"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/utilitymicro2)
	current_location = "fleet_utilitymicro2"
	docking_controller_tag = "fleet_utilitymicro_docker2"
	fuel_consumption = 1
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/utilitymicro2
	name = "Utility Micro Shuttle 2"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Utility Micro Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: A utility shuttle made to maintain other vessels of the fleet."}
	color = "#6b6d52"
	fore_dir = WEST
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Utility Micro Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/utilitymicro2
	name = "short jump console"
	shuttle_tag = "Utility Micro Shuttle"

/area/shuttle/fleet/utilitymicro2
	name = "UMS2"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Colonial Liner - BSG INSPIRED, WOOOOO
//It is usable by Event min only. They just need to set down the jump console themselve.
//

/obj/effect/shuttle_landmark/fleet/colonial
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "colonial_start"

/datum/shuttle/autodock/overmap/fleet/colonial
	name = "RCV Roseline"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/colonial)
	docking_controller_tag = "colonial_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "colonial_start"

/obj/overmap/entity/visitable/ship/landable/fleet/colonial
	name = "RCV Roseline"
	desc = "A Liner made to carry people."
	scanner_name = "RCV Roseline"
	scanner_desc = @{"[i]Registration[/i]: RCV Roseline
[i]Class[/i]: Colonial Liner
[i]Transponder[/i]: Transmitting (CIV - RCV), Registered with the Roselin colonist fleet, non-hostile
[b]Notice[/b]: The roseline fleet civilian flagship, and the seat of the local gouvernement.
Colonial Militia files state that this Vessel got all archives and docuement to ensure proper functionning of the fleet."}
	color = "#4b768f"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "RCV Roseline"

/obj/machinery/computer/shuttle_control/explore/fleet/colonial
	name = "short jump console"
	shuttle_tag = "RCV Roseline"

/area/shuttle/fleet/colonial
	name = "RCV Roseline"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//Battlestar - ... I mean its litteraly a Battlestar.
//

/obj/effect/shuttle_landmark/fleet/battlestar
	name = "fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "battlestar_start"
	docking_controller = "battlestar_start_dock"

/datum/shuttle/autodock/overmap/fleet/battlestar
	name = "RCMV Adamant"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/battlestar)
	docking_controller_tag = "battlestar_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "battlestar_start"

/obj/overmap/entity/visitable/ship/landable/fleet/battlestar
	name = "RCMV Adamant"
	desc = "A Militia vessel."
	scanner_name = "RCMV Adamant"
	scanner_desc = @{"[i]Registration[/i]: RCMV Adamant
[i]Class[/i]: Andromeda BS2004
[i]Transponder[/i]: Transmitting (CIV - RCV), Registered with the Roselin colonist fleet, non-hostile, heavely armed, fighter and mech carrier.
[b]Notice[/b]: Militian flagship of the fleet, and its main protector. However, it only protects the fleet and fight pirates arround."}
	color = "#09005e"
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "RCMV Adamant"

/obj/machinery/computer/shuttle_control/explore/fleet/battlestar
	name = "short jump console"
	shuttle_tag = "RCMV Adamant"

/area/shuttle/fleet/battlestar
	name = "RCMV Adamant"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//Parabellum militia shuttle

/obj/effect/shuttle_landmark/fleet/parabellum
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "parabelum_start"


/obj/overmap/entity/visitable/ship/landable/fleet/parabellum
	name = "RCMV Parabellum"
	desc = "A Militia vessel."
	scanner_name = "RCMV Parabellum"
	scanner_desc = @{"[i]Registration[/i]: RCMV Parabellum
[i]Class[/i]: Monolith
[i]Transponder[/i]: Transmitting (CIV - RCV), Registered with the Roselin colonist fleet, non-hostile, fighter and mech carrier.
[b]Notice[/b]: Militian auxilary vessel, made to serve as a scout and escort."}
	color = "#2b255e"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "RCMV Parabellum"

/datum/shuttle/autodock/overmap/fleet/parabellum
	name = "RCMV Parabellum"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/parabellum)
	docking_controller_tag = "parabelum_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "parabelum_start"


/obj/machinery/computer/shuttle_control/explore/fleet/parabellum
	name = "short jump console"
	shuttle_tag = "RCMV Parabellum"

/area/shuttle/fleet/parabellum
	name = "RCMV Parabellum"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED




//Providence shuttle - Star trek HMS Bounty inspired

/obj/effect/shuttle_landmark/fleet/providence
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_providence"


/datum/shuttle/autodock/overmap/fleet/providence
	name = "Providence Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/providence)
	current_location = "fleet_providence"
	docking_controller_tag = "fleet_providence_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/providence
	name = "Providence Shuttle"
	desc = "A Shuttle that went rogue and every one loves it for that"
	scanner_name = "Providence Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ----
[i]Class[/i]: Lalakis Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roseline Colonist Fleet, fighter launcher capable.
[b]Notice[/b]: Colonial Militia files state that this vessel was part of vox pirate fleet, that stole the vessel.
During a raid, this vessel change its targets and started helping the fleet. A single teshari, of the original crew, manage to gain back control of the vessel, and shielded multiple vessel.
Now used a private vessel available to colonist, it as been repaired."}
	color = "#2a4b29"
	fore_dir = WEST
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Providence Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/providence
	name = "short jump console"
	shuttle_tag = "Providence Shuttle"

/area/shuttle/fleet/providence
	name = "Providence Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//Biodancy Shuttle - Space Dandy Shuttle

/obj/effect/shuttle_landmark/fleet/biodancy
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_biodancy"


/datum/shuttle/autodock/overmap/fleet/fleet/biodancy
	name = "Biodancy Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/biodancy)
	current_location = "fleet_biodancy"
	docking_controller_tag = "fleet_biodancy_docker"
	fuel_consumption = 5
	move_time = 10

/area/shuttle/fleet/biodancy
	name = "Biodancy Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/overmap/entity/visitable/ship/landable/fleet/biodancy
	name = "Biodancy Shuttle"
	desc = "A Shuttle with a small biodome"
	scanner_name = "Biodancy Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ----
[i]Class[/i]: Biodome SBS Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Roseline Colonist Fleet.
[b]Notice[/b]: Colonial Militia files state that this vessel is one of the rarest they have.
A small and nimble shuttle with botany research in mind.
Now used a private vessel available to colonist."}
	color = "#2fc92a"
	fore_dir = WEST
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Biodancy Shuttle"


/obj/machinery/computer/shuttle_control/explore/fleet/biodancy
	name = "short jump console"
	shuttle_tag = "Biodancy Shuttle"

/area/shuttle/fleet/biodancy
	name = "Biodancy Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED



//Tour shuttle

/obj/effect/shuttle_landmark/fleet/tour
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_tour"

/datum/shuttle/autodock/overmap/fleet/tour
	name = "Tour Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/tour)
	current_location = "fleet_tour"
	docking_controller_tag = "fleet_tour_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/tour
	name = "Tour Shuttle"
	desc = "A shuttle used for tours in space."
	color = "#aed5f0"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tour Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/tour
	name = "short jump console"
	shuttle_tag = "Tour Shuttle"

/area/shuttle/fleet/tour
	name = "Tour Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//passenger shuttle

/obj/effect/shuttle_landmark/fleet/passenger
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_passenger"

/datum/shuttle/autodock/overmap/fleet/passenger
	name = "Passenger Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/passenger)
	current_location = "fleet_passenger"
	docking_controller_tag = "fleet_passenger_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/passenger
	name = "Passenger Shuttle"
	desc = "A shuttle used for passengers in space."
	color = "#aed5f0"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Passenger Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/passenger
	name = "short jump console"
	shuttle_tag = "Passenger Shuttle"

/area/shuttle/fleet/passenger
	name = "Passenger Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Bolt shuttle

/obj/effect/shuttle_landmark/fleet/bolt
	name = "Fleet"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "fleet_bolt"

/datum/shuttle/autodock/overmap/fleet/bolt
	name = "Bolt Transport Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/fleet/bolt)
	current_location = "fleet_bolt"
	docking_controller_tag = "fleet_bolt_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/fleet/bolt
	name = "Bolt Transport Shuttle"
	desc = "A shuttle used for bolts in space."
	color = "#946929"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Bolt Transport Shuttle"

/obj/machinery/computer/shuttle_control/explore/fleet/bolt
	name = "short jump console"
	shuttle_tag = "Bolt Transport Shuttle"

/area/shuttle/fleet/bolt
	name = "Bolt Transport Shuttle"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
