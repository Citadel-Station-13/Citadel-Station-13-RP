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
	shuttle_area = list(/area/shuttle/udang)
	current_location = "tradeport_hangar_udang"
	docking_controller_tag = "tradeport_udang_docker"
	fuel_consumption = 6
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/udang
	name = "Udang Transport Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to carry passengers. It seems that civilian pilot may also pilot it."
	color = "#a67145" //Orange Brownish
	fore_dir = EAST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Udang Transport Shuttle"

/obj/machinery/computer/shuttle_control/explore/trade/udang
	name = "short jump console"
	shuttle_tag = "Udang Transport Shuttle"

/area/shuttle/udang
	name = "Udang Transport Shuttle"
	icon_state = "shuttle"

//Scoophead trade Shuttle

/datum/shuttle/autodock/overmap/trade/scoophead
	name = "Scoophead trade Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/scoophead)
	current_location = "tradeport_hangar_scoophead"
	docking_controller_tag = "tradeport_scoophead_docker"
	fuel_consumption = 6
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/scoophead
	name = "Scoophead trade Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to be a smaller trade ship, easier to land than the Beruang. The Free Trade Union will always deliver."
	color = "#ff9f50" //Orange
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Scoophead trade Shuttle"

/obj/machinery/computer/shuttle_control/explore/trade/scoophead
	name = "short jump console"
	shuttle_tag = "Scoophead trade Shuttle"

/area/shuttle/scoophead
	name = "Scoophead trade Shuttle"
	icon_state = "shuttle"

