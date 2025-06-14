//SDF
/datum/shuttle/autodock/overmap/miaphus/sdf
	name = "SDF Shining singing knight"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/miaphus/sdf)
	docking_controller_tag = "sdf_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "sdf_outpost"

/obj/overmap/entity/visitable/ship/landable/miaphus/sdf
	name = "SDF Shining singing knight"
	desc = "A damaged military vessel."
	scanner_name = "SDF Shining singing knight"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Andromeda BS2002
[i]Transponder[/i]: Transmitting (SDF)
[b]Notice[/b]: A SDF corvette, patrolling the sector."}
	color = "#ff9900"
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "SDF Shining singing knight"

/obj/machinery/computer/shuttle_control/explore/sdf
	name = "short jump console"
	shuttle_tag = "SDF Shining singing knight"

/area/shuttle/miaphus/sdf
	name = "SDF Shining singing knight"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/miaphus/sdf
	name = "Outpost 12"
	landmark_tag = "sdf_outpost"
	docking_controller = "sdf_outpost_dock"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/dirtlight
	base_area = /area/sector/miaphus/beach/jungle
