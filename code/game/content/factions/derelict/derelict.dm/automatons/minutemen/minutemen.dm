/mob/living/simple_mob/mechanical/derelict/minuteman
	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/minutemen.dmi'
	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS


/mob/living/simple_mob/mechanical/derelict/minuteman/death()
	..()
	visible_message(SPAN_WARNING("\The [src] suddenly explodes into a shower of gore and metal!"))
	new /obj/effect/debris/cleanable/blood/gibs(src.loc)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)


/mob/living/simple_mob/mechanical/derelict/minuteman/wasp
	name = "minuteman wasp"
	desc = "A small drone that hovers over the ground. Its frame appears small and delicate, however it twitches and moves around incessantly."

	icon_state = "wasp"
	icon_living = "wasp"


	health = 120
	maxHealth = 120
	movement_base_speed = 10 / 2
	density = 0
	hovering = TRUE


	base_attack_cooldown = 6
	legacy_melee_damage_upper = 15
	legacy_melee_damage_lower = 15



