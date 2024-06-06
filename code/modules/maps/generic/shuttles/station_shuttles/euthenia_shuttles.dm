/datum/shuttle/autodock/overmap/euthenia_shuttles
	name = "Beruang Trade Ship"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/trade_ship/cockpit, /area/shuttle/trade_ship/general)
	current_location = "tradeport_hangar"
	docking_controller_tag = "tradeport_hangar_docker"
	fuel_consumption = 5
	move_time = 10
	defer_initialisation = TRUE

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

/datum/shuttle/autodock/overmap/euthenia_shuttles/skipper
