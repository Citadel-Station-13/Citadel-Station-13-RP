/obj/vehicle/sealed
	enclosed = TRUE // you're in a sealed vehicle dont get dinked idiot

/obj/vehicle/sealed/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!istype(dropping) || !isliving(user) || !user.Reachability(src) || !Adjacent(dropping))
		return ..()
	if(user == dropping)
		mob_try_enter(user)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/vehicle/sealed/attackby(obj/item/I, mob/user, params)
	if(key_type && !is_key(inserted_key) && is_key(I))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		if(inserted_key)	//just in case there's an invalid key
			inserted_key.forceMove(drop_location())
		inserted_key = I
		return
	return ..()

/obj/vehicle/sealed/proc/remove_key(mob/user)
	if(!inserted_key)
		to_chat(user, "<span class='notice'>There is no key in [src]!</span>")
		return
	if(!is_occupant(user) || !(occupants[user] & VEHICLE_CONTROL_DRIVE))
		to_chat(user, "<span class='notice'>You must be driving [src] to remove [src]'s key!</span>")
		return
	to_chat(user, "<span class='notice'>You remove [inserted_key] from [src].</span>")
	inserted_key.forceMove(drop_location())
	user.put_in_hands(inserted_key)
	inserted_key = null

/obj/vehicle/sealed/Destroy()
	DumpMobs()
	return ..()

/obj/vehicle/sealed/proc/DumpMobs(randomstep = TRUE)
	for(var/i in occupants)
		mob_exit(i)
		if(iscarbon(i))
			var/mob/living/carbon/Carbon = i
			Carbon.default_combat_knockdown(40)

/obj/vehicle/sealed/proc/DumpSpecificMobs(flag, randomstep = TRUE)
	for(var/i in occupants)
		if((occupants[i] & flag))
			mob_exit(i, null, randomstep)
			if(iscarbon(i))
				var/mob/living/carbon/C = i
				C.default_combat_knockdown(40)

/obj/vehicle/sealed/AllowDrop()
	return FALSE

/obj/vehicle/sealed/setDir(newdir)
	. = ..()
	for(var/k in occupants)
		var/mob/M = k
		M.setDir(newdir)
