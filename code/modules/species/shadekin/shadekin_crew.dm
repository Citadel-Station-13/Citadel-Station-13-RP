/datum/species/crew_shadekin
	name = SPECIES_SHADEKIN_CREW
	name_plural = SPECIES_SHADEKIN_CREW
	icobase = 'icons/mob/human_races/r_shadekin_vr.dmi'
	deform = 'icons/mob/human_races/r_shadekin_vr.dmi'
	tail = "tail"
	blurb = "Very little is known about these creatures. They appear to be largely mammalian in appearance. \
	Seemingly very rare to encounter, there have been widespread myths of these creatures the galaxy over, \
	but next to no verifiable evidence to their existence. However, they have recently been more verifiably \
	documented in the Virgo system, following a mining bombardment of Virgo 3. The crew of NSB Adephagia have \
	taken to calling these creatures 'Shadekin', and the name has generally stuck and spread. "		//TODO: Something more fitting for black-eyes	//CIT ADDENDUM: since we're not really on the tether anymore we'll need a bullshit reason as to why we have shadekin on a ship
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Shadekin"

	language = LANGUAGE_SHADEKIN
	name_language = LANGUAGE_SHADEKIN
	species_language = LANGUAGE_SHADEKIN
	secondary_langs = list(LANGUAGE_SHADEKIN)
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	rarity_value = 5 //INTERDIMENSIONAL FLUFFERS

	siemens_coefficient = 0 //Completely shockproof (this is no longer the case on virgo, feel free to change if it needs rebalancing)
	darksight = 10 //Best darksight around

	slowdown = 0.5 //As slow as unathi
	item_slowdown_mod = 1.5 //They're not as fit as them, though, slowed down more by heavy gear

	total_health = 75  // Fragile
	brute_mod = 1.25   // Frail
	burn_mod  = 1.25   // Furry
	blood_volume = 500  // Slightly less blood than human baseline
	hunger_factor = 0.2 // Gets hungrier faster than human baseline

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1 //?Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 850 //?Resistant to heat
	heat_level_2 = 1000
	heat_level_3 = 1150

	//Virgo: Shadekin biology is still unknown to the universe (unless some bullshit lore says otherwise)
	//!CitadelRP: Now able to walk over shards of glass like regular shadekins
	flags =  NO_SCAN | NO_MINOR_CUT | CONTAMINATION_IMMUNE
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE

	reagent_tag = IS_SHADEKIN //?For shadekin-unique chem interactions

	color_mult  = 1
	flesh_color = "#FFC896"
	blood_color = "#A10808"
	base_color  = "#f0f0f0"

	inherent_verbs = list(/mob/living/proc/shred_limb)

	has_glowing_eyes = TRUE	//TODO: port the ability to give neutral traits to all species from vorestation

	male_cough_sounds = null
	female_cough_sounds = null
	male_sneeze_sound = null
	female_sneeze_sound = null

	speech_bubble_appearance = "ghost"

	genders = list(MALE, FEMALE, PLURAL, NEUTER, HERM) //Fuck it. shadekins with titties

	breath_type = null //?They don't breathe
	poison_type = null

	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_UNDERWEAR

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine
		)

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/crewkin),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/crewkin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/crewkin),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/crewkin),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/crewkin),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/crewkin),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/crewkin),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crewkin),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crewkin),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/crewkin),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/crewkin)
		)

/datum/species/shadekin/get_bodytype()
	return SPECIES_SHADEKIN

/datum/species/shadekin/can_breathe_water()
	return TRUE //?They dont quite breathe
