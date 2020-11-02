/obj/structure/window/reinforced/polarized/full
	dir = SOUTHWEST
	icon_state = "fwindow"
	maxhealth = 80

// Special map objects
/obj/effect/landmark/map_data/triumph
	height = 4

/obj/turbolift_map_holder/triumph
	name = "Triumph Climber"
	depth = 4
	lift_size_x = 3
	lift_size_y = 1
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_ship/level1,
		/area/turbolift/t_ship/level2,
		/area/turbolift/t_ship/level3,
		/area/turbolift/t_ship/level4
		)

/datum/turbolift
	music = list('sound/music/elevator.ogg')  // Woo elevator music!

////////////////////////////

/obj/effect/step_trigger/lost_in_space
	var/deathmessage = "You drift off into space, floating alone in the void until your life support runs out."

/obj/effect/step_trigger/lost_in_space/Trigger(var/atom/movable/A) //replacement for shuttle dump zones because there's no empty space levels to dump to
	if(ismob(A))
		to_chat(A, "<span class='danger'>[deathmessage]</span>")
	qdel(A)

/obj/effect/step_trigger/lost_in_space/bluespace
	deathmessage = "Everything goes blue as your component particles are scattered throughout the known and unknown universe."
	var/last_sound = 0

/obj/effect/step_trigger/lost_in_space/bluespace/Trigger(A)
	if(world.time - last_sound > 5 SECONDS)
		last_sound = world.time
		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 75, 1)
	if(ismob(A) && prob(5))//lucky day
		var/destturf = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),pick(GLOB.using_map.station_levels))
		new /datum/teleport/instant(A, destturf, 0, 1, null, null, null, 'sound/effects/phasein.ogg')
	else
		return ..()

/obj/effect/step_trigger/lost_in_space/shuttle
	deathmessage = "You fly out of the shuttle at high speed for a few moments before you see the last hopes of your survival fade away."


// Invisible object that blocks z transfer to/from its turf and the turf above.
/obj/effect/ceiling
	invisibility = 101 // nope cant see this
	anchored = 1

/obj/effect/ceiling/CheckExit(atom/movable/O as mob|obj, turf/target as turf)
	if(target && target.z > src.z)
		return FALSE // Block exit from our turf to above
	return TRUE

/obj/effect/ceiling/CanAllowThrough(atom/movable/mover, turf/target, height=0, air_group=0)
	. = ..()
	if(mover && mover.z > src.z)
		return FALSE // Block entry from above to our turf
	return TRUE

//
// SHUTTLE STATION
//

// shuttle air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle
	name = "\improper Shuttle Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle/powered()
	return TRUE // Always be powered

//Chemistry 'chemavator'
/obj/machinery/smartfridge/chemistry/chemvator
	name = "\improper Smart Chemavator - Upper"
	desc = "A refrigerated storage unit for medicine and chemical storage. Now sporting a fancy system of pulleys to lift bottles up and down."
	var/obj/machinery/smartfridge/chemistry/chemvator/attached

/obj/machinery/smartfridge/chemistry/chemvator/down/Destroy()
	attached = null
	return ..()

/obj/machinery/smartfridge/chemistry/chemvator/down
	name = "\improper Smart Chemavator - Lower"

/obj/machinery/smartfridge/chemistry/chemvator/down/Initialize()
	. = ..()
	var/obj/machinery/smartfridge/chemistry/chemvator/above = locate(/obj/machinery/smartfridge/chemistry/chemvator,get_zstep(src,UP))
	if(istype(above))
		above.attached = src
		attached = above
		item_records = attached.item_records
	else
		to_chat(world,"<span class='danger'>[src] at [x],[y],[z] cannot find the unit above it!</span>")

// shuttle departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/shuttle
	name = "\improper Shuttle Station"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	icon_state = "door_closed"
	can_atmos_pass = ATMOS_PASS_NO
	base_icon_state = "door_closed"
	occupied_icon_state = "door_locked"
	desc = "The shuttle bay you might've came in from.  You could leave the base easily using this.<br><span class='userdanger'>Drag-drop yourself onto it while adjacent to leave.</span>"
	on_store_message = "has departed on the shuttle."
	on_store_name = "Crew Shift Transfer Services"
	on_enter_occupant_message = "The shuttle arrives at the platform; you step inside and take a seat."
	on_store_visible_message_1 = "'s speakers chime, anouncing a shuttle has arrived to take"
	on_store_visible_message_2 = "to the commanding ship"
	time_till_despawn = 10 SECONDS
	spawnpoint_type = /datum/spawnpoint/shuttle

