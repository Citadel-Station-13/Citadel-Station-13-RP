// Electric spiders fire taser-like beams at their enemies.

/datum/category_item/catalogue/fauna/giant_spider/electric_spider
	name = "Giant Spider - Electric"
	desc = "This specific spider has been catalogued as 'Electric', \
	and it belongs to the 'Guard' caste. \
	<br><br>\
	The spider has a yellow coloration, with a spined back, and possessing bright yellow eyes that flicker. \
	It has evolved to be able to utilize a form of bioelectrogenesis as a means of attack, discharging painful \
	bolts of electricity at their prey to subdue it, before closing in. Their body also has strong insulative \
	properties, presumably to protect the body while using its attack. \
	<br><br>\
	The venom they produce is known to be a stimulant, causing increased agility in speed in those bitten, \
	which would at first appear to hinder the Electric Spider, however the stimulant also causes twitching, \
	uncontrollable movement, and organ failure, which is accelerated when the bitten prey tries to use their \
	newfound speed to flee. It is not uncommon for prey to collapse and die shortly after appearing to have \
	'escaped' the spider, enabling a form of persistance hunting for the Electric Spider."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/electric
	desc = "Spined and yellow, it makes you shudder to look at it. This one has flickering gold eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/electric_spider)

	icon_state = "spark"
	icon_living = "spark"
	icon_dead = "spark_dead"

	maxHealth = 210
	health = 210

	taser_kill = 0 //It -is- the taser.

	base_attack_cooldown = 15
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/projectile/beam/stun/electric_spider

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 25

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "stimm"

	shock_resist = 0.75

	exotic_type = /obj/item/reagent_containers/glass/venomgland/spider/stimm

	player_msg = "You can fire a taser-like ranged attack by clicking on an enemy or tile at a distance."

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/electric_spider

/obj/projectile/beam/stun/electric_spider
	name = "stun beam"
	damage_inflict_agony = 20

// The electric spider's AI.
/datum/ai_holder/polaris/simple_mob/ranged/electric_spider

/datum/ai_holder/polaris/simple_mob/ranged/electric_spider/max_range(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.incapacitated(INCAPACITATION_DISABLED) || L.stat == UNCONSCIOUS) // If our target is stunned, go in for the kill.
			return 1
	return ..() // Do ranged if possible otherwise.

/obj/item/reagent_containers/glass/venomgland/spider/stimm
	name = "Energizing Venom Gland"
	desc = "A sac full of venom. It makes your fingers twitch holding it."

/obj/item/reagent_containers/glass/venomgland/spider/stimm/Initialize(mapload)
	. = ..()
	reagents.add_reagent("stimm", 15)
