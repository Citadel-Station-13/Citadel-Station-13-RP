
#warn impl

/datum/shuttle/autodock/overmap/medivac
	name = "Medivac Shuttle"
	warmup_time = 0
	current_location = "tether_medivac_dock"
	docking_controller_tag = "medivac_docker"
	shuttle_area = list(/area/shuttle/medivac/cockpit, /area/shuttle/medivac/general, /area/shuttle/medivac/engines)
	fuel_consumption = 2
	move_direction = EAST

// The 'ship' of the excursion shuttle
/obj/overmap/entity/visitable/ship/landable/medivac
	name = "Medivac Shuttle"
	desc = "A medical evacuation shuttle."
	vessel_mass = 4000
	shuttle = "Medivac Shuttle"
	fore_dir = EAST
