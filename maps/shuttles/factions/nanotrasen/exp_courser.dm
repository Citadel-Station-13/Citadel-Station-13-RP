
#warn impl


/datum/shuttle/autodock/overmap/courser/endeavour
	name = "Courser Scouting Vessel"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/courser/cockpit, /area/shuttle/courser/general, /area/shuttle/courser/battery)
	current_location = "endeavour_courser_hangar"
	docking_controller_tag = "courser_docker"
	landmark_transition = "nav_transit_courser"
	move_time = 15

/obj/overmap/entity/visitable/ship/landable/courser
	name = "Courser Scouting Vessel"
	desc = "Where there's a cannon, there's a way."
	color = "#af3e97" //Pinkish Purple
	fore_dir = EAST
	vessel_mass = 8000
	shuttle = "Courser Scouting Vessel"

/area/shuttle/courser
	name = "Courser Scouting Vessel"
	icon_state = "shuttle"

#warn map
