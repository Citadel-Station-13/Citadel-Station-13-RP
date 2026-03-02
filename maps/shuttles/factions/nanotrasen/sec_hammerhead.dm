
#warn below

/datum/shuttle/autodock/overmap/hammerhead
	name = "Hammerhead Patrol Barge"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/hammerhead/cockpit, /area/shuttle/hammerhead/general)
	current_location = "rift_hammerhead_hangar"
	docking_controller_tag = "hammerhead_docker"
	landmark_transition = "nav_transit_hammerhead"
	move_time = 15
	fuel_consumption = 5
	move_direction = WEST

/obj/overmap/entity/visitable/ship/landable/hammerhead
	name = "Hammerhead Patrol Barge"
	desc = "To Detain and Enforce."
	color = "#b91a14" //Vibrant Red
	fore_dir = WEST
	vessel_mass = 10000
	shuttle = "Hammerhead Patrol Barge"

/area/shuttle/hammerhead
	name = "Hammerhead Patrol Barge"
	icon_state = "shuttle"


#warn map
