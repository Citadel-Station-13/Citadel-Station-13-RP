/datum/species/zaddat
	name = SPECIES_ZADDAT
	name_plural = SPECIES_ZADDAT
	icobase = 'icons/mob/species/zaddat/body.dmi'
	deform  = 'icons/mob/species/zaddat/deformed_body.dmi'
	default_bodytype = BODYTYPE_ZADDAT

	brute_mod = 1.15
	burn_mod =  1.15
	toxins_mod = 1.5
	flash_mod = 2
	flash_burn = 15 //flashing a zaddat probably counts as police brutality

	metabolic_rate = 0.7 //did u know if your ancestors starved ur body will actually start in starvation mode?
	gluttonous = 0
	taste_sensitivity = TASTE_SENSITIVE

	num_alternate_languages = 3
	name_language    = LANGUAGE_ZADDAT
	species_language = LANGUAGE_ZADDAT
	secondary_langs  = list(LANGUAGE_ZADDAT, LANGUAGE_UNATHI)
	assisted_langs   = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_SOL_COMMON, LANGUAGE_AKHANI, LANGUAGE_SIIK, LANGUAGE_GUTTER) //limited vocal range; can talk Unathi and magical Galcom but not much else


	health_hud_intensity = 2.5

	minimum_breath_pressure = 20 //have fun with underpressures. any higher than this and they'll be even less suitible for life on the station

	economic_modifier = 3

	max_age = 90

	blurb = {"
	The Zaddat are an Unathi client race only recently introduced to OriCon space. Having evolved on
	the high-pressure and post-apocalyptic world of Xohok, Zaddat require an environmental suit called a Shroud
	to survive in usual planetary and station atmospheres. Despite these restrictions, worsening conditions on
	Xohok and the blessing of the Moghes Hegemony have lead the Zaddat to enter human space in search of work
	and living space.
	"}

	catalogue_data = list(/datum/category_item/catalogue/fauna/zaddat)
	// no wiki link exists for Zaddat yet

	hazard_high_pressure  = HAZARD_HIGH_PRESSURE + 500 // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE + 500 // High pressure warning.
	warning_low_pressure = 300 // Low pressure warning.
	hazard_low_pressure  = 220 // Dangerously low pressure.
	safe_pressure = 400
	poison_type = /datum/gas/nitrogen // technically it's a partial pressure thing but IDK if we can emulate that

	genders = list(FEMALE, PLURAL) //females are polyp-producing, infertile females and males are nigh-identical

	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = null

	flesh_color = "#AFA59E"
	base_color  = "#e2e4a6"
	blood_color = "#FFCC00" //a gross sort of orange color

	reagent_tag = IS_ZADDAT

	heat_discomfort_strings = list(
		"Your joints itch.",
		"You feel uncomfortably warm.",
		"Your carapace feels like a stove.",
	)

	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your antenna ache.",
	)

	has_organ = list( //No appendix.
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
	)

	descriptors = list()

/datum/species/zaddat/equip_survival_gear(mob/living/carbon/human/H)
	..()
	if(H.wear_suit) //get rid of job labcoats so they don't stop us from equipping the Shroud
		qdel(H.wear_suit) //if you know how to gently set it in like, their backpack or whatever, be my guest
	if(H.wear_mask)
		qdel(H.wear_mask)
	if(H.head)
		qdel(H.head)

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/zaddat/(H), SLOT_ID_MASK) // mask has to come first or Shroud helmet will get in the way
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/zaddat/(H), SLOT_ID_SUIT)

	var/obj/item/storage/toolbox/lunchbox/survival/zaddat/L = new(H)

	if(H.backbag == 1)
		H.put_in_hands_or_del(L)
	else
		H.equip_to_slot_or_del(L, /datum/inventory_slot_meta/abstract/put_in_backpack)

/datum/species/zaddat/handle_environment_special(mob/living/carbon/human/H)

	if(H.inStasisNow())
		return

	var/damageable = H.get_damageable_organs()
	var/covered = H.get_coverage()

	var/light_amount = 0 //how much light there is in the place, affects damage
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 5


	for(var/K in damageable)
		if(!(K in covered))
			H.apply_damage(light_amount/4, BURN, K, 0, 0, "Abnormal growths")
