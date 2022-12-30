// TODO: port to modern vehicles. If you're in this file, STOP FUCKING WITH IT AND PORT IT OVER.
//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle_old
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = MOB_LAYER + 0.1 //so it sits above objects including mobs
	density = 1
	anchored = 1
	animate_movement=1
	light_range = 3

	buckle_allowed = TRUE
	buckle_flags = BUCKLING_PASS_PROJECTILES_UPWARDS
	buckle_lying = 0

	var/mechanical = TRUE // If false, doesn't care for things like cells, engines, EMP, keys, etc.
	var/attack_log = null
	var/on = 0
	var/health = 0	//do not forget to set health for your vehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/emagged = 0
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 1	//set this to limit the speed of the vehicle

	var/obj/item/cell/cell
	var/charge_use = 5	//set this to adjust the amount of power the vehicle uses per move

	var/paint_color = "#666666" //For vehicles with special paint overlays.

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay
	var/mob_offset_y = 0		//pixel_y offset for mob overlay

//-------------------------------------------
// Standard procs
//-------------------------------------------

//BUCKLE HOOKS

/obj/vehicle_old/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(mechanical && on && powered && cell.charge < charge_use)
			turn_off()

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		setDir(get_dir(old_loc, loc))
		anchored = init_anc

		if(mechanical && on && powered)
			cell.use(charge_use)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.setDir(dir)

		return 1
	else
		return 0

/obj/vehicle_old/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/hand_labeler))
		return
	if(mechanical)
		if(W.is_screwdriver())
			if(!locked)
				open = !open
				update_icon()
				to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
				playsound(src, W.tool_sound, 50, 1)
		else if(W.is_crowbar() && cell && open)
			remove_cell(user)

		else if(istype(W, /obj/item/cell) && !cell && open)
			insert_cell(W, user)
		else if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/T = W
			if(T.welding)
				if(health < maxhealth)
					if(open)
						health = min(maxhealth, health+10)
						user.setClickCooldown(user.get_attack_speed(W))
						playsound(src, T.tool_sound, 50, 1)
						user.visible_message("<font color='red'>[user] repairs [src]!</font>","<font color=#4F49AF> You repair [src]!</font>")
					else
						to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
				else
					to_chat(user, "<span class='notice'>[src] does not need a repair.</span>")
			else
				to_chat(user, "<span class='notice'>Unable to repair while [src] is off.</span>")

	else if(hasvar(W,"force") && hasvar(W,"damtype"))
		user.setClickCooldown(user.get_attack_speed(W))
		switch(W.damtype)
			if("fire")
				health -= W.force * fire_dam_coeff
			if("brute")
				health -= W.force * brute_dam_coeff
		..()
		healthcheck()
	else
		..()

/obj/vehicle_old/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	healthcheck()

/obj/vehicle_old/proc/adjust_health(amount)
	health = clamp( health + amount, 0,  maxhealth)
	healthcheck()

/obj/vehicle_old/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= rand(5,10)*fire_dam_coeff
			health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				health -= rand(1,5)*fire_dam_coeff
				health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/obj/vehicle_old/emp_act(severity)
	if(!mechanical)
		return

	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(src.loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = 1
	pulse2.setDir(pick(GLOB.cardinal))

	spawn(10)
		qdel(pulse2)
	if(on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/vehicle_old/attack_ai(mob/user as mob)
	return

// For downstream compatibility (in particular Paradise)
/obj/vehicle_old/proc/handle_rotation()
	return

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle_old/proc/turn_on()
	if(!mechanical || stat)
		return FALSE
	if(powered && cell.charge < charge_use)
		return FALSE
	on = 1
	set_light(initial(light_range))
	update_icon()
	return TRUE

/obj/vehicle_old/proc/turn_off()
	if(!mechanical)
		return FALSE
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle_old/emag_act(var/remaining_charges, mob/user as mob)
	if(!mechanical)
		return FALSE

	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You bypass [src]'s controls.</span>")
		return TRUE

/obj/vehicle_old/proc/explode()
	src.visible_message("<font color='red'><B>[src] blows apart!</B></font>", 1)
	var/turf/Tsec = get_turf(src)

	//stuns people who are thrown off a train that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()

	if(mechanical)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/cable_coil/cut(Tsec)
		new /obj/effect/gibspawner/robot(Tsec)
		new /obj/effect/debris/cleanable/blood/oil(src.loc)

		if(cell)
			cell.forceMove(Tsec)
			cell.update_icon()
			cell = null

	qdel(src)

/obj/vehicle_old/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle_old/proc/powercheck()
	if(!mechanical)
		return

	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < charge_use)
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle_old/proc/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	if(!mechanical)
		return
	if(cell)
		return
	if(!istype(C))
		return
	if(!H.attempt_insert_item_for_installation(C, src))
		return

	cell = C
	powercheck()
	to_chat(usr, "<span class='notice'>You install [C] in [src].</span>")

/obj/vehicle_old/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!mechanical)
		return
	if(!cell)
		return

	to_chat(usr, "<span class='notice'>You remove [cell] from [src].</span>")
	H.grab_item_from_interacted_with(cell, src)
	cell = null
	powercheck()

/obj/vehicle_old/proc/RunOver(var/mob/living/M)
	return		//write specifics for different vehicles

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle_old/proc/load(var/atom/movable/C, var/mob/living/user)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	C.setDir(dir)
	C.anchored = 1

	load = C

	if(load_item_visible)
		C.pixel_x += load_offset_x
		if(ismob(C))
			C.pixel_y += mob_offset_y
		else
			C.pixel_y += load_offset_y
		C.layer = layer + 0.1

	if(ismob(C))
		user_buckle_mob(C, user = user)

	return 1


/obj/vehicle_old/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in GLOB.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	if(ismob(load))
		unbuckle_mob(load, BUCKLE_OP_FORCE)

	load.forceMove(dest)
	load.setDir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	load = null

	return 1


//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle_old/proc/update_stats()
	return

/obj/vehicle_old/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!damage)
		return
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	user.do_attack_animation(src)
	src.health -= damage
	if(mechanical && prob(10))
		new /obj/effect/debris/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1

/obj/vehicle_old/take_damage(var/damage)
	if(!damage)
		return
	src.health -= damage
	if(mechanical && prob(10))
		new /obj/effect/debris/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1
