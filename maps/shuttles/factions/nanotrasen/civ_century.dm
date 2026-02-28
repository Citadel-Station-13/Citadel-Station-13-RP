
#warn impl

/datum/shuttle/autodock/overmap/oldcentury
	name = "Civilian Century Shuttle"
	warmup_time = 15
	shuttle_area = /area/shuttle/oldcentury
	current_location = "rift_oldcentury_pad"
	docking_controller_tag = "oldcentury_docker"
	landmark_transition = "nav_transit_oldcentury"
	fuel_consumption = 8
	move_time = 37

/obj/overmap/entity/visitable/ship/landable/oldcentury
	name = "Civilian Century Shuttle"
	desc = "Is it... A replica ? Or... the real deal ? This shuttle, based on the shuttles from earth's old days. No teasing, this shuttle is a replica, but still a old and crapy ship."
	fore_dir = NORTH
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Century Shuttle"
	color = "#4cad73" //Greyish green

/area/shuttle/oldcentury
	name = "Civilian Century Shuttle"
	icon_state = "shuttle"
	requires_power = 1
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

#warn map
