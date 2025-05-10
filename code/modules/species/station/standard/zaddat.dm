/datum/species/zaddat
	uid = SPECIES_ID_ZADDAT
	id = SPECIES_ID_ZADDAT
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

	max_additional_languages = 3
	name_language    = LANGUAGE_ID_ZADDAT
	intrinsic_languages = LANGUAGE_ID_ZADDAT
	whitelist_languages = list(
		LANGUAGE_ID_ZADDAT,
		LANGUAGE_ID_UNATHI
	)
	assisted_langs   = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_SOL_COMMON, LANGUAGE_AKHANI, LANGUAGE_SIIK, LANGUAGE_GUTTER, LANGUAGE_PROMETHEAN) //limited vocal range; can talk Unathi and magical Galcom but not much else


	health_hud_intensity = 2.5

	minimum_breath_pressure = 20 //have fun with underpressures. any higher than this and they'll be even less suitible for life on the station


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
	poison_type = GAS_ID_NITROGEN // technically it's a partial pressure thing but IDK if we can emulate that

	genders = list(FEMALE, PLURAL) //females are polyp-producing, infertile females and males are nigh-identical

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
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
	vision_organ = O_EYES

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/punch,
	)

	descriptors = list()

/datum/species/zaddat/apply_survival_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	// ensure they have a valid mask
	var/mask_type = /obj/item/clothing/mask/gas/zaddat
	if(for_target)
		var/obj/item/existing_mask = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/mask)
		if(for_target.temporarily_remove_from_inventory(existing_mask, INV_OP_FORCE | INV_OP_SILENT))
			into_inv?.Add(existing_mask)
			var/obj/item/creating_mask = new mask_type
			if(for_target.inventory.equip_to_slot_if_possible(creating_mask, /datum/inventory_slot/inventory/mask, INV_OP_SILENT | INV_OP_FLUFFLESS))
			else
				into_inv?.Add(creating_mask)
		else
			into_inv?.Add(mask_type)
	else
		into_inv?.Add(mask_type)

	var/suit_path = /obj/item/clothing/suit/space/void/zaddat
	if(for_target)
		var/obj/item/existing_suit_slot = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/suit)
		var/obj/item/creating_suit_slot = new suit_path
		if(existing_suit_slot)
			if(for_target.temporarily_remove_from_inventory(existing_suit_slot, INV_OP_FORCE | INV_OP_SILENT))
				into_inv?.Add(existing_suit_slot)
				if(!for_target.inventory.equip_to_slot_if_possible(creating_suit_slot, /datum/inventory_slot/inventory/suit, INV_OP_FORCE | INV_OP_SILENT))
					into_inv?.Add(creating_suit_slot)
			else
				into_inv?.Add(creating_suit_slot)
	else
		into_inv?.Add(suit_path)

	var/obj/item/storage/toolbox/lunchbox/survival/L = new
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(L)
	into_inv += L

	return ..()

/datum/species/zaddat/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)

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
			H.apply_damage(light_amount/4, DAMAGE_TYPE_BURN, K, 0, 0, "Abnormal growths")
