//Crazy alternate human stuff
/mob/living/carbon/human/New()
	. = ..()

	var/animal = pick("cow","chicken_brown", "chicken_black", "chicken_white", "chick", "mouse_brown", "mouse_gray", "mouse_white", "lizard", "cat2", "goose", "penguin")
	var/image/img = image('icons/mob/animal.dmi', src, animal)
	img.override = TRUE
	add_alt_appearance("animals", img, displayTo = alt_farmanimals)

/mob/living/carbon/human/Destroy()
	alt_farmanimals -= src

	. = ..()

//Human overrides for Human piggybacking
/mob/living/carbon/human
	var/human = TRUE


/datum/riding/human
	keytype = /obj/item/weapon/material/twohanded/fluff/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being ridden would be called.
	only_one_driver = TRUE			// Allows for the person riding to steer the carrier when holding a riding crop :toolewd:

/datum/riding/human/handle_vehicle_layer()
	if(ridden.has_buckled_mobs())
		if(ridden.dir != NORTH)
			ridden.layer = ABOVE_MOB_LAYER
		else
			ridden.layer = initial(ridden.layer)
	else
		ridden.layer = initial(ridden.layer)

/datum/riding/human/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/human/force_dismount(mob/M)
	. =..()
	ridden.visible_message("<span class='notice'>[M] hops off of [ridden]'s back!</span>")

/datum/riding/human/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/L = ridden
	var/scale = L.size_multiplier

	var/list/values = list(
		"[NORTH]" = list(0, 8*scale, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, 8*scale, BELOW_MOB_LAYER),
		"[EAST]" = list(-5*scale, 8*scale, ABOVE_MOB_LAYER),
		"[WEST]" = list(5*scale, 8*scale, ABOVE_MOB_LAYER))

	return values

/mob/living/carbon/human
	max_buckled_mobs = 1
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

/mob/living/carbon/human/New(loc,var/unfinished = 0)
	..()
	riding_datum = new /datum/riding/human(src)

/mob/living/carbon/human/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..()
	if(!human)
		return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src,"<span class='warning'>They're too big, you'll be crushed! You'll need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(isTaurTail(H.tail_style))
		to_chat(src,"<span class='warning'>How am I supposed to carry that? There's too many legs..</span>")
		return FALSE
	if(M.loc != src.loc)
		if(M.Adjacent(src))
			M.forceMove(get_turf(src))

	. = ..()
	if(.)
		buckled_mobs[M] = "riding"

/mob/living/carbon/human/attack_hand(mob/user as mob)
	if(LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()

/mob/living/carbon/human/proc/human_mount(var/mob/living/M in living_mobs(1))
	set name = "Mount/Dismount toggle"
	set category = "Abilities"
	set desc = "Let people piggyback on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message("<span class='notice'>[M] hops onto [name]'s back!</span>")
