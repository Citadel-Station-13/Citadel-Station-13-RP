// TODO: port to modern vehicles. If you're in this file, STOP FUCKING WITH IT AND PORT IT OVER.
//This is the initial set up for the new carts. Feel free to improve and/or rewrite everything here.
//I don't know what the hell I'm doing right now. Please help. Especially with the update_icons stuff. -Joan Risu

/obj/vehicle_old/train/security/engine
	name = "Security Cart"
	desc = "A rideable electric car designed for pulling trolleys as well as personal transport."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "paddywagon"
	on = 0
	powered = 1
	locked = 0
	move_delay = 0.5

	//Health stuff
	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7

	cell_type = /obj/item/cell/basic/tier_1/large

	var/car_limit = 0	//how many cars an engine can pull before performance degrades. This should be 0 to prevent trailers from unhitching.
	active_engines = 1
	var/obj/item/key/security/key
	var/siren = 0 //This is for eventually getting the siren sprite to work.

/obj/vehicle_old/train/security/engine/Initialize(mapload)
	. = ..()
	key = new(src)
	var/image/I = new(icon = 'icons/obj/vehicles.dmi', icon_state = "cargo_engine_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	turn_off()	//so engine verbs are correctly set

/obj/vehicle_old/train/security/engine/Move(var/turf/destination)
	var/obj/item/cell/cell = get_cell()
	if(on && cell.charge < charge_use)
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive motor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return 0

	//space check ~no flying space trains sorry
	if(on && istype(destination, /turf/space))
		return 0

	return ..()

/obj/vehicle_old/train/security/engine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key/cargo_train))
		if(!key)
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			key = W
			add_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/remove_key)
		return
	..()

/obj/vehicle_old/train/security/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access rights

	..()

/obj/vehicle_old/train/security/engine/turn_on()
	if(!key)
		return
	else
		..()
		update_stats()

		remove_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/stop_engine)
		remove_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/start_engine)

		if(on)
			add_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/stop_engine)
		else
			add_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/start_engine)

/obj/vehicle_old/train/security/engine/turn_off()
	..()

	remove_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/stop_engine)
	remove_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/start_engine)

	if(!on)
		add_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/start_engine)
	else
		add_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/stop_engine)

/obj/vehicle_old/train/security/engine/RunOver(var/mob/living/M)
	..()

	if(is_train_head() && istype(load, /mob/living/carbon/human))
		var/mob/living/carbon/human/D = load
		to_chat(D, "<span class='danger'>You ran over \the [M]!</span>")
		visible_message("<span class='danger'>\The [src] ran over \the [M]!</span>")
		add_attack_logs(D,M,"Ran over with [src.name]")
		attack_log += "\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey]), driven by [D.name] ([D.ckey])</font>"
	else
		attack_log += "\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey])</font>"

/obj/vehicle_old/train/security/engine/examine(mob/user, dist)
	. = ..()
	. += "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
	var/obj/item/cell/cell = get_cell()
	. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"

/obj/vehicle_old/train/security/engine/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(is_train_head())
		if(direction == global.reverse_dir[dir] && tow)
			return 0
		if(Move(get_step(src, direction)))
			return 1
		return 0
	else
		return ..()

/obj/vehicle_old/train/security/engine/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		to_chat(usr, "The engine is already running.")
		return

	turn_on()
	if (on)
		to_chat(usr, "You start [src]'s engine.")
	else
		var/obj/item/cell/cell = get_cell()
		if(cell.charge < charge_use)
			to_chat(usr, "[src] is out of power.")
		else
			to_chat(usr, "[src]'s engine won't start.")

/obj/vehicle_old/train/security/engine/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		to_chat(usr, "The engine is already stopped.")
		return

	turn_off()
	if (!on)
		to_chat(usr, "You stop [src]'s engine.")

/obj/vehicle_old/train/security/engine/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_held_item())
		usr.put_in_hands(key)
	key = null

	remove_obj_verb(src, /obj/vehicle_old/train/security/engine/verb/remove_key)

/obj/vehicle_old/train/security/engine/load(var/atom/movable/C)
	if(!istype(C, /mob/living/carbon/human))
		return 0

	return ..()

/obj/vehicle_old/train/security/engine/latch(obj/vehicle_old/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle_old/train/security/trolley))
		T.attach_to(src, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(global.reverse_dir[dir] == T_dir)	//else if car is behind
			T.attach_to(src, user)

//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle_old/train/security/engine/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	//Update move delay
	if(!is_train_head() || !on)
		move_delay = initial(move_delay)		//so that engines that have been turned off don't lag behind
	else
		move_delay = max(0, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you cant overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)
		move_delay += 2 														//base reference speed
		move_delay *= 1.1																	//makes cargo trains 10% slower than running when not overweight
