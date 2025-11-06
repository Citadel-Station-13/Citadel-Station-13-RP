/datum/species/werebeast
	uid = SPECIES_ID_WEREBEAST
	id = SPECIES_ID_WEREBEAST
	name = SPECIES_WEREBEAST
	name_plural = "Werebeasts"
	primitive_form = SPECIES_MONKEY_VULPKANIN
	default_bodytype = BODYTYPE_WEREBEAST

	icon_template = 'icons/mob/species/werebeast/template.dmi'
	icobase       = 'icons/mob/species/werebeast/body.dmi'
	deform        = 'icons/mob/species/werebeast/deformed_body.dmi'
	preview_icon  = 'icons/mob/species/werebeast/preview.dmi'

	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_VULPKANIN
	name_language = LANGUAGE_ID_VULPKANIN

	total_health = 200
	brute_mod = 0.85
	burn_mod  = 0.85
	metabolic_rate = 2
	item_slowdown_mod = 0.25
	hunger_factor = 0.4
	vision_innate = /datum/vision/baseline/species_tier_3
	vision_organ = O_EYES
	mob_size  = MOB_LARGE

	max_age = 200

	blurb = {"
	Big buff werewolves.

	These are a limited functionality event species that are not balanced for regular gameplay.  Adminspawn only.
	"}

	wikilink="N/A"
	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/proc/eat_trash,
	)

	color_mult = 1
	flesh_color = "#AFA59E"
	base_color  = "#777777"

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	has_external_organs = list(
		ORGAN_KEY_EXT_HEAD = /datum/species_organ_entry{
			override_type = /obj/item/organ/external/head/vr/werebeast;
		},
		ORGAN_KEY_EXT_CHEST,
		ORGAN_KEY_EXT_GROIN,
		ORGAN_KEY_EXT_LEFT_ARM,
		ORGAN_KEY_EXT_LEFT_HAND,
		ORGAN_KEY_EXT_RIGHT_ARM,
		ORGAN_KEY_EXT_RIGHT_HAND,
		ORGAN_KEY_EXT_LEFT_LEG,
		ORGAN_KEY_EXT_LEFT_FOOT,
		ORGAN_KEY_EXT_RIGHT_LEG,
		ORGAN_KEY_EXT_RIGHT_FOOT,
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)
