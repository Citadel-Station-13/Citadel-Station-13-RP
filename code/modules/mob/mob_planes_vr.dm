
/////////////////
//AR planemaster does some special image handling
/obj/screen/plane_master/augmented
	plane = PLANE_AUGMENTED
	var/state = FALSE //Saves cost with the lists
	var/mob/my_mob

/obj/screen/plane_master/augmented/New(var/mob/M)
	..()
	my_mob = M

/obj/screen/plane_master/augmented/Destroy()
	my_mob = null
	return ..()

/obj/screen/plane_master/augmented/set_visibility(var/want = FALSE)
	. = ..()
	state = want
	apply()

/obj/screen/plane_master/augmented/proc/apply()
	if(!my_mob.client)
		return

	if(state)
		entopic_users |= my_mob
		if(my_mob.client)
			my_mob.client.images |= entopic_images
	else
		entopic_users -= my_mob
		if(my_mob.client)
			my_mob.client.images -= entopic_images
