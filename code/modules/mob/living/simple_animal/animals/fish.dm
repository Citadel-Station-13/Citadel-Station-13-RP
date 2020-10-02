// Different types of fish! They are all subtypes of this tho
/mob/living/simple_mob/fish
	name = "fish"
	desc = "Its a fishy.  No touchy fishy."
	icon = 'icons/mob/fish.dmi'
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	intelligence_level = SA_ANIMAL

	// By defautl they can be in any water turf.  Subtypes might restrict to deep/shallow etc
	var/global/list/suitable_turf_types =  list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/water
	)

// Don't swim out of the water
/mob/living/simple_mob/fish/handle_wander_movement()
	if(isturf(src.loc) && !resting && !buckled && canmove) //Physically capable of moving?
		lifes_since_move++ //Increment turns since move (turns are life() cycles)
		if(lifes_since_move >= turns_per_move)
			if(!(stop_when_pulled && pulledby)) //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				dir = moving_to			//How about we turn them the direction they are moving, yay.
				var/turf/T = get_step(src,moving_to)
				if(T && is_type_in_list(T, suitable_turf_types))
					Move(T)
					lifes_since_move = 0

// Take damage if we are not in water
/mob/living/simple_mob/fish/handle_breathing()
	var/turf/T = get_turf(src)
	if(T && !is_type_in_list(T, suitable_turf_types))
		if(prob(50))
			say(pick("Blub", "Glub", "Burble"))
		adjustBruteLoss(unsuitable_atoms_damage)

/mob/living/simple_mob/fish/bass
	name = "bass"
	tt_desc = "E Micropterus notius"
	icon_state = "bass-swim"
	icon_living = "bass-swim"
	icon_dead = "bass-dead"

/mob/living/simple_mob/fish/trout
	name = "trout"
	tt_desc = "E Salmo trutta"
	icon_state = "trout-swim"
	icon_living = "trout-swim"
	icon_dead = "trout-dead"

/mob/living/simple_mob/fish/salmon
	name = "salmon"
	tt_desc = "E Oncorhynchus nerka"
	icon_state = "salmon-swim"
	icon_living = "salmon-swim"
	icon_dead = "salmon-dead"

/mob/living/simple_mob/fish/perch
	name = "perch"
	tt_desc = "E Perca flavescens"
	icon_state = "perch-swim"
	icon_living = "perch-swim"
	icon_dead = "perch-dead"

/mob/living/simple_mob/fish/pike
	name = "pike"
	tt_desc = "E Esox aquitanicus"
	icon_state = "pike-swim"
	icon_living = "pike-swim"
	icon_dead = "pike-dead"

/mob/living/simple_mob/fish/koi
	name = "koi"
	tt_desc = "E Cyprinus rubrofuscus"
	icon_state = "koi-swim"
	icon_living = "koi-swim"
	icon_dead = "koi-dead"

/mob/living/simple_mob/fish/koi/poisonous
	desc = "A genetic marvel, combining the docility and aesthetics of the koi with some of the resiliency and cunning of the noble space carp."
	health = 50
	maxHealth = 50

/mob/living/simple_mob/fish/koi/poisonous/New()
	..()
	create_reagents(60)
	reagents.add_reagent("toxin", 45)
	reagents.add_reagent("impedrezene", 15)

/mob/living/simple_mob/fish/koi/poisonous/Life()
	..()
	if(isbelly(loc) && prob(10))
		var/obj/belly/B = loc
		sting(B.owner)

/mob/living/simple_mob/fish/koi/poisonous/react_to_attack(var/atom/A)
	if(isliving(A) && Adjacent(A))
		var/mob/living/M = A
		visible_message("<span class='warning'>\The [src][is_dead()?"'s corpse":""] flails at [M]!</span>")
		SpinAnimation(7,1)
		if(prob(75))
			if(sting(M))
				to_chat(M, "<span class='warning'>You feel a tiny prick.</span>")
		if(is_dead())
			return
		for(var/i = 1 to 3)
			var/turf/T = get_step_away(src, M)
			if(T && is_type_in_list(T, suitable_turf_types))
				Move(T)
			else
				break
			sleep(3)

/mob/living/simple_mob/fish/koi/poisonous/proc/sting(var/mob/living/M)
	if(!M.reagents)
		return FALSE
	M.reagents.add_reagent("toxin", 2)
	M.reagents.add_reagent("impedrezene", 1)
	return 1
