
#warn impl

// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion/rift
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "rift_excursion_pad"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	fuel_consumption = 3
	move_direction = WEST

/obj/overmap/entity/visitable/ship/landable/excursion/rift
	name = "Excursion Shuttle"
	desc = "The Mk2 Excursion Shuttle. NT Approved!"
	color = "#72388d" //Purple
	fore_dir = WEST
	vessel_mass = 10000
	shuttle = "Excursion Shuttle"

#warn map
#warn this is rift's btw

