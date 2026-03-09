#warn impl


// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion/tether
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "tether_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	fuel_consumption = 3
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/overmap/entity/visitable/ship/landable/excursion/tether
	name = "Excursion Shuttle"
	desc = "The traditional Excursion Shuttle. NT Approved!"
	fore_dir = NORTH
	vessel_mass = 8000
	shuttle = "Excursion Shuttle"
