
// Special map objects
/* // Moved to map/generic/map_data.dm
/obj/landmark/map_data/triumph
	height = 4
*/
/*
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
	music = list('sound/music/elevator1.ogg', 'sound/music/elevator2.ogg')  // Woo elevator music!
*/
/*
// shuttle departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/shuttle
	name = "\improper Shuttle Station"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	icon_state = "door_closed"
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
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

/obj/machinery/cryopod/robot/door/shuttle/process(delta_time)
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

/obj/machinery/cryopod/robot/door/shuttle/go_in(mob/living/M, mob/living/user)
	if(M != user)
		return ..()
	var/choice = alert(user, "Do you want to depart via the shuttle? Your character will leave the round.","Departure","No","Yes")
	if(user && Adjacent(user) && choice == "Yes")
		var/mob/observer/dead/newghost = user.ghostize()
		newghost.timeofdeath = world.time
		despawn_occupant(user)

// shuttle arrival point landmarks and datum
var/global/list/latejoin_shuttle   = list()

/obj/landmark/shuttle
	name = "JoinLateShuttle"
	delete_me = 1

/obj/landmark/shuttle/New()
	latejoin_shuttle += loc // Register this turf as shuttle latejoin.
	latejoin += loc // Also register this turf as fallback latejoin, since we won't have any arrivals shuttle landmarks.
	return ..()

/datum/spawnpoint/shuttle
	display_name = "Shuttle Bay"
	msg = "has arrived on the shuttle"

/datum/spawnpoint/shuttle/New()
	. = ..()
	turfs = latejoin_shuttle

*/
// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)


/* This is extranious, commenting out just to make sure there is no funkyness going on before deleteing - Bloop
//Airlock antitox venedor
/obj/machinery/vending/wallmed_airlock
	name = "Airlock NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser. This limited-use version dispenses antitoxins with mild painkillers for surface EVAs."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list( = 10,/obj/item/healthanalyzer = 1)
	contraband = list(/obj/item/reagent_containers/pill/tox = 2)
	req_log_access = access_cmo
	has_logs = 1

/obj/item/reagent_containers/pill/airlock
	name = "\'Airlock\' Pill"
	desc = "Neutralizes toxins and provides a mild analgesic effect."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/airlock/Initialize(mapload)
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	reagents.add_reagent("paracetamol", 5)
*/
/*
// Used at centcomm for the elevator
/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/shuttle

*/
////////////////////////////////////////////////
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
