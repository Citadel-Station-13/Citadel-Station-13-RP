/datum/shuttle/autodock/overmap/trade/salvager
	name = "GCSS Vevalia Salvage Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/salvager)
	current_location = "solar_salvage"
	docking_controller_tag = "solar_salvage_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/salvager
	name = "GCSS Vevalia Salvage Shuttle"
	desc = "A small shuttle of Skrell design, refitted for salvage work."
	scanner_name = "ORS Crescend Radio Shuttle"
	scanner_desc = @{"[i]Registration[/i]: GCSS Vevalia
[i]Class[/i]: Salvage Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Guardian Corporation
[b]Notice[/b]: A vessel part of a bigger fleet arround the Guardian Corporation Mothership. Here in the sector to do legal salvage. the Guardian Corporation is small, and Neutral to NT."}
	color = "#71831f"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "GCSS Vevalia Salvage Shuttle"

/obj/machinery/computer/shuttle_control/explore/salvager
	name = "short jump console"
	shuttle_tag = "GCSS Vevalia Salvage Shuttle"

/area/shuttle/salvager
	name = "Vevalia"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

