/obj/vehicle/ridden/cart/cargo
	name = "cargo train tug"
	desc = "A ridable electric car designed for pulling cargo trolleys."
	icon_state = "cargo_engine"
	key_type = /obj/item/key/cargo_train
	trailer_type = /obj/vehicle/trailer/cargo

/obj/item/key/cargo_train
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = WEIGHT_CLASS_TINY

/obj/vehicle/trailer/cargo
	name = "cargo train trolley"
	desc = "A trolley designed to be pulled by a cargo train tug."
	icon_state = "cargo_trailer"
	trailer_type = /obj/vehicle/trailer/cargo

/*
///! Old shit
/obj/vehicle_old/train/engine/latch(obj/vehicle_old/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle_old/train/trolley))
		T.attach_to(src, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(global.reverse_dir[dir] == T_dir)	//else if car is behind
			T.attach_to(src, user)

/obj/vehicle_old/train/Initialize(mapload)
	. = ..()
	for(var/obj/vehicle_old/train/T in orange(1, src))
		latch(T)

/obj/vehicle_old/train/MouseDroppedOnLegacy(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !CHECK_MOBILITY(user, MOBILITY_CAN_MOVE)))
		return
	if(istype(C,/obj/vehicle_old/train))
		latch(C, user)
	else
		if(!load(C, user))
			to_chat(user, "<font color='red'>You were unable to load [C] on [src].</font>")
			return CLICKCHAIN_DO_NOT_PROPAGATE
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/vehicle_old/train/proc/attach_to(obj/vehicle_old/train/T, mob/user)
	if (get_dist(src, T) > 1)
		to_chat(user, "<font color='red'>[src] is too far away from [T] to hitch them together.</font>")
		return

	if (lead)
		to_chat(user, "<font color='red'>[src] is already hitched to something.</font>")
		return

	if (T.tow)
		to_chat(user, "<font color='red'>[T] is already towing something.</font>")
		return

	//check for cycles.
	var/obj/vehicle_old/train/next_car = T
	while (next_car)
		if (next_car == src)
			to_chat(user, "<font color='red'>That seems very silly.</font>")
			return
		next_car = next_car.lead

	//latch with src as the follower
	lead = T
	T.tow = src
	setDir(lead.dir)

	if(user)
		to_chat(user, "<font color=#4F49AF>You hitch [src] to [T].</font>")

	update_stats()


///! Old unattaching shit
//detaches the train from whatever is towing it
/obj/vehicle_old/train/proc/unattach(mob/user)
	if (!lead)
		to_chat(user, "<font color='red'>[src] is not hitched to anything.</font>")
		return

	lead.tow = null
	lead.update_stats()

	to_chat(user, "<font color=#4F49AF>You unhitch [src] from [lead].</font>")
	lead = null

	update_stats()

/obj/vehicle_old/train/explode()
	if (tow)
		tow.unattach()
	unattach()
	..()

/obj/vehicle_old/train/verb/unlatch_v()
	set name = "Unlatch"
	set desc = "Unhitches this train from the one in front of it."
	set category = "Vehicle"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE) || !Adjacent(usr))
		return

	unattach(usr)

/obj/vehicle_old/train/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(tow && ((get_dist(tow, old_loc) > 1) || !tow.Move(old_loc)))
		tow.unattach()
*/
