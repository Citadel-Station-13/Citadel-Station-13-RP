//RED COMET
/datum/shuttle/autodock/overmap/voidline/redcomet
	name = "Red Comet Racing Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/redcomet)
	current_location = "voidline_redcomet"
	docking_controller_tag = "voidline_redcomet_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/redcomet
	name = "Red Comet Racing Shuttle"
	desc = "A racing shuttle, that arrived second during the 2542 Voidline shuttle race."
	scanner_name = "Red Comet Racing Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
[b]Notice[/b]: Racing shuttle, arrived second during the 2542 Voidline."}
	color = "#ab0000" //Crimson. Makes shuttle go 3 times faster (no). Beside, You solely, are responsible for this.
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Red Comet Racing Shuttle"

/obj/machinery/computer/shuttle_control/explore/redcomet
	name = "short jump console"
	shuttle_tag = "Red Comet Racing Shuttle"

/area/shuttle/redcomet
	name = "Red Comet"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//BONNETHEAD
/datum/shuttle/autodock/overmap/voidline/bonnethead
	name = "Bonnethead Racing Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/bonnethead)
	current_location = "voidline_bonnethead"
	docking_controller_tag = "voidline_bonnethead_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/bonnethead
	name = "Bonnethead Racing Shuttle"
	desc = "A racing shuttle, that arrived third during the 2542 Voidline shuttle race."
	scanner_name = "Bonnethead Racing Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
[b]Notice[/b]: Racing shuttle, arrived third during the 2542 Voidline."}
	color = "#edac14" //orange
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Bonnethead Racing Shuttle"

/obj/machinery/computer/shuttle_control/explore/bonnethead
	name = "short jump console"
	shuttle_tag = "Bonnethead Racing Shuttle"

/area/shuttle/bonnethead
	name = "Bonnethead"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Udang Pari-pari
/datum/shuttle/autodock/overmap/voidline/paripari
	name = "Udang Pari-pari Racing Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/paripari)
	current_location = "voidline_udang"
	docking_controller_tag = "voidline_udang_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/paripari
	name = "Udang Pari-pari Racing Shuttle"
	desc = "A racing shuttle, that arrived last during the 2542 Voidline shuttle race."
	scanner_name = "Udang Pari-pari Racing Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
[b]Notice[/b]: Racing shuttle, arrived last during the 2542 Voidline, altho won prior races in skrell and oricon space while being used to make deliveries."}
	color = "#3adf1d" //green
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Udang Pari-pari Racing Shuttle"

/obj/machinery/computer/shuttle_control/explore/paripari
	name = "short jump console"
	shuttle_tag = "Udang Pari-pari Racing Shuttle"

/area/shuttle/paripari
	name = "Udang pari-pari"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

//Radio shuttle
/datum/shuttle/autodock/overmap/voidline/crescend
	name = "ORS Crescend Radio Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/crescend)
	current_location = "occulum_safehouse"
	docking_controller_tag = "occulum_safehouse_docker"
	fuel_consumption = 5
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/crescend
	name = "ORS Crescend Radio Shuttle"
	desc = "A racing shuttle, that arrived last during the 2542 Voidline shuttle race."
	scanner_name = "ORS Crescend Radio Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ORS Crescend
[i]Class[/i]: Radio Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Occulum News network
[b]Notice[/b]: A occulum vessel, based on a Teshari design."}
	color = "#bcfbff" //sky blue
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "ORS Crescend Radio Shuttle"

/obj/machinery/computer/shuttle_control/explore/crescend
	name = "short jump console"
	shuttle_tag = "ORS Crescend Radio Shuttle"

/area/shuttle/crescend
	name = "Crescend"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
