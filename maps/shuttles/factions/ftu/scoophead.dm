
#warn impl

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
