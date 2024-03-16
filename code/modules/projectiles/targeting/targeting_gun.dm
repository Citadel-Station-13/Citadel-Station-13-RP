//Removing the lock and the buttons.
/obj/item/gun/dropped(mob/user, flags, atom/newLoc)
	var/mob/living/L = user
	if(istype(L))
		L.stop_aiming(src)
	return ..()

/obj/item/gun/equipped(mob/user, slot)
	var/mob/living/L = user
	if(istype(L) && (slot != SLOT_ID_HANDS))
		L.stop_aiming(src)
	return ..()

//Compute how to fire.....
//Return 1 if a target was found, 0 otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	if(!user.aiming)
		user.aiming = new(user)
	user.face_atom(A)
	if(ismob(A) && user.aiming)
		user.aiming.aim_at(A, src)
		if(!isliving(A))
			return 0
		return 1
	return 0
