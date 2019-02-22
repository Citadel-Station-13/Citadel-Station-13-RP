/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)
<<<<<<< HEAD
		new /mob/living/simple_animal/bird(src)
		new /mob/living/simple_animal/bird/kea(src)
		new /mob/living/simple_animal/bird/eclectus(src)
		new /mob/living/simple_animal/bird/greybird(src)
		new /mob/living/simple_animal/bird/eclectusf(src)
		new /mob/living/simple_animal/bird/blue_caique(src)
		new /mob/living/simple_animal/bird/white_caique(src)
		new /mob/living/simple_animal/bird/green_budgerigar(src)
		new /mob/living/simple_animal/bird/blue_Budgerigar(src)
		new /mob/living/simple_animal/bird/bluegreen_Budgerigar(src)
		new /mob/living/simple_animal/bird/commonblackbird(src)
		new /mob/living/simple_animal/bird/azuretit(src)
		new /mob/living/simple_animal/bird/europeanrobin(src)
		new /mob/living/simple_animal/bird/goldcrest(src)
		new /mob/living/simple_animal/bird/ringneckdove(src)
		new /mob/living/simple_animal/bird/cockatiel(src)
		new /mob/living/simple_animal/bird/white_cockatiel(src)
		new /mob/living/simple_animal/bird/yellowish_cockatiel(src)
		new /mob/living/simple_animal/bird/grey_cockatiel(src)
		new /mob/living/simple_animal/bird/too(src)
		new /mob/living/simple_animal/bird/hooded_too(src)
		new /mob/living/simple_animal/bird/pink_too(src)
