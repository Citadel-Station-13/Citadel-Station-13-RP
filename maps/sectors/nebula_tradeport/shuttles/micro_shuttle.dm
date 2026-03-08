
#warn impl

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
