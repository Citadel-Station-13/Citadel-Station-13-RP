
#warn impl

/datum/shuttle/autodock/overmap/securiship
	name = "Securiship Shuttle"
	warmup_time = 0
	current_location = "tether_securiship_dock"
	docking_controller_tag = "securiship_docker"
	shuttle_area = list(/area/shuttle/securiship/cockpit, /area/shuttle/securiship/general, /area/shuttle/securiship/engines)
	fuel_consumption = 2
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/overmap/entity/visitable/ship/landable/securiship
	name = "Securiship Shuttle"
	desc = "A security transport ship."
	vessel_mass = 4000
	shuttle = "Securiship Shuttle"
	fore_dir = EAST
