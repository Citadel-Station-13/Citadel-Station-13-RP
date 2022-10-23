// Consoladating Spawn points to one file to help with map modularity -Bloop


///// Tether's Tram station (Someone can use these for another station that uses trams as well too!) - Bloop
// Tram departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/tram
	name = "\improper Tram Station"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	icon_state = "door_closed"
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	base_icon_state = "door_closed"
	occupied_icon_state = "door_locked"
	desc = "The tram station you might've came in from.  You could leave the base easily using this."
	on_store_message = "has departed on the tram."
	on_store_name = "Travel Oversight"
	on_enter_occupant_message = "The tram arrives at the platform; you step inside and take a seat."
	on_store_visible_message_1 = "'s speakers chime, anouncing a tram has arrived to take"
	on_store_visible_message_2 = "to the colony"
	time_till_despawn = 10 SECONDS
	spawnpoint_type = /datum/spawnpoint/tram

/obj/machinery/cryopod/robot/door/tram/process()
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

/datum/spawnpoint/tram
	display_name = "Tram Station"
	method = LATEJOIN_METHOD_TRAM

/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/tram

////////////////////////////////////////////////////////////////

///// Triumph's shuttle doors (Or if someone else wants to use them for another station!)
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

/datum/spawnpoint/shuttle
	display_name = "Shuttle Bay"
	method = LATEJOIN_METHOD_SHUTTLE_DOCK

// Used at centcomm for the elevator
/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/shuttle

///////////////////////////////////////////////////////////////////////////
