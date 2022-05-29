/datum/category_item/catalogue/fauna/tomato
	name = "Killer Tomato"
	desc = "The byproduct of GMO experimentation gone wrong, killer tomatoes \
	are a dramatic example of why rapid genetic tampering is ill advised."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/hostile/tomato
	name = "killer tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	tt_desc = "X Solanum abominable"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/tomato)

	mob_class = MOB_CLASS_PLANT

	faction = "plants"
	maxHealth = 15
	health = 15
	poison_resist = 1.0

	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"

	harm_intent_damage = 5
	melee_damage_upper = 15
	melee_damage_lower = 10
	attacktext = list("mauled")

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/tomatomeat
	exotic_amount = 1
	exotic_type = /obj/item/seeds/tomatoseed

/mob/living/simple_mob/hostile/tomato/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/hostile/tomato/space/Process_Spacemove(var/check_drift = 0)
	return TRUE
