/datum/species/moth
	name = SPECIES_MOTH
	id = "moth"
	name_plural = "Dnin-Nepids"

	#warn sprites
	icobase = 'icons/mob/human_races/insect_moth.dmi'
	#warn wtf is deform
	deform = 'icons/mob/human_races/r_def_tajaran_vr.dmi'

	wing = "moth_plain"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)

	darksight = 7
	// i'd like to see oyu move in water with wings
	water_movement = 0.3
	// slightly brittle because i can't give them brittle bones on this rotten species backend until we make species backend more Fun
	brute_mod = 1.05
	burn_mod =  1.05
	metabolic_rate = 0.5
	gluttonous = 0
	num_alternate_languages = 3
	rarity_value = 2
	species_language = list(
		LANGUAGE_LUINIMMA
	)
	name_language = LANGUAGE_LUINIMMA
	// sensitive
	health_hud_intensity = 1.5

	// their canonical age can go over this but older ones probably aren't in human space
	max_age = 60

	// todo: this is only so high BECAUSE EVERY OTHER GODDAMN RACE IS 10, WHO DESGINED THIS?
	// todo: nerf everyone else and rework this fucked economy
	economic_modifier = 8

	// see defines - as of right now, detects reagents at 7% instead of 15%
	taste_sensitivity = TASTE_SENSITIVE

#warn wip

	blurb = "A nomadic species hailing from the southern reaches of the galaxy, Dnin-Nepids are a relatively \
	new contender to the galaxy's state of affairs. While most of their kind toil abroad the city-ships \
	of their fleets, some have sought to make their homes amongst the other races inhabiting the Milky Way. Their \
	appearance is not dissimilar to what a certain Sol insect looks like, earning them the moniker of 'moths' within the \
	hearts of the majority."
	catalogue_data = list(/datum/category_item/catalogue/fauna/mothpeople)

#warn wip

#warn check defines
	// WIP BELOW
	body_temperature = 320.15	//Even more cold resistant, even more flammable

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	breath_cold_level_1 = 180	//Default 240 - Lower is better
	breath_cold_level_2 = 100	//Default 180
	breath_cold_level_3 = 60	//Default 100

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	breath_heat_level_1 = 360	//Default 380 - Higher is better
	breath_heat_level_2 = 430	//Default 450
	breath_heat_level_3 = 1000	//Default 1250


	heat_discomfort_level = 295 //Prevents heat discomfort spam at 20c
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	cold_discomfort_level = 275

	/// Dangerously high pressure.
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE
	/// High pressure warning.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE
	/// Low pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE
	/// Dangerously low pressure.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE
	var/safe_pressure = ONE_ATMOSPHERE

	// WIP ABOVE

	blood_color = "#606000"
	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_MOTH

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	spawn_flags = SPECIES_CAN_JOIN
	primitive_form = null
	species_appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_APPENDIX = 	/obj/item/organ/internal/appendix,
		O_SPLEEN = 		/obj/item/organ/internal/spleen,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	color_mult = 1
	// todo: replace with proper name
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Race:_Moths"
	inherent_verbs = list(
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair
 		)

#warn wip
// todo: cataloguer rework when
/datum/category_item/catalogue/fauna/mothpeople
	#warn species name
	name = "Sapients - Dnin-Nepids"
	desc = {"

	"}
	value = CATALOGUER_REWARD_TRIVIAL
