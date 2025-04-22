// todo: /bike_horn
/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_HOLSTER
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0

/obj/item/bikehorn/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"
	var/flip_cooldown = 0

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"

/*
/obj/item/bikehorn/golden/attack()
	if(flip_cooldown < world.time)
		flip_mobs()
	return ..()

/obj/item/bikehorn/golden/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(flip_cooldown < world.time)
		flip_mobs()
	..()

/obj/item/bikehorn/golden/proc/flip_mobs(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.emote("flip")
	flip_cooldown = world.time + 7
*/
