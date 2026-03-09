
#warn impl

/datum/shuttle/autodock/overmap/tourbus
	name = "Tour Bus"
	warmup_time = 0
	current_location = "tourbus_dock"
	docking_controller_tag = "tourbus_docker"
	shuttle_area = list(/area/shuttle/tourbus/cockpit, /area/shuttle/tourbus/general)
	fuel_consumption = 1
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/overmap/entity/visitable/ship/landable/tourbus
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	vessel_mass = 2000
	shuttle = "Tour Bus"
