
#warn impl

/datum/shuttle/autodock/overmap/trade/arrowhead
	name = "Arrowhead Racing Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/arrowhead)
	current_location = "tradeport_arrowhead"
	docking_controller_tag = "tradeport_arrowhead_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/arrowhead
	name = "Arrowhead Racing Shuttle"
	desc = "A ex-racing shuttle, part of the VIP suite of the Nebula Motel."
	scanner_name = "Arrowhead Racing Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile
[b]Notice[/b]: Racing shuttle, winner of the 2542 Voidline gold trophy"}
	color = "#002d75" //Darkblue
	fore_dir = WEST
	vessel_mass = 10000
	shuttle = "Arrowhead Racing Shuttle"

/obj/machinery/computer/shuttle_control/explore/arrowhead
	name = "short jump console"
	shuttle_tag = "Arrowhead Racing Shuttle"

/area/shuttle/arrowhead
	name = "Arrowhead"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
