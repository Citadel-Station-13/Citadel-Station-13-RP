/obj/vehicle/ridden
	name = "ridden vehicle"
	// todo: i wish byond planes weren't monolithic and awful but we should probably have a proper plane system haha.
	plane = MOB_PLANE
	buckle_allowed = TRUE
	buckle_max_mobs = 1
	buckle_lying = FALSE
	default_driver_move = FALSE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW
	var/riding_filter_type = /datum/component/riding_filter/vehicle
	var/riding_handler_type

/obj/vehicle/ridden/Initialize(mapload)
	. = ..()
	AddComponent(riding_filter_type, riding_handler_type)

/obj/vehicle/ridden/examine(mob/user)
	. = ..()
	if(key_type)
		if(!inserted_key)
			. += "<span class='notice'>Put a key inside it by clicking it with the key.</span>"
		else
			. += "<span class='notice'>Alt-click [src] to remove the key.</span>"

/obj/vehicle/ridden/generate_action_type(actiontype)
	var/datum/action/vehicle/ridden/A = ..()
	. = A
	if(istype(A))
		A.vehicle_ridden_target = src

/obj/vehicle/ridden/mob_unbuckled(mob/M, flags, mob/user, semantic)
	remove_occupant(M)
	return ..()

/obj/vehicle/ridden/mob_buckled(mob/M, flags, mob/user, semantic)
	add_occupant(M)
	/*
	if(M.get_num_legs() < legs_required)
		to_chat(M, "<span class='warning'>You don't have enough legs to operate the pedals!</span>")
		unbuckle_mob(M)
	*/
	return ..()

/obj/vehicle/ridden/attackby(obj/item/I, mob/user, params)
	if(key_type && !is_key(inserted_key) && is_key(I))
		if(user.transfer_item_to_loc(I, src))
			to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span>")
			if(inserted_key)	//just in case there's an invalid key
				inserted_key.forceMove(drop_location())
			inserted_key = I
		else
			to_chat(user, "<span class='notice'>[I] seems to be stuck to your hand!</span>")
		return
	return ..()

/obj/vehicle/ridden/AltClick(mob/user)
	. = ..()
	if(inserted_key && user.Adjacent(src) && !user.incapacitated())
		if(!is_occupant(user))
			to_chat(user, "<span class='notice'>You must be riding the [src] to remove [src]'s key!</span>")
			return
		to_chat(user, "<span class='notice'>You remove \the [inserted_key] from \the [src].</span>")
		inserted_key.forceMove(drop_location())
		user.put_in_hands(inserted_key)
		inserted_key = null
		return TRUE

/obj/vehicle/ridden/proc/drive_check(mob/user)
	if(key_type && !is_key(inserted_key))
		to_chat(user, SPAN_WARNING("[src] has no key inserted."))
		return FALSE
	return TRUE
