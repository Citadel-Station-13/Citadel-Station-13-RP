
#warn impl

/datum/shuttle/autodock/overmap/civvie
	name = "Civilian Transport"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/civvie/cockpit, /area/shuttle/civvie/general)
	current_location = "rift_civvie_pad"
	docking_controller_tag = "civvie_docker"
	landmark_transition = "nav_transit_civvie"
	fuel_consumption = 10
	move_time = 30

/obj/overmap/entity/visitable/ship/landable/civvie
	name = "Civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = NORTH
	vessel_mass = 12000
	shuttle = "Civilian Transport"

/area/shuttle/civvie
	name = "Civilian Transport"
	icon_state = "shuttle"

#warn map
