
#warn impl

/datum/shuttle/autodock/overmap/excursion/strelka
	name = "Excursion Javelot Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/excursion/strelka)
	current_location = "strelka_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	move_time = 15

/area/shuttle/excursion/strelka
	name = "Excursion Javelot Shuttle"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/excursion/cockpit
	name = "Excursion Javelot Shuttle Cockpit"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/excursion/general
	name = "Excursion Javelot Shuttle"
	icon_state = "shuttle"

/obj/overmap/entity/visitable/ship/landable/excursion/strelka
	name = "Excursion Javelot Shuttle"
	desc = "A rather old design of shuttle, but still being produced today ! And this one is brand new !"
	fore_dir = EAST
	vessel_mass = 11000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Javelot Shuttle"
	scanner_name = "Excursion Javelot Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Javelot Exploration Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka. It is also a fighter carrier vessel."}
	color = "#a890ac"

#warn mutable_appearance
