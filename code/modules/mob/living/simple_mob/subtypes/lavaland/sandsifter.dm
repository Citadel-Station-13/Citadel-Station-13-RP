/datum/category_item/catalogue/fauna/sandsifter
	name = "Sand Sifters"
	desc = "Sand Sifters are a species native to KT-943, known commonly as Surt. \
	Largely inconsequential to Nanotrasen's interests on the planet, the sand sifter is \
	akin to bottom feeders found within other ecosystems; continuously crawling through the ash \
	sands that blanket the planet for base nutrients and rotting organic material. \
	Hence the common name the species is known by."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/sandsifter
	name = "sand sifter"
	desc = "A small snail-like creature that feeds on minerals and organic matter it finds in ash sand."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "lavasnail"
	icon_living = "lavasnail"
	icon_dead = "lavasnail-dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/sandsifter)

	maxHealth = 20
	health = 20
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1

	mob_size = MOB_MINISCULE
	pass_flags = ATOM_PASS_TABLE
	can_pull_size = WEIGHT_CLASS_TINY
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "pets"
	response_disarm = "nudges"
	response_harm   = "crushes"

	mob_class = MOB_CLASS_ANIMAL
	taser_kill = FALSE

	bone_type = /obj/item/stack/material/shell
	meat_type = /obj/item/reagent_containers/food/snacks/meat/sandsifter
	meat_amount = 2
	bone_amount = 4
	exotic_amount = 0

	holder_type = /obj/item/holder/sandsifter

	iff_factions = MOB_IFF_FACTION_BIND_TO_MAP

	speak_emote = list("burbles")
	say_list_type = /datum/say_list/sandsifter
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/sandsifter

/datum/ai_holder/polaris/simple_mob/melee/sandsifter
	hostile = FALSE
	retaliate = FALSE
	mauling = FALSE

/datum/say_list/sandsifter
	emote_hear = list("crunches on some sand","suddenly drops its shell to the ground")
	emote_see = list("sinks their underbelly into the sand", "slowly inches along", "pokes its radula at something")
