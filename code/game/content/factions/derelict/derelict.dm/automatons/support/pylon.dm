/mob/living/simple_mob/mechanical/derelict/pylon
	name = "pylon"
	desc = "Something that resembles a hovering cylinder. Vivid green lights flash across every one of its surfaces, forming patterns you do not recognize."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/anchor.dmi'
	icon_state = "pylon"
	icon_living = "pylon"


	health = 150
	maxHealth = 150
	movement_base_speed = 10 / 4
	hovering = TRUE


	base_attack_cooldown = 6
	legacy_melee_damage_upper = 0
	legacy_melee_damage_lower = 0

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/inert

	var/obj/item/shield_projector/shields = null

/obj/item/shield_projector/rectangle/automatic/impenetrable
	shield_health = 99999
	max_shield_health = 99999
	shield_regen_delay = 1 SECONDS
	shield_regen_amount = 1000
	color = "#3f3f3f"
	high_color = "#3f3f3f"
	low_color = "#3f3f3f"
	light_color = "#3f3f3f"


/mob/living/simple_mob/mechanical/derelict/pylon/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/impenetrable(src)
	return ..()

/mob/living/simple_mob/mechanical/derelict/pylon/Destroy()
	QDEL_NULL(shields)
	return ..()

/mob/living/simple_mob/mechanical/derelict/pylon/death()
	..()
	visible_message(SPAN_BOLDWARNING("\The [src] destabilizes before exploding into a cloud of gore and metal!"))
	new /obj/effect/debris/cleanable/blood/gibs(src.loc)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
