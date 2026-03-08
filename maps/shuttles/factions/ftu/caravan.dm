
#warn impl

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
