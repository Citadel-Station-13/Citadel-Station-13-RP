
#warn impl

/datum/shuttle/autodock/overmap/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/emt/strelka/main, /area/shuttle/emt/strelka/cockpit)
	current_location = "strelka_emt_hangar"
	docking_controller_tag = "emtshuttle_docker"
	move_time = 15
	fuel_consumption = 3

/area/shuttle/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/emt/strelka/cockpit
	name = "Hammerdart Interception and Rescue Shuttle cockpit"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/emt/strelka/main
	name = "Hammerdart Interception and Rescue Shuttle main"
	icon_state = "shuttle"
	requires_power = 1

/obj/overmap/entity/visitable/ship/landable/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	desc = "A shuttle combining EMT search and rescue work, with security like work. The best of 2 worlds."
	fore_dir = EAST
	vessel_mass = 11000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Hammerdart Interception and Rescue Shuttle"
	scanner_name = "Hammerdart Interception and Rescue Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Hammerdart Orbit Patrol Shuttle, Medical refit.
[i]Transponder[/i]: Transmitting (MED) and (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka. It is also a fighter carrier vessel."}
	color = "#2613d1"


#warn map
