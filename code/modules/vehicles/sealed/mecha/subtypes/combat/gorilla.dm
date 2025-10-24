
/obj/vehicle/sealed/mecha/combat/gorilla
	name = "Gorilla"
	desc = "<b>Blitzkrieg!</b>" //stop using all caps in item descs i will fight you. its redundant with the bold.
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrmech"
	initial_icon = "pzrmech"
	// Multi-tile mechs don't support opacity properly.
	opacity = FALSE
	pixel_x = -16
	integrity = 5000
	integrity_max = 5000

	base_movement_speed = 1.5

	deflect_chance = 50
	damage_absorption = list("brute"=0.1,"fire"=0.8,"bullet"=0.1,"laser"=0.6,"energy"=0.7,"bomb"=0.7) //values show how much damage will pass through, not how much will be absorbed.
	max_temperature = 35000 //Just a bit better than the Durand.
	wreckage = /obj/effect/decal/mecha_wreckage/gorilla
	add_req_access = 0
	internal_damage_threshold = 25
	force = 60

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

	smoke_possible = 1
	zoom_possible = 1
	thrusters_possible = 1

/obj/vehicle/sealed/mecha/combat/gorilla/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/tesla_energy_relay,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/weak,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/lmg,
	)

/obj/vehicle/sealed/mecha/combat/gorilla/mechstep(direction)
	var/result = step(src,direction)
	playsound(src,"mechstep",40,1)
	return result

/obj/vehicle/sealed/mecha/combat/gorilla/mechturn(direction)
	dir = direction
	playsound(src,"mechstep",40,1)

/obj/vehicle/sealed/mecha/combat/gorilla/relaymove(mob/user,direction)
	if(user != src.occupant_legacy)
		user.loc = get_turf(src)
		to_chat(user, "You climb out from [src]")
		return 0
	if(!can_move)
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(state || !has_charge(step_energy_drain))
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 0
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(src.dir!=direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0

/obj/vehicle/sealed/mecha/combat/gorilla/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke_reserve]"}
	return output

/obj/vehicle/sealed/mecha/combat/gorilla/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/effect/decal/mecha_wreckage/gorilla
	name = "Gorilla wreckage"
	desc = "... Blitzkrieg?"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrwreck"
	plane = MOB_PLANE
	pixel_x = -16
	anchored = 1 // It's fucking huge. You aren't moving it.