/obj/machinery/cryopod/robot/door/shuttle/process()
	if(SSemergencyshuttle.online() || SSemergencyshuttle.returned())
		// Transform into a door!  But first despawn anyone inside
		time_till_despawn = 0
		..()
		var/turf/T = get_turf(src)
		var/obj/machinery/door/airlock/glass_external/door = new(T)
		door.req_access = null
		door.req_one_access = null
		qdel(src)
	// Otherwise just operate normally
	return ..()

/obj/machinery/cryopod/robot/door/tram/go_in(mob/living/M, mob/living/user)
	if(M != user)
		return ..()
	var/choice = alert(user, "Do you want to depart via the shuttle? Your character will leave the round.","Departure","No","Yes")
	if(user && Adjacent(user) && choice == "Yes")
		var/mob/observer/dead/newghost = user.ghostize()
		newghost.timeofdeath = world.time
		despawn_occupant(user)

// shuttle arrival point landmarks and datum
var/global/list/latejoin_shuttle   = list()

/obj/effect/landmark/shuttle
	name = "JoinLateShuttle"
	delete_me = 1

/obj/effect/landmark/shuttle/New()
	latejoin_shuttle += loc // Register this turf as shuttle latejoin.
	latejoin += loc // Also register this turf as fallback latejoin, since we won't have any arrivals shuttle landmarks.
	..()

/datum/spawnpoint/shuttle
	display_name = "Shuttle Bay"
	msg = "has arrived on the shuttle"

/datum/spawnpoint/shuttle/New()
	..()
	turfs = latejoin_shuttle

//
// Holodorms
//
/obj/machinery/computer/HolodeckControl/holodorm
	name = "Don't use this one!!!"
	powerdown_program = "Off"
	default_program = "Off"

	//Smollodeck
	active_power_usage = 500
	item_power_usage = 100

	supported_programs = list(
	"Off"			= new/datum/holodeck_program(/area/holodeck/holodorm/source_off),
	"Basic Dorm"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_basic),
	"Table Seating"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_seating),
	"Beach Sim"		= new/datum/holodeck_program(/area/holodeck/holodorm/source_beach),
	"Desert Area"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_desert),
	"Snow Field"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_snow),
	"Flower Garden"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_garden),
	"Space Sim"		= new/datum/holodeck_program(/area/holodeck/holodorm/source_space),
	"Boxing Ring"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_boxing)
	)

/obj/machinery/computer/HolodeckControl/holodorm/one
	name = "dorm one holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_1/holo

/obj/machinery/computer/HolodeckControl/holodorm/three
	name = "dorm three holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_3/holo

/obj/machinery/computer/HolodeckControl/holodorm/five
	name = "dorm five holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_5/holo

/obj/machinery/computer/HolodeckControl/holodorm/seven
	name = "dorm seven holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_7/holo

// Small Ship Holodeck
/obj/machinery/computer/HolodeckControl/houseboat
	projection_area = /area/houseboat/holodeck_area
	powerdown_program = "Turn Off"
	default_program = "Empty Court"

	supported_programs = list(
	"Basketball" 		= new/datum/holodeck_program(/area/houseboat/holodeck/basketball, list('sound/music/THUNDERDOME.ogg')),
	"Thunderdome"		= new/datum/holodeck_program(/area/houseboat/holodeck/thunderdome, list('sound/music/THUNDERDOME.ogg')),
	"Beach" 			= new/datum/holodeck_program(/area/houseboat/holodeck/beach),
	"Desert" 			= new/datum/holodeck_program(/area/houseboat/holodeck/desert,
													list(
														'sound/effects/weather/wind/wind_2_1.ogg',
											 			'sound/effects/weather/wind/wind_2_2.ogg',
											 			'sound/effects/weather/wind/wind_3_1.ogg',
											 			'sound/effects/weather/wind/wind_4_1.ogg',
											 			'sound/effects/weather/wind/wind_4_2.ogg',
											 			'sound/effects/weather/wind/wind_5_1.ogg'
												 		)
		 											),
	"Snowfield" 		= new/datum/holodeck_program(/area/houseboat/holodeck/snow,
													list(
														'sound/effects/weather/wind/wind_2_1.ogg',
											 			'sound/effects/weather/wind/wind_2_2.ogg',
											 			'sound/effects/weather/wind/wind_3_1.ogg',
											 			'sound/effects/weather/wind/wind_4_1.ogg',
											 			'sound/effects/weather/wind/wind_4_2.ogg',
											 			'sound/effects/weather/wind/wind_5_1.ogg'
												 		)
		 											),
	"Space" 			= new/datum/holodeck_program(/area/houseboat/holodeck/space,
													list(
														'sound/ambience/ambispace.ogg',
														'sound/music/main.ogg',
														'sound/music/space.ogg',
														'sound/music/traitor.ogg',
														)
													),
	"Picnic Area" 		= new/datum/holodeck_program(/area/houseboat/holodeck/picnic, list('sound/music/title2.ogg')),
	"Gaming" 			= new/datum/holodeck_program(/area/houseboat/holodeck/gaming, list('sound/music/traitor.ogg')),
	"Bunking"			= new/datum/holodeck_program(/area/houseboat/holodeck/bunking, list()),
	"Turn Off" 			= new/datum/holodeck_program(/area/houseboat/holodeck/off, list())
	)

// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)

//Airlock antitox vendor
/obj/machinery/vending/wallmed_airlock
	name = "Airlock NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser. This limited-use version dispenses antitoxins with mild painkillers for surface EVAs."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/reagent_containers/pill/airlock = 10,/obj/item/healthanalyzer = 1)
	contraband = list(/obj/item/reagent_containers/pill/tox = 2)
	req_log_access = access_cmo
	has_logs = 1

/obj/item/reagent_containers/pill/airlock
	name = "\'Airlock\' Pill"
	desc = "Neutralizes toxins and provides a mild analgesic effect."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/airlock/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	reagents.add_reagent("paracetamol", 5)

//"Red" Armory Door
/obj/machinery/door/airlock/security/armory
	name = "Red Armory"
	//color = ""

/obj/machinery/door/airlock/security/armory/allowed(mob/user)
	if(get_security_level() in list("green","blue"))
		return FALSE

	return ..(user)

/obj/structure/closet/secure_closet/guncabinet/excursion
	name = "expedition weaponry cabinet"
	req_one_access = list(access_explorer,access_armory)

/obj/structure/closet/secure_closet/guncabinet/excursion/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/gun/energy/frontier/locked(src)
	for(var/i = 1 to 4)
		new /obj/item/gun/energy/frontier/locked/holdout(src)

// Used at centcomm for the elevator
/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/shuttle

//Tether-unique network cameras
/obj/machinery/camera/network/tether
	network = list(NETWORK_TRIUMPH)

/obj/machinery/camera/network/tcomms
	network = list(NETWORK_TCOMMS)

/obj/machinery/camera/network/outside
	network = list(NETWORK_OUTSIDE)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLORATION)
/*
// Underdark mob spawners
/obj/tether_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/jelly = 3,
		/mob/living/simple_animal/hostile/giant_spider/hunter = 1,
		/mob/living/simple_animal/hostile/giant_spider/phorogenic = 1,
		/mob/living/simple_animal/hostile/giant_spider/lurker = 1,
	)

/obj/tether_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/corrupthound = 1,
		/mob/living/simple_animal/hostile/rat = 1,
		/mob/living/simple_animal/hostile/mimic = 1
	)

/obj/tether_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/dragon = 1
	)
*/

/obj/machinery/camera/network/research/xenobio
	network = list(NETWORK_RESEARCH, NETWORK_XENOBIO)

//Camera monitors
/obj/machinery/computer/security/xenobio
	name = "xenobiology camera monitor"
	desc = "Used to access the xenobiology cell cameras."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list(NETWORK_XENOBIO)
	circuit = /obj/item/circuitboard/security/xenobio
	light_color = "#F9BBFC"

/obj/item/circuitboard/security/xenobio
	name = T_BOARD("xenobiology camera monitor")
	build_path = /obj/machinery/computer/security/xenobio
	network = list(NETWORK_XENOBIO)
	req_access = list()
// Used at centcomm for the elevator
/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/shuttle

//
// ### Wall Machines On Full Windows ###
// To make sure wall-mounted machines placed on full-tile windows are clickable they must be above the window
//
/obj/item/radio/intercom
	layer = ABOVE_WINDOW_LAYER
/obj/item/storage/secure/safe
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/airlock_sensor
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/alarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/access_button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/guestpass
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/security/telescreen
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/door_timer
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/embedded_controller
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/firealarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/flasher
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/keycard_auth
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/light_switch
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/processing_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/stacking_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/newscaster
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/power/apc
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/requests_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/status_display
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed1
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed2
	layer = ABOVE_WINDOW_LAYER
/obj/structure/closet/fireaxecabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/extinguisher_cabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/mirror
	layer = ABOVE_WINDOW_LAYER
/obj/structure/noticeboard
	layer = ABOVE_WINDOW_LAYER
