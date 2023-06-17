//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = NORTH

//////////////////////////////////////////////////////////////
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/shuttle/large_escape_pod1
	warmup_time = 0
	landmark_station = "escapepod1_station"
	landmark_offsite = "escapepod1_cc"
	landmark_transition = "escapepod1_transit"
	docking_controller_tag = "large_escape_pod_1"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	move_direction = NORTH

//////////////////////////////////////////////////////////////
// Tether Shuttle
/datum/shuttle/autodock/ferry/tether_backup
	name = "Tether Backup"
	location = FERRY_LOCATION_OFFSITE //Offsite is the surface hangar
	warmup_time = 5
	move_time = 45
	landmark_offsite = "tether_backup_low"
	landmark_station = "tether_customs_shuttle"
	landmark_transition = "tether_backup_transit"
	shuttle_area = /area/shuttle/tether
	//crash_areas = list(/area/shuttle/tether/crash1, /area/shuttle/tether/crash2)
	docking_controller_tag = "tether_shuttle"
	move_direction = NORTH


//////////////////////////////////////////////////////////////
// Surface Mining Outpost Shuttle

/datum/shuttle/autodock/ferry/surface_mining_outpost
	name = "Mining Outpost"
	location = FERRY_LOCATION_STATION
	warmup_time = 5
	shuttle_area = /area/shuttle/mining_outpost
	landmark_station = "mining_station"
	landmark_offsite = "mining_outpost"
	docking_controller_tag = "mining_docking"
	move_direction = NORTH


////////////////////////////////////////
// Tether custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"
	req_one_access = list(ACCESS_COMMAND_BRIDGE,ACCESS_GENERAL_PILOT)

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(ACCESS_FACTION_SYNDICATE)

/obj/machinery/computer/shuttle_control/multi/ninja
	name = "vessel control console"
	shuttle_tag = "Ninja"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/skipjack
	name = "vessel control console"
	shuttle_tag = "Skipjack"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/specops
	name = "vessel control console"
	shuttle_tag = "NDV Phantom"
	req_one_access = list(ACCESS_CENTCOM_ERT)

/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(ACCESS_FACTION_TRADER)

/obj/machinery/computer/shuttle_control/surface_mining_outpost
	name = "surface mining outpost shuttle control console"
	shuttle_tag = "Mining Outpost"
	req_one_access = list(ACCESS_SUPPLY_MINE)
//
// "Tram" Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
/datum/shuttle/autodock/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection
	move_direction = NORTH

/datum/shuttle/autodock/ferry/emergency/New()
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

