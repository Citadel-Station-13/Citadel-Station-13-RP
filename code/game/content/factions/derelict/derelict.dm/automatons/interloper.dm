/mob/living/simple_mob/mechanical/derelict/interloper
	name = "Interloper"
	desc = "A lithe machine that hovers over the ground utilizing a method you cannot recognize. Some sort of monochrome 'flame' can be seen emerging from its arms and head."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/interloper.dmi'
	icon_state = "interloper"
	icon_living = "interloper"
	icon_dead = "interloper_dead"

	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS
	health = 300
	maxHealth = 300
	self_rejuvination = TRUE
	movement_base_speed = 10 / 3
	hovering = TRUE

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


/mob/living/simple_mob/mechanical/derelict/interloper/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/impenetrable(src)
	return ..()

/mob/living/simple_mob/mechanical/derelict/interloper/Destroy()
	QDEL_NULL(shields)
	return ..()
