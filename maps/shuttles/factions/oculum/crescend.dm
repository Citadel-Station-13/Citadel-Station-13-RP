
#warn impl

//Radio shuttle
/datum/shuttle/autodock/overmap/voidline/crescend
	name = "ORS Crescend Radio Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/crescend)
	current_location = "occulum_safehouse"
	docking_controller_tag = "occulum_safehouse_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/crescend
	name = "ORS Crescend Radio Shuttle"
	desc = "A racing shuttle, that arrived last during the 2542 Voidline shuttle race."
	scanner_name = "ORS Crescend Radio Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ORS Crescend
[i]Class[/i]: Radio Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Occulum News network
[b]Notice[/b]: A occulum vessel, based on a Teshari design."}
	color = "#bcfbff" //sky blue
	fore_dir = WEST
	vessel_mass = 10000
	shuttle = "ORS Crescend Radio Shuttle"

/obj/machinery/computer/shuttle_control/explore/crescend
	name = "short jump console"
	shuttle_tag = "ORS Crescend Radio Shuttle"

/area/shuttle/crescend
	name = "Crescend"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