=======
		new /mob/living/simple_mob/animal/passive/bird(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/kea(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/eclectus(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen(src)
		new /mob/living/simple_mob/animal/passive/bird/black_bird(src)
		new /mob/living/simple_mob/animal/passive/bird/azure_tit(src)
		new /mob/living/simple_mob/animal/passive/bird/european_robin(src)
		new /mob/living/simple_mob/animal/passive/bird/goldcrest(src)
		new /mob/living/simple_mob/animal/passive/bird/ringneck_dove(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo(src)
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/animal/pred
	name = "Predator carrier"
<<<<<<< HEAD
	starts_with = list(/mob/living/simple_animal/catgirl)

/obj/structure/largecrate/animal/pred/initialize() //This is nessesary to get a random one each time.
	starts_with = list(pick(/mob/living/simple_animal/retaliate/bee,
						/mob/living/simple_animal/catgirl;3,
						/mob/living/simple_animal/hostile/frog,
						/mob/living/simple_animal/horse,
						/mob/living/simple_animal/hostile/panther,
						/mob/living/simple_animal/hostile/giant_snake,
						/mob/living/simple_animal/hostile/wolf,
						/mob/living/simple_animal/hostile/bear;0.5,
						/mob/living/simple_animal/hostile/bear/brown;0.5,
						/mob/living/simple_animal/hostile/carp,
						/mob/living/simple_animal/hostile/mimic,
						/mob/living/simple_animal/hostile/rat,
						/mob/living/simple_animal/hostile/rat/passive,
						/mob/living/simple_animal/otie;0.5))
=======
	starts_with = list(/mob/living/simple_mob/vore/catgirl)

/obj/structure/largecrate/animal/pred/initialize() //This is nessesary to get a random one each time.
	starts_with = list(pick(/mob/living/simple_mob/vore/bee,
						/mob/living/simple_mob/vore/catgirl;3,
						/mob/living/simple_mob/vore/frog,
						/mob/living/simple_mob/horse,
						/mob/living/simple_mob/vore/panther,
						/mob/living/simple_mob/vore/giant_snake,
						/mob/living/simple_mob/vore/wolf,
						/mob/living/simple_mob/animal/space/bear;0.5,
						/mob/living/simple_mob/animal/space/carp,
						/mob/living/simple_mob/animal/space/mimic,
						/mob/living/simple_mob/vore/rat,
						/mob/living/simple_mob/vore/rat/passive,
//						/mob/living/simple_mob/otie;0.5
						))
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735
	return ..()

/obj/structure/largecrate/animal/dangerous
	name = "Dangerous Predator carrier"
<<<<<<< HEAD
	starts_with = list(/mob/living/simple_animal/hostile/alien)

/obj/structure/largecrate/animal/dangerous/initialize()
	starts_with = list(pick(/mob/living/simple_animal/hostile/carp/pike,
						/mob/living/simple_animal/hostile/deathclaw,
						/mob/living/simple_animal/hostile/dino,
						/mob/living/simple_animal/hostile/alien,
						/mob/living/simple_animal/hostile/alien/drone,
						/mob/living/simple_animal/hostile/alien/sentinel,
						/mob/living/simple_animal/hostile/alien/queen,
						/mob/living/simple_animal/otie/feral,
						/mob/living/simple_animal/otie/red,
						/mob/living/simple_animal/hostile/corrupthound))
=======
	starts_with = list(/mob/living/simple_mob/animal/space/alien)

/obj/structure/largecrate/animal/dangerous/initialize()
	starts_with = list(pick(/mob/living/simple_mob/animal/space/carp/large,
						/mob/living/simple_mob/hostile/deathclaw,
						/mob/living/simple_mob/vore/dino,
						/mob/living/simple_mob/animal/space/alien,
						/mob/living/simple_mob/animal/space/alien/drone,
						/mob/living/simple_mob/animal/space/alien/sentinel,
						/mob/living/simple_mob/animal/space/alien/queen,
//						/mob/living/simple_mob/otie/feral,
//						/mob/living/simple_mob/otie/red,
						/mob/living/simple_mob/vore/corrupthound))
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735
	return ..()
/*
/obj/structure/largecrate/animal/guardbeast
	name = "VARMAcorp autoNOMous security solution"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_animal/otie/security)

/obj/structure/largecrate/animal/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments."
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs. This one can survive hostile atmosphere."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_animal/otie/security/phoron)

/obj/structure/largecrate/animal/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	desc = "A warning on the side says the creature inside was returned to the supplier after injuring or devouring several unlucky members of the previous adoption family. It was given a second chance with the next customer. Godspeed and good luck with your new pet!"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "otiecrate2"
	starts_with = list(/mob/living/simple_animal/otie/cotie)
	var/taped = 1

/obj/structure/largecrate/animal/otie/phoron
	name = "VARMAcorp adaptive beta subject (Experimental)"
	desc = "VARMAcorp experimental hostile environment adaptive breeding development kit. WARNING, DO NOT RELEASE IN WILD!"
	starts_with = list(/mob/living/simple_animal/otie/cotie/phoron)

/obj/structure/largecrate/animal/otie/phoron/initialize()
	starts_with = list(pick(/mob/living/simple_animal/otie/cotie/phoron;2,
						/mob/living/simple_animal/otie/red/friendly;0.5))
	return ..()

/obj/structure/largecrate/animal/otie/attack_hand(mob/living/carbon/human/M as mob)//I just couldn't decide between the icons lmao
	if(taped == 1)
		playsound(src, 'sound/items/poster_ripped.ogg', 50, 1)
		icon_state = "otiecrate"
		taped = 0
	..()
*/ //VORESTATION AI REMOVAL, Oties are still fucking broken.

/obj/structure/largecrate/animal/catgirl
	name = "Catgirl Crate"
	desc = "A sketchy looking crate with airholes that seems to have had most marks and stickers removed. You can almost make out 'genetically-engineered subject' written on it."
<<<<<<< HEAD
	starts_with = list(/mob/living/simple_animal/catgirl)
=======
	starts_with = list(/mob/living/simple_mob/vore/catgirl)
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735

/obj/structure/largecrate/animal/wolfgirl
	name = "Wolfgirl Crate"
	desc = "A sketchy looking crate with airholes that shakes and thuds every now and then. Someone seems to be demanding they be let out."
<<<<<<< HEAD
	starts_with = list(/mob/living/simple_animal/retaliate/wolfgirl)
=======
	starts_with = list(/mob/living/simple_mob/vore/wolfgirl)
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735

/obj/structure/largecrate/animal/fennec
	name = "Fennec Crate"
	desc = "Bounces around a lot. Looks messily packaged, were they in a hurry?"
	starts_with = list(/mob/living/simple_animal/fennec)

/obj/structure/largecrate/animal/fennec/initialize()
<<<<<<< HEAD
	starts_with = list(pick(/mob/living/simple_animal/fennec,
						/mob/living/simple_animal/retaliate/fennix;0.5))
=======
	starts_with = list(pick(/mob/living/simple_mob/fennec,
						/mob/living/simple_mob/vore/fennix;0.5))
>>>>>>> 172f208... Merge pull request #4790 from Sebbe9123/upstream-merge-5735
	return ..()
