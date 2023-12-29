/*
LORE:
Gaslamps are a phoron-based life form endemic to the world of Virgo-3B. They are
a sort of fungal organism with physical ties to Diona and Vox, deriving energy
for movement from a gentle combustion-like reaction in their bodies using
atmospheric phoron, carefully filtered trace oxygen, and captured meat products.
Over-exposure to oxygen causes their insides to burn too hot and eventually
kills them.

TODO: Make them light up and heat the air when exposed to oxygen.
*/

/datum/category_item/catalogue/fauna/gaslamp		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Virgo 3b Fauna - Gaslamp"
	desc = "Gaslamps are a phoron-based life form endemic to the world \
	of Virgo-3B. They are a sort of fungal organism with physical similarities \
	to Diona and Vox, although there is no actual link between these species. \
	They derive energy for movement from a gentle combustion-like reaction in their \
	bodies using atmospheric phoron, carefully filtered trace oxygen, and captured \
	meat products. Over-exposure to oxygen causes their insides to burn too hot and \
	eventually kills them."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/gaslamp
	name = "gaslamp"
	desc = "Some sort of floaty alien with a warm glow. This creature is endemic to Virgo-3B."
	tt_desc = "Semaeostomeae virginus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/gaslamp)

	icon_state = "gaslamp"
	icon_living = "gaslamp"
	icon_dead = "gaslamp-dead"
	icon = 'icons/mob/vore32x64.dmi'

	faction = "virgo3b"
	maxHealth = 100
	health = 100
	randomized = TRUE
	mod_min = 90
	mod_max = 140
	movement_cooldown = 12

	say_list_type = /datum/say_list/gaslamp
	ai_holder_type = /datum/ai_holder/simple_mob/gaslamp

	//speed = 2 not sure what this is, guessing animation, but it conflicts with new system.

	legacy_melee_damage_lower = 15 // Because fuck anyone who hurts this sweet, innocent creature.
	legacy_melee_damage_upper = 15
	attacktext = list("thrashed")
	friendly = "caressed"

	response_help   = "brushes"	// If clicked on help intent
	response_disarm = "pushes" // If clicked on disarm intent
	response_harm   = "swats"	// If clicked on harm intent

	minbodytemp = 0
	maxbodytemp = 350

	min_oxy = 0
	max_oxy = 5 // Does not like oxygen very much.
	min_tox = 1 // Needs phoron to survive.
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	exotic_amount = 5

/datum/say_list/gaslamp
	emote_see = list("looms", "sways gently")

/datum/ai_holder/simple_mob/gaslamp
	hostile = FALSE // The majority of simplemobs are hostile, gaslamps are nice.
	cooperative = FALSE
	retaliate = TRUE //so the monster can attack back
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 1
	wander = TRUE
	base_wander_delay = 9
