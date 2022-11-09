// TODO: unified, json-driven lore system :drooling:
GLOBAL_LIST_INIT(moth_lore_data, init_moth_lore())

/proc/init_moth_lore()
	return json_decode(file2text('strings/misc/moth_species.json'))

/datum/species/moth
	name = SPECIES_MOTH
	uid = SPECIES_ID_MOTH
	id = SPECIES_ID_MOTH
	category = "Dnin-Nepid (Moth)"
	abstract_type = /datum/species/moth
	name_plural   = "Dnin-Nepids"
	examine_name  = "Dnin-Nepid"
	override_worn_legacy_bodytype = SPECIES_HUMAN

	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	icobase = 'icons/mob/species/moth/body.dmi'
	deform  = 'icons/mob/species/moth/body.dmi'

	wing = "moth_plain"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)

	darksight = 7
	// i'd like to see oyu move in water with wings
	water_movement = 0.3
	// TODO: slightly brittle because i can't give them brittle bones on this rotten species backend until we make species backend more Fun
	brute_mod = 1
	burn_mod  = 1
	metabolic_rate = 0.5
	gluttonous = 0
	max_additional_languages = 3
	rarity_value = 2
	intrinsic_languages = LANGUAGE_ID_LUINIMMA
	name_language = LANGUAGE_ID_LUINIMMA
	// sensitive
	health_hud_intensity = 1.5

	// their canonical age can go over this but older ones probably aren't in human space
	max_age = 60

	// todo: this is only so high BECAUSE EVERY OTHER GODDAMN RACE IS 10, WHO DESGINED THIS?
	// todo: nerf everyone else and rework this fucked economy
	economic_modifier = 8

	// see defines - as of right now, detects reagents at 7% instead of 15%
	taste_sensitivity = TASTE_SENSITIVE

	catalogue_data = list(/datum/category_item/catalogue/fauna/mothpeople)
	blurb = "A nomadic species hailing from the southern reaches of the galaxy, Dnin-Nepids are a relatively \
	new contender to the galaxy's state of affairs. They are a peaceful, innovative people with fragile, yet nimble bodies. \
	Their appearance is not dissimilar to what certain Sol insects look like, earning them the moniker of '<b>moths</b>' by the majority. \
	While most of their kind stick to the city-ships of their fleet, more and more have migrated to the frontiers of Orion and Jargon space - \
	whether to see the world, or to pursue a new life."

	// slightly cooler than average
	body_temperature = 307.15

	// cold resistant
	cold_level_1 = 225
	cold_level_2 = 160
	cold_level_3 = 100

	breath_cold_level_1 = 215
	breath_cold_level_2 = 150
	breath_cold_level_3 = 90

	// sensitive
	cold_discomfort_level = 265
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel your wings icing over.",
		"You shiver.",
		"You feel a bit rigid."
	)

	// heat nominal
	heat_level_1 = 360
	heat_level_2 = 400
	heat_level_3 = 1000

	breath_heat_level_1 = 380
	breath_heat_level_2 = 350
	breath_heat_level_3 = 1250

	// very sensitive
	heat_discomfort_level = 310
	heat_discomfort_strings = list(
		"You reflexively flick your wings.",
		"You feel uncomfortably warm.",
		"Your hair stands on end from the warmth.",
		"You feel strangely energetic."
	)

	// slightly more tolerant, high sensitivity
	warning_low_pressure = 60
	hazard_low_pressure = 7.5

	// way less tolerant, very senstiive
	warning_high_pressure = 250
	hazard_high_pressure = 350
	// WIP ABOVE

	blood_color = "#606000"
	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_MOTH

	move_trail = /obj/effect/debris/cleanable/blood/tracks/claw

	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	primitive_form = null
	species_appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_APPENDIX  = /obj/item/organ/internal/appendix,
		O_SPLEEN    = /obj/item/organ/internal/spleen,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	inherent_verbs = list(
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
	)

	color_mult = 1
	// todo: replace with proper name
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Race:_Dnin-Nepids"

// todo: cataloguer rework when
/datum/category_item/catalogue/fauna/mothpeople
	name = "Sapients - Dnin-Nepids"
	desc = {"
		The Dnin-Nepids are a nomadic species hailing from the southern side of the Milky Way. A relatively new contender
		to the galaxy's state of affairs, they are a nomadic and innovative race that tends to stick to themselves. Dnin-Nepids
		often sport lithe, yet nimble bodies - covered with fuzz and sporting wings and antennae, leading them to gain the
		moniker of 'moths' due to their resemblence to a certain Earth-originating insect.

		While most of the Dnin-Nepids live aboard their arkships - whether within their main fleets, or as part of an expeditionary crew,
		more and more have been spotted on the frontier - oft either seeking a new adventure, or a new life amongst the other races of the galaxy.
		As a race of natural, if enigmatic and unpredictable engineers, they are oft found working aboard vessels as navigators and maintainers,
		taking advantage of their adaptability where they lack in things like brawn and numbers.
	"}
	value = CATALOGUER_REWARD_TRIVIAL

/datum/species/moth/dark
	name = SPECIES_MOTH_DARK
	uid = SPECIES_ID_MOTH_DARK
	species_spawn_flags = SPECIES_SPAWN_ALLOWED

	// darksight, but weak to light
	darksight = 7
	flash_burn = 5
	flash_mod = 1.2

/datum/species/moth/light
	name = SPECIES_MOTH_LIGHT
	uid = SPECIES_ID_MOTH_LIGHT
	species_spawn_flags = SPECIES_SPAWN_ALLOWED

	// hardy, but no darksight
	darksight = 2
	flash_mod = 0.5
	item_slowdown_mod = 0.5
