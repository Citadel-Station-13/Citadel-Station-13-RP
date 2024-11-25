
/datum/species/custom
	uid = SPECIES_ID_CUSTOM
	id = SPECIES_ID_CUSTOM
	name = SPECIES_CUSTOM
	name_plural = "Custom"
	selects_bodytype = TRUE
	base_species = SPECIES_HUMAN

	blurb = {"
	This is a custom species where you can assign various species traits to them as you wish, to create a (hopefully)
	balanced species. You will see the options to customize them on the Species Customization tab once you select and
	set this species as your species. Please look at the Species Customization tab if you select this species.
	"}
	catalogue_data = list(/datum/category_item/catalogue/fauna/custom_species)

	name_language = null // Use the first-name last-name generator rather than a language scrambler
	max_age = 200
	health_hud_intensity = 2
	max_additional_languages = 3
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	vision_organ = O_EYES

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

/datum/species/custom/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	return SScharacters.resolve_species_name(base_species).get_effective_bodytype(H, I, slot_id)

/datum/species/custom/get_bodytype_legacy()
	return base_species

/datum/species/custom/get_worn_legacy_bodytype()
	var/datum/species/real = SScharacters.resolve_species_name(base_species)
	// infinite loop guard
	return istype(real, src)? base_species : real.get_worn_legacy_bodytype()

/datum/species/custom/get_race_key(mob/living/carbon/human/H)
	var/datum/species/real = SScharacters.resolve_species_name(base_species)
	return real.real_race_key(H)
