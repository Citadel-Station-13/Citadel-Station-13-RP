/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	//docking_controller_tag = "escape_shuttle"
	//dock_target_station = "escape_dock"
	//dock_target_offsite = "centcom_dock"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//Mining
/datum/shuttle/autodock/ferry/mining
	name = "Mining"
	warmup_time = 10
	area_offsite = /area/shuttle/mining/outpost
	area_station = /area/shuttle/mining/station
	docking_controller_tag = "mining_shuttle"
	dock_target_station = "mining_dock"
	dock_target_offsite = "mining_outpost_airlock"

/obj/machinery/computer/shuttle_control/mining
	name = "mining shuttle control console"


//Supply
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY


//Research
/datum/shuttle/autodock/ferry/research
	name = "Research"
	warmup_time = 10
	area_offsite = /area/shuttle/research/outpost
	area_station = /area/shuttle/research/station
	docking_controller_tag = "research_shuttle"
	dock_target_station = "research_dock"
	dock_target_offsite = "research_outpost_dock"

/obj/machinery/computer/shuttle_control/mining
	name = "research shuttle control console"

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
/obj/machinery/computer/shuttle_control/web/excursion
	name = "shuttle control console"
	shuttle_tag = "Excursion Shuttle"
	req_access = list()
	req_one_access = list(access_pilot)
	icon = 'icons/obj/computer.dmi'
	icon_state = "flightcomp_center"
	icon_screen = "flight_center"
	icon_keyboard = "flight_center_key"
	var/wait_time = 30 MINUTES

/obj/machinery/computer/shuttle_control/web/excursion/ui_interact()
	if(world.time < wait_time)
		to_chat(usr,"<span class='warning'>The console is locked while the shuttle refuels. It will be complete in [round((wait_time - world.time)/10/60)] minute\s.</span>")
		return FALSE

	. = ..()

/datum/shuttle/web_shuttle/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_area = /area/shuttle/excursion/endeavor
	docking_controller_tag = "expshuttle_docker"
	web_master_type = /datum/shuttle_web_master/excursion
	var/abduct_chance = 0 //Prob

/datum/shuttle/web_shuttle/excursion/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	/* abduction removed for now
	if(prob(abduct_chance))
		abduct_chance = 0
		var/list/occupants = list()
		for(var/mob/living/L in departing)
			occupants += key_name(L)
		log_and_message_admins("Shuttle abduction occuring with (only mobs on turfs): [english_list(occupants)]")
		//Build the route to the alien ship
		var/obj/shuttle_connector/alienship/ASC = new /obj/shuttle_connector/alienship(null)
		ASC.setup_routes()

		//Redirect us onto that route instead
		var/datum/shuttle/web_shuttle/WS = SSshuttle.shuttles[name]
		var/datum/shuttle_destination/ASD = WS.web_master.get_destination_by_type(/datum/shuttle_destination/excursion/alienship)
		WS.web_master.future_destination = ASD
		. = ..(departing,ASD.my_area,interim,travel_time,direction)
	else
		. = ..()
	*/
	. = ..()

/datum/shuttle_web_master/excursion
	destination_class = /datum/shuttle_destination/excursion
	starting_destination = /datum/shuttle_destination/excursion/endeavor


///// VARIOUS EXCURSION SHUTTLE LOCATIONS /////
//Right in the hangar
/datum/shuttle_destination/excursion/endeavor
	name = "ARFS Endeavor Excursion Hangar"
	my_area = /area/shuttle/excursion/endeavor

	dock_target = "expshuttle_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/outside_endeavor = 0
	)

/datum/shuttle_destination/excursion/endeavor/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the Excursion Hangar."

/datum/shuttle_destination/excursion/endeavor/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from the Excursion Hangar."

//Just outside the ship on Z4
/datum/shuttle_destination/excursion/outside_endeavor
	name = "Nearby ARFS Endeavor"
	my_area = /area/shuttle/excursion/endeavor_nearby
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/odin5_orbit = 30 SECONDS,
		/datum/shuttle_destination/excursion/bluespace = 45 SECONDS
	)

//In orbit around gas giant with many moons
/datum/shuttle_destination/excursion/odin5_orbit
	name = "Odin 5 Orbit"
	my_area = /area/shuttle/excursion/space
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/odin5a_orbit = 30 SECONDS,
		/datum/shuttle_destination/excursion/outside_endeavor = 30 SECONDS,
		/datum/shuttle_destination/excursion/bluespace = 45 SECONDS
	)

////////// Jump here if you're trying to go far in a hurry. Allows you to skip between star systems and between
////////// planets that are more than 1 jump away from one another
/datum/shuttle_destination/excursion/bluespace
	name = "Bluespace Jump"
	my_area = /area/shuttle/excursion/bluespace
	preferred_interim_area = /area/shuttle/excursion/space_moving
	routes_to_make = list(
		/datum/shuttle_destination/excursion/odin5_orbit = 45 SECONDS,
		/datum/shuttle_destination/excursion/outside_endeavor = 45 SECONDS
	)
