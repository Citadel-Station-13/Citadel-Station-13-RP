/datum/category_item/catalogue/fauna/russian
	name = "Russians"
	desc = "After the Human Diaspora, but before the Final War, many \
	nations hosted their own colonial efforts out into the stars. Although \
	most human settlers live in culturally diverse environments, some of \
	those habitats which trace their lineage back to the Diaspora have remained \
	culturally homogenous. Sometimes xenophobic, and sometimes simply \
	nationalistic, these cultures function just as well as their counterparts. \
	Many of  these communities draw their ancestry directly back to Old Russia. \
	Due to this, ethnic and genetic Russians remain heavily represented on the \
	Galactic stage."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/humanoid/russian
	name = "russian"
	desc = "For the Motherland!"
	tt_desc = "E Homo sapiens"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/russian)

	faction = "russian"

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = list("punched")

	loot_list = list(/obj/item/material/knife = 100)

	corpse = /obj/spawner/corpse/russian

/mob/living/simple_mob/humanoid/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"

	projectiletype = /obj/item/projectile/bullet
	casingtype = /obj/item/ammo_casing/spent
	projectilesound = 'sound/weapons/Gunshot4.ogg'

	loot_list = list(/obj/item/gun/projectile/revolver/mateba = 100)

	corpse = /obj/spawner/corpse/russian/ranged
