////////////////////////////
//		Proteon
////////////////////////////

/datum/category_item/catalogue/fauna/construct/proteon
	name = "Constructs - Proteon"
	desc = "These curious Constructs, referred to as Proteons in captured texts, \
	are considerably more fragile than other obsidian statues. Fielded in large numbers \
	as cannon fodder, Proteons often serve as shields for more powerful Constructs, and \
	seem to naturally employ screening tactics to this end. It is unknown if they are \
	intelligent, or are more akin to Paranatural drones."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/proteon //Weak Swarm Attacker can be safely dumped on players in large numbers without too many injuries
	name = "Proteon"
	real_name = "proton"
	construct_type = "artificer"
	desc = "A weak but speedy construction designed to assist other constructs rather than fight. Still seems bloodthirtsy though."
	icon_state = "proteon"
	icon_living = "proteon"
	maxHealth = 50
	health = 50
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 8 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 10
	attack_armor_pen = 50 // Does so little damage already, that this can be justified.
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 0
	catalogue_data = list(/datum/category_item/catalogue/fauna/construct/proteon)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/construct/proteon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura)
