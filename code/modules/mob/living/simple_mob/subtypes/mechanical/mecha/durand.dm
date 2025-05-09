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
