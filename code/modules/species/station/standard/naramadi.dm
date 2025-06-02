/datum/species/naramadi
	uid = SPECIES_ID_NARAMADI
	id = SPECIES_ID_NARAMADI
	name = SPECIES_SERGAL
	name_plural = "Naramadi"
	category = "Naramadi"
	default_bodytype = BODYTYPE_SERGAL
	icobase = 'icons/mob/species/naramadi/body.dmi'
	deform = 'icons/mob/species/naramadi/deformed_body.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/naramadi,
	)

	movement_base_speed = 5.5
	snow_movement = -1 // Ignores light snow

	hunger_factor = 0.1 // By math should be half of the Teshari Nutrition drain
	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_NARAMADI
	name_language = LANGUAGE_ID_NARAMADI
	color_mult = 1
	vision_organ = O_EYES

	max_age = 120

	blurb = {"
	The Naramadi (Plural of Naramad) are a species of bipedal, furred mammalians originating from the Verkihar Major system.
	They share a border with the Unathi, granting both of the species a history of war.  Naramadi Ascendancy's location
	also brings forth a constant danger of Hivebot Fleets attacks, leaving the Empire in a state of constant Defense.
	"}

	catalogue_data = list(/datum/category_item/catalogue/fauna/sergal)
	wikilink = ""

	primitive_form = SPECIES_MONKEY_SERGAL

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	reagent_tag = IS_NARAMADI

	flesh_color = "#AFA59E"
	base_color  = "#777777"

	ambiguous_genders = TRUE   //Naramadi look the same when female and male, at least from the groin up if you catch my drift ;^) - Papalus

	cold_level_1 = 280  //I'm not sorry, Lore changes. - Papalus
	cold_level_2 = 240
	cold_level_3 = 180

	heat_level_1 = 380
	heat_level_2 = 420 //Nice
	heat_level_3 = 1000

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
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)
