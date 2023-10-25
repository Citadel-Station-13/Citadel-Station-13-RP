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

// Tradeport Off-Map Visitor shuttle
/datum/shuttle/autodock/overmap/visitor_ship
	name = "Beluga Passenger Liner"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/visitor_ship/general, /area/shuttle/visitor_ship/cockpit)
	current_location = "nebula_pad_3"
	docking_controller_tag = "visitor_space_lock"
	fuel_consumption = 10
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/visitor_ship
	name = "Beluga Passenger Liner"
	desc = "You know our motto: 'Right place right time!'"
	color = "#754116" //Brown
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beluga Passenger Liner"

/obj/machinery/computer/shuttle_control/explore/visitor_ship
	name = "short jump console"
	shuttle_tag = "Beluga Passenger Liner"

/area/shuttle/visitor_ship
	requires_power = 1
	icon_state = "shuttle2"
	area_flags = AREA_RAD_SHIELDED

/area/shuttle/visitor_ship/general
	name = "\improper Beluga Passenger Liner"

/area/shuttle/visitor_ship/cockpit
	name = "\improper Beluga Passenger Liner Cockpit"
