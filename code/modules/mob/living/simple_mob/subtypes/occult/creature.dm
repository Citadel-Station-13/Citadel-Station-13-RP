/datum/category_item/catalogue/fauna/creature
	name = "%#ERROR#%"
	desc = "%ERROR% SCAN DATA REDACTED. RETURN SCANNER TO A \
	CENTRAL ADMINISTRATOR FOR IMMEDIATE MAINTENANCE. %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/creature)

	mob_class = MOB_CLASS_ABERRATION

	faction = "creature"

	maxHealth = 40
	health = 40
	randomized = TRUE
	mod_min = 80
	mod_max = 130

	harm_intent_damage = 8

	melee_damage_lower = 8
	melee_damage_upper = 15
	attack_armor_pen = 5	//It's a horror from beyond, I ain't gotta explain 5 AP
	attack_sharp = 1
	attack_edge = 1
	taser_kill = 0 //See the Above on why you can't tase it.

	attacktext = list("chomped")
	attack_sound = 'sound/weapons/bite.ogg'

	speak_emote = list("gibbers")

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	hide_amount = 4
	hide_type = /obj/item/stack/hairlesshide
	exotic_amount = 3
	exotic_type = /obj/item/stack/sinew

/mob/living/simple_mob/creature/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/weak)

// Strong Variant
/mob/living/simple_mob/creature/strong
	maxHealth = 160
	health = 160

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 25

// Cult Variant
/mob/living/simple_mob/creature/cult
	mob_class = MOB_CLASS_DEMONIC

	faction = "cult"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	supernatural = TRUE

/mob/living/simple_mob/creature/cult/cultify()
	return

// Strong Cult Variant
/mob/living/simple_mob/creature/cult/strong
	maxHealth = 160
	health = 160

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 25
