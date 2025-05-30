/datum/category_item/catalogue/fauna/redpanda
	name = "Red Panda"
	desc = "Red Pandas are sometimes imported to the Frontier from \
	exotic pet brokers in Orion space. Popular among collectors due \
	to their coloration, patterning, and generally adorable appearance, \
	the Red Panda is a popular pet and status symbol rolled into one."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/redpanda
	name = "red panda"
	desc = "It's a wah! Beware of doom pounce!"
	tt_desc = "Ailurus fulgens"
	catalogue_data = list(/datum/category_item/catalogue/fauna/redpanda)

	icon_state = "wah"
	icon_living = "wah"
	icon_dead = "wah_dead"
	icon_rest = "wah_rest"
	icon = 'icons/mob/vore.dmi'

	iff_factions = MOB_IFF_FACTION_NEUTRAL

	maxHealth = 30
	health = 30
	randomized = TRUE

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 3
	legacy_melee_damage_lower = 3
	legacy_melee_damage_upper = 1
	attacktext = list("bapped")

	say_list_type = /datum/say_list/redpanda
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/passive

/mob/living/simple_mob/vore/redpanda/fae
	name = "dark wah"
	desc = "Ominous, but still cute!"
	tt_desc = "Ailurus brattus"

	icon_state = "wah_fae"
	icon_living = "wah_fae"
	icon_dead = "wah_fae_dead"
	icon_rest = "wah_fae_rest"

	maxHealth = 100
	health = 100
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 20

/datum/say_list/redpanda
	speak = list("Wah!","Wah?","Waaaah.")
	emote_hear = list("wahs!","chitters.")
	emote_see = list("trundles around","rears up onto their hind legs and pounces a bug")
