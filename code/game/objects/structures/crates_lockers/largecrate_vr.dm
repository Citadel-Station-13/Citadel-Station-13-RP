/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)
		new /mob/living/simple_mob/animal/passive/bird(src)
		new /mob/living/simple_mob/animal/passive/bird/kea(src)
		new /mob/living/simple_mob/animal/passive/bird/eclectus(src)
		new /mob/living/simple_mob/animal/passive/bird/greybird(src)
		new /mob/living/simple_mob/animal/passive/bird/eclectusf(src)
		new /mob/living/simple_mob/animal/passive/bird/blue_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/white_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/green_budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/blue_Budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/bluegreen_Budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/commonblackbird(src)
		new /mob/living/simple_mob/animal/passive/bird/azuretit(src)
		new /mob/living/simple_mob/animal/passive/bird/europeanrobin(src)
		new /mob/living/simple_mob/animal/passive/bird/goldcrest(src)
		new /mob/living/simple_mob/animal/passive/bird/ringneckdove(src)
		new /mob/living/simple_mob/animal/passive/bird/cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/white_cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/yellowish_cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/grey_cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/too(src)
		new /mob/living/simple_mob/animal/passive/bird/hooded_too(src)
		new /mob/living/simple_mob/animal/passive/bird/pink_too(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/* TEMPORARY REMOVAL - READD ALL THESE ASAP
/obj/structure/largecrate/animal/pred
	name = "Predator carrier"
	starts_with = list(/mob/living/simple_mob/catgirl)

/obj/structure/largecrate/animal/pred/Initialize() //This is nessesary to get a random one each time.
	starts_with = list(pick(/mob/living/simple_mob/retaliate/bee,
						/mob/living/simple_mob/catgirl;3,
						/mob/living/simple_mob/hostile/frog,
						/mob/living/simple_mob/horse,
						/mob/living/simple_mob/hostile/panther,
						/mob/living/simple_mob/hostile/giant_snake,
						/mob/living/simple_mob/hostile/wolf,
						/mob/living/simple_mob/hostile/bear;0.5,
						/mob/living/simple_mob/hostile/bear/brown;0.5,
						/mob/living/simple_mob/animal/space/carp,
						/mob/living/simple_mob/hostile/mimic,
						/mob/living/simple_mob/hostile/rat,
						/mob/living/simple_mob/hostile/rat/passive,
						/mob/living/simple_mob/otie;0.5))
	return ..()

/obj/structure/largecrate/animal/dangerous
	name = "Dangerous Predator carrier"
	starts_with = list(/mob/living/simple_mob/animal/space/alien)

/obj/structure/largecrate/animal/dangerous/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/animal/space/carp/pike,
						/mob/living/simple_mob/hostile/deathclaw,
						/mob/living/simple_mob/hostile/dino,
						/mob/living/simple_mob/animal/space/alien,
						/mob/living/simple_mob/animal/space/alien/drone,
						/mob/living/simple_mob/animal/space/alien/sentinel,
						/mob/living/simple_mob/animal/space/alien/queen,
						/mob/living/simple_mob/otie/feral,
						/mob/living/simple_mob/otie/red,
						/mob/living/simple_mob/hostile/corrupthound))
	return ..()
*/

/obj/structure/largecrate/animal/guardbeast
	name = "VARMAcorp autoNOMous security solution"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_mob/otie/security)

/obj/structure/largecrate/animal/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments."
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs. This one can survive hostile atmosphere."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_mob/otie/security/phoron)

/obj/structure/largecrate/animal/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	desc = "A warning on the side says the creature inside was returned to the supplier after injuring or devouring several unlucky members of the previous adoption family. It was given a second chance with the next customer. Godspeed and good luck with your new pet!"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "otiecrate2"
	starts_with = list(/mob/living/simple_mob/otie/cotie)
	var/taped = 1

/obj/structure/largecrate/animal/otie/phoron
	name = "VARMAcorp adaptive beta subject (Experimental)"
	desc = "VARMAcorp experimental hostile environment adaptive breeding development kit. WARNING, DO NOT RELEASE IN WILD!"
	starts_with = list(/mob/living/simple_mob/otie/cotie/phoron)

/obj/structure/largecrate/animal/otie/phoron/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/otie/cotie/phoron;2,
						/mob/living/simple_mob/otie/red/friendly;0.5))
	return ..()

/obj/structure/largecrate/animal/otie/attack_hand(mob/living/carbon/human/M as mob)//I just couldn't decide between the icons lmao
	if(taped == 1)
		playsound(src, 'sound/items/poster_ripped.ogg', 50, 1)
		icon_state = "otiecrate"
		taped = 0
	..()

/* TEMPORARY REMOVAL
/obj/structure/largecrate/animal/catgirl
	name = "Catgirl Crate"
	desc = "A sketchy looking crate with airholes that seems to have had most marks and stickers removed. You can almost make out 'genetically-engineered subject' written on it."
	starts_with = list(/mob/living/simple_mob/catgirl)

/obj/structure/largecrate/animal/wolfgirl
	name = "Wolfgirl Crate"
	desc = "A sketchy looking crate with airholes that shakes and thuds every now and then. Someone seems to be demanding they be let out."
	starts_with = list(/mob/living/simple_mob/retaliate/wolfgirl)
*/


/obj/structure/largecrate/animal/fennec
	name = "Fennec Crate"
	desc = "Bounces around a lot. Looks messily packaged, were they in a hurry?"
	starts_with = list(/mob/living/simple_mob/fennec)

/obj/structure/largecrate/animal/fennec/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/fennec,
						/mob/living/simple_mob/retaliate/fennix;0.5))
	return ..()