//
// The backup tether shuttle uses experimental engines and can degrade and/or crash!
//
/* //Disabling the crash mechanics per request
/datum/shuttle/ferry/tether_backup
	crash_message = "Tether shuttle distress signal received. Shuttle location is approximately 200 meters from tether base."
	category = /datum/shuttle/ferry/tether_backup // So shuttle_controller.dm doesn't try and instantiate this type as an acutal mapped in shuttle.
	var/list/engines = list()
	var/obj/machinery/computer/shuttle_control/tether_backup/computer

/datum/shuttle/ferry/tether_backup/New()
	..()
	var/area/current_area = get_location_area(location)
	for(var/obj/structure/shuttle/engine/propulsion/E in current_area)
		engines += E
	for(var/obj/machinery/computer/shuttle_control/tether_backup/comp in current_area)
		computer = comp

/datum/shuttle/ferry/tether_backup/process_longjump(var/area/origin, var/area/intended_destination)
	var/failures = engines.len
	for(var/engine in engines)
		var/obj/structure/shuttle/engine/E = engine
		failures -= E.jump()

	#define MOVE_PER(x) move_time*(x/100) SECONDS

	computer.visible_message("[bicon(computer)] <span class='notice'>Beginning flight and telemetry monitoring.</span>")
	sleep(MOVE_PER(5))

	if(failures >= 1)
		computer.visible_message("[bicon(computer)] <span class='warning'>Single engine failure, continuing flight.</span>")
		sleep(MOVE_PER(10))

	if(failures >= 2)
		computer.visible_message("[bicon(computer)] <span class='warning'>Second engine failure, unable to complete flight.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(10))
		computer.visible_message("[bicon(computer)] <span class='warning'>Commencing RTLS abort mode.</span>")
		sleep(MOVE_PER(20))
		if(failures < 3)
			move(area_transition,origin)
			moving_status = SHUTTLE_IDLE
			return 1

	if(failures >= 3)
		computer.visible_message("[bicon(computer)] <span class='danger'>Total engine failure, unable to complete abort mode.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Distress signal broadcast.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Stall. Stall. Stall. Stall.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Terrain! Pull up! Terrain! Pull up!</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		playsound(computer,'sound/misc/bloblarm.ogg',100,0)
		sleep(MOVE_PER(10))
		do_crash(area_transition)
		return 1

	return 0

	#undef MOVE_PER
//
// The repairable engines
// TODO - These need a more advanced fixing sequence.
//
/obj/structure/shuttle/engine
	var/wear = 0

/obj/structure/shuttle/engine/proc/jump()
	. = !prob(wear)
	if(!.)
		wear = 100
	else
		wear += rand(5,20)

/obj/structure/shuttle/engine/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(repair_welder(user, W))
		return
	return ..()

//TODO require a multitool to diagnose and open engine panels or something

/obj/structure/shuttle/engine/proc/repair_welder(var/mob/user, var/obj/item/weldingtool/WT)
	if(!istype(WT))
		return 0
	if(wear <= 20)
		to_chat(user,"<span class='notice'>\The [src] doesn't seem to need repairs right now.</span>")
		return 1
	if(!WT.remove_fuel(0, user))
		to_chat(user,"<span class='warning'>\The [WT] must be on to complete this task.</span>")
		return 1
	playsound(src, 'sound/items/Welder.ogg', 50, 1)
	user.visible_message("<span class='notice'>\The [user] begins \the [src] overhaul.</span>","<span class='notice'>You begin an overhaul of \the [src].</span>")
	if(!do_after(user, wear SECONDS, src))
		return 1
	if(!src || !WT.isOn())
		return 1
	user.visible_message("<span class='notice'>\The [user] has overhauled \the [src].</span>","<span class='notice'>You complete \the [src] overhaul.</span>")
	wear = 20
	update_icon()
	return 1
*/

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "tether_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	fuel_consumption = 3
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "The traditional Excursion Shuttle. NT Approved!"
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(ACCESS_GENERAL_PILOT)

////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/tourbus
	name = "Tour Bus"
	warmup_time = 0
	current_location = "tourbus_dock"
	docking_controller_tag = "tourbus_docker"
	shuttle_area = list(/area/shuttle/tourbus/cockpit, /area/shuttle/tourbus/general)
	fuel_consumption = 1
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/tourbus
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tour Bus"

/obj/machinery/computer/shuttle_control/explore/tourbus
	name = "short jump console"
	shuttle_tag = "Tour Bus"
	req_one_access = list(ACCESS_GENERAL_PILOT)

////////////////////////////////////////
////////      Medivac      /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/medivac
	name = "Medivac Shuttle"
	warmup_time = 0
	current_location = "tether_medivac_dock"
	docking_controller_tag = "medivac_docker"
	shuttle_area = list(/area/shuttle/medivac/cockpit, /area/shuttle/medivac/general, /area/shuttle/medivac/engines)
	fuel_consumption = 2
	move_direction = EAST

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/medivac
	name = "Medivac Shuttle"
	desc = "A medical evacuation shuttle."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Medivac Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/medivac
	name = "short jump console"
	shuttle_tag = "Medivac Shuttle"

////////////////////////////////////////
////////      Securiship   /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/securiship
	name = "Securiship Shuttle"
	warmup_time = 0
	current_location = "tether_securiship_dock"
	docking_controller_tag = "securiship_docker"
	shuttle_area = list(/area/shuttle/securiship/cockpit, /area/shuttle/securiship/general, /area/shuttle/securiship/engines)
	fuel_consumption = 2
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/securiship
	name = "Securiship Shuttle"
	desc = "A security transport ship."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Securiship Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/securiship
	name = "short jump console"
	shuttle_tag = "Securiship Shuttle"
