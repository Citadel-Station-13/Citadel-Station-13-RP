// todo: readd fuel ports and usage on overmaps update.
/*
#define waypoint_sector(waypoint) get_overmap_entity(get_z(waypoint))

/datum/shuttle/autodock/overmap
	warmup_time = 10

	// additional bounds range we can jump to
	var/range = 3
	var/fuel_consumption = 0 //Amount of moles of gas consumed per trip; If zero, then shuttle is magic and does not need fuel
	var/obj/overmap/entity/visitable/ship/landable/myship //my overmap ship object

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	refresh_fuel_ports_list()

/datum/shuttle/autodock/overmap/Destroy()
	. = ..()
	myship = null

/datum/shuttle/autodock/overmap/fuel_check()
	if(!src.try_consume_fuel()) //insufficient fuel
		for(var/area/A in shuttle_area)
			for(var/mob/living/M in A)
				M.show_message("<spawn class='warning'>You hear the shuttle engines sputter... perhaps it doesn't have enough fuel?", 1,
				"<spawn class='warning'>The shuttle shakes but fails to take off.", 2)
				return 0 //failure!
	return 1 //sucess, continue with launch

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector
	var/our_sector = waypoint_sector(current_location)
	if(myship?.landmark && next_location == myship.landmark)
		return TRUE //We're not on the overmap yet (admin spawned probably), and we're trying to hook up with our openspace sector
	return get_dist(our_sector, waypoint_sector(next_location)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	if(A != current_location)
		next_location = A

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	var/our_sector = waypoint_sector(current_location)
	if(!our_sector && myship?.landmark)
		res["Perform Test Jump"] = myship.landmark
		return res //We're not on the overmap, maybe an admin spawned us on a non-sector map. We're broken until we connect to our space z-level.
	var/obj/overmap/entity/top_ship = myship
	while(!isturf(top_ship.loc) && istype(top_ship.loc, /obj/overmap/entity))
		top_ship = top_ship.loc
	for (var/obj/overmap/entity/visitable/S in bounds(top_ship, range))
		var/list/waypoints = S.get_waypoints(name)
		for(var/obj/effect/shuttle_landmark/LZ in waypoints)
			if(LZ.is_valid(src))
				res[LZ.name] = LZ
	return res

/datum/shuttle/autodock/overmap/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"

/datum/shuttle/autodock/overmap/proc/try_consume_fuel() //returns 1 if sucessful, returns 0 if error (like insufficient fuel)
	if(!fuel_consumption)
		return 1 //shuttles with zero fuel consumption are magic and can always launch
	if(!fuel_ports.len)
		return 0 //Nowhere to get fuel from
	var/list/obj/item/tank/fuel_tanks = list()
	for(var/obj/structure/FP in fuel_ports) //loop through fuel ports and assemble list of all fuel tanks
		var/obj/item/tank/FT = locate() in FP
		if(FT)
			fuel_tanks += FT
	if(!fuel_tanks.len)
		return 0 //can't launch if you have no fuel TANKS in the ports
	var/total_flammable_gas_moles = 0
	for(var/obj/item/tank/FT in fuel_tanks)
		total_flammable_gas_moles += FT.air_contents.moles_by_flag(GAS_FLAG_FUEL)
	if(total_flammable_gas_moles < fuel_consumption) //not enough fuel
		return 0
	// We are going to succeed if we got to here, so start consuming that fuel
	var/fuel_to_consume = fuel_consumption
	for(var/obj/item/tank/FT in fuel_tanks) //loop through tanks, consume their fuel one by one
		var/fuel_available = FT.air_contents.moles_by_flag(GAS_FLAG_FUEL)
		if(!fuel_available) // Didn't even have fuel.
			continue
		if(fuel_available >= fuel_to_consume)
			FT.remove_air_by_flag(GAS_FLAG_FUEL, fuel_to_consume)
			return 1 //ALL REQUIRED FUEL HAS BEEN CONSUMED, GO FOR LAUNCH!
		else //this tank doesn't have enough to launch shuttle by itself, so remove all its fuel, then continue loop
			fuel_to_consume -= fuel_available
			FT.remove_air_by_flag(GAS_FLAG_FUEL, fuel_available)

*/
