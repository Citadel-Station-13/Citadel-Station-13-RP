
#warn impl

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
