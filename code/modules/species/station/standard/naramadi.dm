/datum/species/naramadi
	name = SPECIES_SERGAL
	uid = SPECIES_ID_NARAMADI
	name_plural = "Naramadi"
	category = "Naramadi"
	default_bodytype = BODYTYPE_SERGAL
	icobase = 'icons/mob/species/naramadi/body.dmi'
	deform = 'icons/mob/species/naramadi/deformed_body.dmi'
	tail = "tail"

	icobase_tail = 1
	slowdown      = -0.25
	snow_movement = -1 // Ignores light snow
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1
	hunger_factor = 0.1 // By math should be half of the Teshari Nutrition drain
	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_NARAMADI
	name_language = LANGUAGE_ID_NARAMADI
	color_mult = 1

	max_age = 120

	blurb = {"
	The Naramadi (Plural of Naramad) are a species of bipedal, furred mammalians originating from the Verkihar Major system.
	They share a border with the Unathi, granting both of the species a history of war.  Naramadi Ascendancy's location
	also brings forth a constant danger of Hivebot Fleets attacks, leaving the Empire in a state of constant Defense.
	"}

	catalogue_data = list(/datum/category_item/catalogue/fauna/sergal)
	wikilink = ""

	primitive_form = SPECIES_MONKEY_SERGAL

	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#777777"

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/sergal),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
	)
