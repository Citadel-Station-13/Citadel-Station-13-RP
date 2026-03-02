
#warn impl

/datum/shuttle/autodock/overmap/civvie/strelka
	name = "Decades Old civilian Transport"
	warmup_time = 11
	shuttle_area = list(/area/shuttle/civvie/strelka)
	current_location = "strelka_civvie_home"
	docking_controller_tag = "civvie_dock"
	fuel_consumption = 2
	move_time = 30

/area/shuttle/civvie/strelka
	name = "Decades Old civilian Transport"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/civvie/strelka/main
	name = "Decades Old civilian Transport Main"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/civvie/strelka/cockpit
	name = "Decades Old civilian Transport Cockpit"
	icon_state = "shuttle"
	requires_power = 1

/obj/overmap/entity/visitable/ship/landable/civvie/strelka
	name = "Decades Old civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = WEST
	vessel_mass = 9000
	shuttle = "Decades Old civilian Transport"
	scanner_name = "Decades Old civilian Transport"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: 2460 Ustio class Civilian Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka"}
	color = "#7fbd27"


#warn map
