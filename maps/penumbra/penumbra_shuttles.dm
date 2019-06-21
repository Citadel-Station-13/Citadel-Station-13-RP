/*/area/shuttle/penumbra/excursion/tether

/datum/shuttle_destination/excursion/docked_penumbra
	name = "Place Docking Arm"
	my_area = /area/shuttle/penumbra/excursion/tether
	dock_target = "d1a2_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"
*/

/datum/shuttle/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

//////////////////////////////////////////////////////////////
// Escape shuttle
/datum/shuttle/ferry/emergency/escape
	name = "Escape"
	location = 1 // At offsite
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	/*docking_controller_tag = "escape_shuttle"
	dock_target_station = "escape_dock"
	dock_target_offsite = "centcom_dock"*/ //TURNS OUT THESE JUST GET FUCKING OVERRIDEN GOOD JOB VIRGO
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//
// Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.


/datum/shuttle/ferry/emergency/init_docking_controllers()
	docking_controller_tag = null
	dock_target_station = null
	dock_target_offsite = null
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)
/*
////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
/obj/machinery/computer/shuttle_control/web/excursion
	name = "shuttle control console"
	shuttle_tag = "Excursion Shuttle"
	req_access = list()
	req_one_access = list(access_heads,access_explorer,access_pilot)
	var/wait_time = 45 MINUTES

/obj/machinery/computer/shuttle_control/web/excursion/ui_interact()
	if(world.time < wait_time)
		to_chat(usr,"<span class='warning'>The console is locked while the shuttle refuels. It will be complete in [round((wait_time - world.time)/10/60)] minute\s.</span>")
		return FALSE

	. = ..()

/datum/shuttle/web_shuttle/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_area = /area/shuttle/excursion/tether
	docking_controller_tag = "expshuttle_docker"
	web_master_type = /datum/shuttle_web_master/excursion
	var/abduct_chance = 0.5 //Prob

/datum/shuttle/web_shuttle/excursion/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
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
		var/datum/shuttle/web_shuttle/WS = shuttle_controller.shuttles[name]
		var/datum/shuttle_destination/ASD = WS.web_master.get_destination_by_type(/datum/shuttle_destination/excursion/alienship)
		WS.web_master.future_destination = ASD
		. = ..(departing,ASD.my_area,interim,travel_time,direction)
	else
		. = ..()

/datum/shuttle_web_master/excursion
	destination_class = /datum/shuttle_destination/excursion
	starting_destination = /datum/shuttle_destination/excursion/tether

/datum/shuttle_destination/excursion/tether
	name = "NSB Adephagia Excursion Hangar"
	my_area = /area/shuttle/excursion/tether

	dock_target = "expshuttle_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/outside_tether = 0,
	)

/datum/shuttle_destination/excursion/tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the Excursion Hangar."

/datum/shuttle_destination/excursion/tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from the Excursion Hangar."


/datum/shuttle_destination/excursion/outside_tether
	name = "Nearby NSB Adephagia"
	my_area = /area/shuttle/excursion/tether_nearby
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/docked_tether = 0,
		/datum/shuttle_destination/excursion/virgo3b_orbit = 30 SECONDS
	)


/datum/shuttle_destination/excursion/docked_tether
	name = "NSB Adephagia Docking Arm"
	my_area = /area/shuttle/excursion/tether_dockarm

	dock_target = "d1a2_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

/datum/shuttle_destination/excursion/docked_tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Docking Arm One."

/datum/shuttle_destination/excursion/docked_tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from Docking Arm One."


/datum/shuttle_destination/excursion/virgo3b_orbit
	name = "Virgo 3B Orbit"
	my_area = /area/shuttle/excursion/space
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo3b_sky = 30 SECONDS,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS
	)


/datum/shuttle_destination/excursion/virgo3b_sky
	name = "Skies of Virgo 3B"
	my_area = /area/shuttle/excursion/virgo3b_sky

////////// Distant Destinations
/datum/shuttle_destination/excursion/bluespace
	name = "Bluespace Jump"
	my_area = /area/shuttle/excursion/bluespace
	preferred_interim_area = /area/shuttle/excursion/space_moving
*/
