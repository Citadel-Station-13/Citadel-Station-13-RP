
#warn impl

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
