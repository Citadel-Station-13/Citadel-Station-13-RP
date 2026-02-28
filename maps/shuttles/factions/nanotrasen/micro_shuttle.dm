
#warn impl

/datum/shuttle/autodock/overmap/trade/personalmicro1
	name = "Personal Micro Shuttle 1"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/personalmicro1)
	current_location = "strelka_personalmicro1"
	docking_controller_tag = "strelka_personalmicro1_docker"
	fuel_consumption = 1
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/personalmicro1
	name = "Personal Micro Shuttle 1"
	desc = "A Shuttle linked to the NEV Strelka."
	color = "#78cf56"
	fore_dir = WEST
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Personal Micro Shuttle 1"
	scanner_name = "Strelka Personal Transport 1"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: 2550 Personal Civilian Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka"}

/area/shuttle/personalmicro1
	name = "Personal Shuttle 1"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED


#warn map
