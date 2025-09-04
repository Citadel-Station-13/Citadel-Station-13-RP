/datum/shuttle/autodock/overmap/trade
	name = "Beruang Trade Ship"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/trade_ship/cockpit, /area/shuttle/trade_ship/general)
	current_location = "tradeport_hangar"
	docking_controller_tag = "tradeport_hangar_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade
	name = "Beruang Trade Ship"
	desc = "You know our motto: 'We deliver!'"
	color = "#754116" //Brown
	fore_dir = WEST
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beruang Trade Ship"

/obj/machinery/computer/shuttle_control/explore/trade
	name = "short jump console"
	shuttle_tag = "Beruang Trade Ship"

/area/shuttle/trade_ship
	requires_power = 1
	icon_state = "shuttle2"
	area_flags = AREA_RAD_SHIELDED

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Shuttle"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Shuttle Cockpit"

//Udang Shuttle

/datum/shuttle/autodock/overmap/trade/udang
	name = "Udang Transport Shuttle"
	warmup_time = 6
	shuttle_area = list(/area/shuttle/udang/cockpit, /area/shuttle/udang/main)
	current_location = "tradeport_udang"
	docking_controller_tag = "tradeport_udang_docker"
	fuel_consumption = 4
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/udang
	name = "Udang Transport Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to carry passengers. It seems that civilian pilot may also pilot it."
	color = "#a66d45" //Orange Brownish
	fore_dir = EAST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Udang Transport Shuttle"

/obj/machinery/computer/shuttle_control/explore/trade/udang
	name = "short jump console"
	shuttle_tag = "Udang Transport Shuttle"

/area/shuttle/udang
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/area/shuttle/udang/cockpit
	name = "Udang Cockpit"

/area/shuttle/udang/main
	name = "Udang Main Section"

//Scoophead trade Shuttle

/datum/shuttle/autodock/overmap/trade/scoophead
	name = "Scoophead trade Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/scoophead/cockpit, /area/shuttle/scoophead/main, /area/shuttle/scoophead/engineering)
	current_location = "tradeport_scoophead"
	docking_controller_tag = "tradeport_scoophead_docker"
	fuel_consumption = 4
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/scoophead
	name = "Scoophead trade Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to be a smaller trade ship, easier to land than the Beruang. The Free Trade Union will always deliver."
	color = "#ff811a" //Orange
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Scoophead trade Shuttle"

/obj/machinery/computer/shuttle_control/explore/trade/scoophead
	name = "short jump console"
	shuttle_tag = "Scoophead trade Shuttle"

/area/shuttle/scoophead
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/area/shuttle/scoophead/cockpit
	name = "Scoophead Cockpit"

/area/shuttle/scoophead/main
	name = "Scoophead Trading Section"

/area/shuttle/scoophead/engineering
	name = "Scoophead Engine Bay"


//Arrowhead Shuttle

/datum/shuttle/autodock/overmap/trade/arrowhead
	name = "Arrowhead Racing Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/arrowhead)
	current_location = "tradeport_arrowhead"
	docking_controller_tag = "tradeport_arrowhead_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/arrowhead
	name = "Arrowhead Racing Shuttle"
	desc = "A ex-racing shuttle, part of the VIP suite of the Nebula Motel."
	scanner_name = "Arrowhead Racing Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile
[b]Notice[/b]: Racing shuttle, winner of the 2542 Voidline gold trophy"}
	color = "#002d75" //Darkblue
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Arrowhead Racing Shuttle"

/obj/machinery/computer/shuttle_control/explore/arrowhead
	name = "short jump console"
	shuttle_tag = "Arrowhead Racing Shuttle"

/area/shuttle/arrowhead
	name = "Arrowhead"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Spacena Caravan Shuttle

/datum/shuttle/autodock/overmap/trade/caravan
	name = "Spacena Caravan Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/caravan)
	current_location = "tradeport_caravan"
	docking_controller_tag = "tradeport_caravan_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/caravan
	name = "Spacena Caravan Shuttle"
	desc = "A cheap shuttle made for people wanting to live in their shuttle or travel."
	scanner_name = "Spacena Caravan Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Caravan Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile
[b]Notice[/b]: Caravan shuttle, cheap, comfy, fragile."}
	color = "#8f6f4b" //Brown
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Caravan Shuttle"

/obj/machinery/computer/shuttle_control/explore/caravan
	name = "short jump console"
	shuttle_tag = "Spacena Caravan Shuttle"

/area/shuttle/caravan
	name = "Caravan"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Spacena adventurer Shuttle

/datum/shuttle/autodock/overmap/trade/adventurer
	name = "Spacena Adventurer Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/adventurer)
	current_location = "tradeport_adventurer"
	docking_controller_tag = "tradeport_adventurer_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/adventurer
	name = "Spacena adventurer Shuttle"
	desc = "A cheap shuttle, variant of the Spacena Caravan, made for more versatile use."
	color = "#323f55" //Blue grey
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Adventurer Shuttle"

/obj/machinery/computer/shuttle_control/explore/adventurer
	name = "short jump console"
	shuttle_tag = "Spacena Adventurer Shuttle"

/area/shuttle/adventurer
	name = "Adventurer"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Cargo tug Shuttle

/datum/shuttle/autodock/overmap/trade/tug
	name = "Cargo Tug Hauler Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/tug)
	current_location = "tradeport_tug"
	docking_controller_tag = "tradeport_tug_docker"
	fuel_consumption = 4
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/tug
	name = "Cargo Tug Hauler Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	color = "#6b6d52"
	fore_dir = WEST
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Cargo Tug Hauler Shuttle"

/obj/machinery/computer/shuttle_control/explore/tug
	name = "short jump console"
	shuttle_tag = "Cargo Tug Hauler Shuttle"

/area/shuttle/tug
	name = "Tug"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Utility Micro Shuttle

/datum/shuttle/autodock/overmap/trade/utilitymicro
	name = "Utility Micro Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/utilitymicro)
	current_location = "tradeport_utilitymicro"
	docking_controller_tag = "tradeport_utilitymicro_docker"
	fuel_consumption = 1
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/utilitymicro
	name = "Utility Micro Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	color = "#6b6d52"
	fore_dir = WEST
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Utility Micro Shuttle"

/obj/machinery/computer/shuttle_control/explore/utilitymicro
	name = "short jump console"
	shuttle_tag = "Utility Micro Shuttle"

/area/shuttle/utilitymicro
	name = "UMS"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Teshari Runabout

/datum/shuttle/autodock/overmap/trade/runabout
	name = "Teshari Runabout Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/runabout)
	current_location = "tradeport_runabout"
	docking_controller_tag = "tradeport_runabout_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/runabout
	name = "Teshari Runabout Shuttle"
	desc = "A teshari Design... At least the hull is, probably found in a shipyard, after being decommisionned. This shuttle might have been once a scout vessel linked with a other bigger teshari or skrell ship, and as been modified for civilian use."
	color = "#aa499b"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Teshari Runabout Shuttle"

/obj/machinery/computer/shuttle_control/explore/runabout
	name = "short jump console"
	shuttle_tag = "Teshari Runabout Shuttle"

/area/shuttle/runabout
	name = "Teshari Runabout"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

