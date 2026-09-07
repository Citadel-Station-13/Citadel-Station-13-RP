// Durands are slow, tanky, beefy, and hit really hard.
// They can also root themselves to become even tankier.
// The AI doesn't do this currently.

/datum/category_item/catalogue/technology/durand
	name = "Exosuit - Durand"
	desc = "The Durand is an aging combat exosuit designed during the Rye-Egress War. Once considered the most \
	durable exosuit ever developed by Humanity, this platform has long since lost that title. In spite of its age, \
	the Durand remains one of the most well built and armored exosuits on the market. Standing at a towering 12'(3.5m), \
	the exosuit boasts depleted uranium armor paneling and a robust electrical harness capable of powering some of the \
	most fearsome weaponry still in use today. Although modern militaries - both Galactic and Corporate - have since \
	moved on to more contemporary models, the Durand continues to see usage with smaller mercenary bands and SysDef elements."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/durand
	name = "durand"
	desc = "An aging combat exosuit utilized by many corporations. It was originally developed to fight in the Rye-Egress War."
	catalogue_data = list(/datum/category_item/catalogue/technology/durand)
	icon_state = "durand"
	movement_base_speed = 10 / 10
	wreckage = /obj/structure/loot_pile/mecha/durand

	maxHealth = 400
	deflect_chance = 20
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 35,
				"laser"		= 15,
				"energy"	= 10,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 40
	legacy_melee_damage_upper = 40
	base_attack_cooldown = 2 SECONDS
	projectiletype = /obj/projectile/beam/heavylaser

	icon_scale_x = 1.5
	icon_scale_y = 1.5

	var/defense_mode = FALSE
	var/defense_deflect = 35



/mob/living/simple_mob/mechanical/mecha/combat/durand/proc/set_defense_mode(new_mode)
	defense_mode = new_mode
	deflect_chance = defense_mode ? defense_deflect : initial(deflect_chance)
	to_chat(src, SPAN_NOTICE("You [defense_mode ? "en" : "dis"]able defense mode."))

/mob/living/simple_mob/mechanical/mecha/combat/durand/SelfMove(turf/n, direct)
	if(defense_mode)
		to_chat(src, SPAN_WARNING( "You are in defense mode, you cannot move."))
		return FALSE
	return ..()

// So players can toggle it too.
/mob/living/simple_mob/mechanical/mecha/combat/durand/verb/toggle_defense_mode()
	set name = "Toggle Defense Mode"
	set desc = "Toggles a special mode which makes you immobile and much more resilient."
	set category = "Abilities"

	set_defense_mode(!defense_mode)

// Variant that starts in defense mode, perhaps for PoIs.
/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/Initialize(mapload)
	set_defense_mode(TRUE)
	return ..()


/datum/category_item/catalogue/technology/redstar_durand
	name = "Exosuit - Red Star Durand"
	desc = "The quantities of Durand produced for the Rye-Egress war far exceeded the peacetime needs of the militaries of the Orion \
	Confederation. Many were sold to frontier SDFs, especially after the Gygax replaced the Durand as the premerie combat \
	exosuit. During this time, some models of Durand found their ways into the hands of the People's Republic of Adhomai. \
	Since then the People's Republic has made their own knock off the 'Red Star' combat mech, as a centerpiece of its military \
	modernization. The politiburo of the People's Republic fo Adhomai set unrealistic quotas for the production of the new Mechs. \
	As a result the Red Star is plagued with mechanical faults and it is often easier to have the mech replaced entirely then \
	to obtain replacement parts necessary to keep them running. As a result many broken down Red Stars are simply stripped for parts \
	and left where they broke down. Some of the hauls have since been salvaged by pirate and insurgent groups. Revolutionaries \
	aligned with People's Republic interests seem to have uncanny habit of finding these hauls suggesting that this practice could \
	be another covert means in which the People's Republic arms its preferred forgien revolutionaries."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/durand/red_star
	name = "Red Star"
	desc = "The Tajaran knock-off of the classic Durand combat mech. Though a knock-off of a antique, it is still a combat mech."
	catalogue_data = list(/datum/category_item/catalogue/technology/redstar_durand)
	icon_state = "redstar"
	wreckage = /obj/structure/loot_pile/mecha/durand/redstar

	base_attack_cooldown = 0.5 SECONDS
	projectiletype = /obj/projectile/bullet/rifle/a762/ap
