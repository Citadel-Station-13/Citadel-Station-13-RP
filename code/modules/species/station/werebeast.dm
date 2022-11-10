/datum/species/werebeast
	name = SPECIES_WEREBEAST
	name_plural = "Werebeasts"
	primitive_form = SPECIES_MONKEY_VULPKANIN
	default_bodytype = BODYTYPE_WEREBEAST

	icon_template = 'icons/mob/species/werebeast/template.dmi'
	icobase       = 'icons/mob/species/werebeast/body.dmi'
	deform        = 'icons/mob/species/werebeast/deformed_body.dmi'
	preview_icon  = 'icons/mob/species/werebeast/preview.dmi'
	tail = "tail"

	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_CANILUNZT)
	name_language = LANGUAGE_CANILUNZT

	total_health = 200
	brute_mod = 0.85
	burn_mod  = 0.85
	metabolic_rate = 2
	item_slowdown_mod = 0.25
	hunger_factor = 0.4
	darksight = 8
	mob_size  = MOB_LARGE

	max_age = 200

	blurb = {"
	Big buff werewolves.

	These are a limited functionality event species that are not balanced for regular gameplay.  Adminspawn only.
	"}

	wikilink="N/A"
	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
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

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/werebeast),
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
