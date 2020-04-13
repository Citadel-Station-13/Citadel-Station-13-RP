/mob/living/simple_animal/lizard
	no_vore = 1

/mob/living/simple_animal/lizard/attack_hand(mob/living/hander)
	src.get_scooped(hander)

/mob/living/simple_animal/solargrub_larva/attack_hand(mob/living/hander) //adding solargrub pickups in here instead of adding yet another thing to include
	src.get_scooped(hander)

