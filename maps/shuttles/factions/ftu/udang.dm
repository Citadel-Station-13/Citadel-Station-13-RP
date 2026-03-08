
#warn impl

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
