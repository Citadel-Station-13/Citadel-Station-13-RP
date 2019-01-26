
// Riding
/datum/riding/simple_mob
	keytype = /obj/item/weapon/material/twohanded/fluff/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/simple_mob/handle_vehicle_layer()
	ridden.layer = initial(ridden.layer)

/datum/riding/simple_mob/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/simple_mob/force_dismount(mob/M)
	. =..()
	ridden.visible_message("<span class='notice'>[M] stops riding [ridden]!</span>")

/datum/riding/simple_mob/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/simple_mob/L = ridden
	var/scale = L.size_multiplier

	var/list/values = list(
		"[NORTH]" = list(0, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, L.mount_offset_y*scale, BELOW_MOB_LAYER),
		"[EAST]" = list(-L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[WEST]" = list(L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER))

	return values


/mob/living/simple_mob/attack_hand(mob/user as mob)
	if(riding_datum && LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()

/mob/living/simple_mob/proc/animal_mount(var/mob/living/M in living_mobs(1))
	set name = "Animal Mount/Dismount"
	set category = "Abilities"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message("<span class='notice'>[M] starts riding [name]!</span>")


/mob/living/simple_mob/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(!riding_datum)
		return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src,"<span class='warning'>This isn't a pony show! You need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(H.loc != src.loc)
		if(H.Adjacent(src))
			H.forceMove(get_turf(src))

	. = ..()
	if(.)
		buckled_mobs[H] = "riding"
