
#warn impl

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
