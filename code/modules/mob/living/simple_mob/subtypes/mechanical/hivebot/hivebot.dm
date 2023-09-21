// Hivebots are tuned towards how many default lasers are needed to kill them.
// As such, if laser damage is ever changed, you should change this define.
#define LASERS_TO_KILL * 40

/datum/category_item/catalogue/technology/drone/hivebot/hivebots
	name = "Hivebots"
	desc = "Hivebots originate from unexplored space beyond the Moghes Hegemony (officially the 'Alliance of Three Hands). \
	Originally these were thought to be simple security drones, however the incursions of hivebots into Moghes space have shown that \
	there is an advanced and malicious intelligence behind the hivebots, though the identity of this brain behind the bots \
	remains unknown with most theorizing it a hostile machine intelligence. Hivebots are simple to produce, capable of mounting \
	a wide variety of weapons and coordinating its tactics with its companions and command hivebots. Should they be seen they \
	are to be destroyed on sight, less they find some hidden place to begin harvesting resources and creating an army, bent \
	on the destruction of organic life."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/technology/drone/hivebot)

/datum/category_item/catalogue/technology/drone/hivebot/basic
	name = "Hivebot - Basic"
	desc = "Hivebots are of modular design with only a handful of basic templates which are equipped as needed. However its common \
	for hivebots to be encountered with no equipment at all. These 'basic' hivebots are persumably created in large numbers then \
	equipped and upgraded as need arises for more specialized models. In a pinch however they are reliable fodder when used in combat."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/hivebot
	name = "hivebot"
	desc = "A robot. It appears to be somewhat resilient, but lacks a true weapon."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/basic)

	faction = "hivebot"

	maxHealth = 3 LASERS_TO_KILL
	health = 3 LASERS_TO_KILL
	water_resist = 0.5
	movement_sound = 'sound/effects/servostep.ogg'

	attacktext = list("clawed")
	projectilesound = 'sound/weapons/Gunshot_old.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/hivebot
	say_list_type = /datum/say_list/hivebot


/mob/living/simple_mob/mechanical/hivebot/death()
	..()
	visible_message(SPAN_WARNING("\The [src] blows apart!"))
	new /obj/effect/debris/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

// The hivebot's default projectile.
/obj/projectile/bullet/hivebot
	damage = 10
	damage_type = BRUTE
	sharp = FALSE
	edge = FALSE

/mob/living/simple_mob/mechanical/hivebot/swarm
	name = "swarm hivebot"
	desc = "A stripped down hivebot with many exposed mechanism.."
	maxHealth = 1 LASERS_TO_KILL
	health = 1 LASERS_TO_KILL
	melee_damage_lower = 8
	melee_damage_upper = 8

/datum/ai_holder/simple_mob/hivebot
	pointblank = TRUE
	conserve_ammo = TRUE
	firing_lanes = TRUE
	can_flee = FALSE // Fearless dumb machines.

/datum/category_item/catalogue/technology/drone/hivebot/miner
	name = "Hivebot - Miner"
	desc = "Miner hivebots were originally only observed closer to the Moghes Hegemony. Tasked with gathering ore to help fuel the creation \
	of more hivebots, their emergence has shown the growth of the hivebot threat even beyond the borders of Moghes. Despite its role in \
	gathering resources, the miners has been known to use combat AI similar to basic hivebots. Whether this is intentional feature of its \
	programming or just recylced combat code from its basic models is yet to be determined."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/hivebot/miner
	name = "hivebot miner"
	desc = "A hivebot equipped with a mining drill, though not exactly a combat model, it still seeems determined to kill."
	icon_state = "miner"
	icon_living = "miner"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/miner)
	melee_damage_lower = 15
	melee_damage_upper = 15

/datum/category_item/catalogue/technology/drone/hivebot/sword
	name = "Hivebot - Swordsman"
	desc = "Whether hivebots were capable of learning used to be a topic of much debate however, the recent arrival of the swordsman in \
	the frontier has proved they can. By integrating energy sword technology pioneered by the now defunct Cybersun Industries, the humble \
	melee hivebot has become a killing machine. Many now worry that it is only a matter of time before the hivebots adapt to even more \
	dangerous weapons and if this robot is any indication those fears are not at all misplaced."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/hivebot/sword
	name = "hivebot swordsman"
	desc = "A hivebot equipped with a laser sword, a melee bot built to kill."
	icon_state = "sword"
	icon_living = "sword"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/hivebot/sword)
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1
