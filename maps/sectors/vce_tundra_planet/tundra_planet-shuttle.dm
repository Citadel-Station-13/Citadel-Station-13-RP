//raider

/obj/effect/shuttle_landmark/maquis/raider
	name = "maquis"
	base_area = /area/sector/tundra/field
	base_turf = /turf/simulated/floor/water
	landmark_tag = "raider_start"
	docking_controller = "raider_start_dock"

/datum/shuttle/autodock/overmap/maquis/raider
	name = "DMV Raider"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/maquis/raider)
	docking_controller_tag = "raider_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "raider_start"

/obj/overmap/entity/visitable/ship/landable/maquis/raider
	name = "DMV Raider"
	desc = "A Rebel vessel."
	scanner_name = "DMV Raider"
	scanner_desc = @{"[i]Registration[/i]: RCMV Adamant
[i]Class[/i]: DSNINE Class
[i]Transponder[/i]: Transmitting (MIL - DMV), Unregistered. Potentialy-hostile, heavely armed, fighter and mech carrier.
[b]Notice[/b]: A Dryas Maquisard flagship."}
	color = "#a00000"
	fore_dir = WEST
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "DMV Raider"

/obj/machinery/computer/shuttle_control/explore/maquis/raider
	name = "short jump console"
	shuttle_tag = "DMV Raider"

/area/shuttle/maquis/raider
	name = "DMV Raider"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


//Interceptor

/obj/effect/shuttle_landmark/maquis/interceptor
	name = "maquis"
	base_area = /area/sector/tundra/field
	base_turf = /turf/simulated/floor/water
	landmark_tag = "interceptor_start"
	docking_controller = "interceptor_start_dock"

/obj/overmap/entity/visitable/ship/landable/maquis/interceptor
	name = "DMV Interceptor"
	desc = "A Militia vessel."
	scanner_name = "DMV Interceptor"
	scanner_desc = @{"[i]Registration[/i]: RCMV interceptor
[i]Class[/i]: Unclassifed Skiff
[i]Transponder[/i]: Transmitting (MIL - DMV), Unregistered. Potentialy-hostile, heavely armed.
[b]Notice[/b]: Militian auxilary vessel, made to intercept."}
	color = "#551d1d"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "DMV Interceptor"

/datum/shuttle/autodock/overmap/maquis/interceptor
	name = "DMV Interceptor"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/maquis/interceptor)
	docking_controller_tag = "interceptor_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "interceptor_start"


/obj/machinery/computer/shuttle_control/explore/maquis/interceptor
	name = "short jump console"
	shuttle_tag = "DMV Interceptor"

/area/shuttle/maquis/interceptor
	name = "DMV Interceptor"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
