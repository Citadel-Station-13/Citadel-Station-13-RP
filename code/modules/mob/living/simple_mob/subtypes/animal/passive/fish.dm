// Different types of fish! They are all subtypes of this tho
/mob/living/simple_mob/animal/passive/fish
	name = "fish"
	desc = "Its a fishy.  No touchy fishy."
	icon = 'icons/mob/fish.dmi'

	mob_size = MOB_SMALL
	// So fish are actually underwater.
	plane = TURF_PLANE
	layer = UNDERWATER_LAYER

	// By default they can be in any water turf.  Subtypes might restrict to deep/shallow etc
	var/global/list/suitable_turf_types =  list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/water
	)

// Makes the AI unable to willingly go on land.
/mob/living/simple_mob/animal/passive/fish/IMove(newloc)
	if(is_type_in_list(newloc, suitable_turf_types))
		return ..() // Procede as normal.
	return MOVEMENT_FAILED // Don't leave the water!

// Take damage if we are not in water
/mob/living/simple_mob/animal/passive/fish/handle_breathing()
	var/turf/T = get_turf(src)
	if(T && !is_type_in_list(T, suitable_turf_types))
		if(prob(50))
			say(pick("Blub", "Glub", "Burble"))
		adjustBruteLoss(unsuitable_atoms_damage)

// Subtypes.
/mob/living/simple_mob/animal/passive/fish/bass
	name = "bass"
	tt_desc = "E Micropterus notius"
	icon_state = "bass-swim"
	icon_living = "bass-swim"
	icon_dead = "bass-dead"

/mob/living/simple_mob/animal/passive/fish/trout
	name = "trout"
	tt_desc = "E Salmo trutta"
	icon_state = "trout-swim"
	icon_living = "trout-swim"
	icon_dead = "trout-dead"

/mob/living/simple_mob/animal/passive/fish/salmon
	name = "salmon"
	tt_desc = "E Oncorhynchus nerka"
	icon_state = "salmon-swim"
	icon_living = "salmon-swim"
	icon_dead = "salmon-dead"

/mob/living/simple_mob/animal/passive/fish/perch
	name = "perch"
	tt_desc = "E Perca flavescens"
	icon_state = "perch-swim"
	icon_living = "perch-swim"
	icon_dead = "perch-dead"

/mob/living/simple_mob/animal/passive/fish/pike
	name = "pike"
	tt_desc = "E Esox aquitanicus"
	icon_state = "pike-swim"
	icon_living = "pike-swim"
	icon_dead = "pike-dead"

/mob/living/simple_mob/animal/passive/fish/koi
	name = "koi"
	tt_desc = "E Cyprinus rubrofuscus"
	icon_state = "koi-swim"
	icon_living = "koi-swim"
	icon_dead = "koi-dead"

/mob/living/simple_mob/animal/passive/fish/koi/poisonous
	desc = "A genetic marvel, combining the docility and aesthetics of the koi with some of the resiliency and cunning of the noble space carp."
	health = 50
	maxHealth = 50
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/Initialize()
	. = ..()
	create_reagents(60)
	reagents.add_reagent("toxin", 45)
	reagents.add_reagent("impedrezene", 15)

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/Life()
	..()
	if(isbelly(loc) && prob(10))
		var/obj/belly/B = loc
		sting(B.owner)

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/apply_attack(atom/A)
	sting(A)
	return ..()

/mob/living/simple_animal/fish/koi/poisonous/proc/sting(mob/living/M, silent = FALSE, chance = 75)
	if(prob(chance))
		if(!M.reagents)
			return FALSE
		visible_message("<span class='warning'>\The [src][is_dead()?"'s corpse":""] flails at [M]!</span>")
		SpinAnimation(7,1)
		if(!silent)
			to_chat(M, "<span class='warning'>You feel a tiny prick.</span>")
		M.reagents.add_reagent("toxin", 2)
		M.reagents.add_reagent("impedrezene", 1)
		return TRUE
	return FALSE
