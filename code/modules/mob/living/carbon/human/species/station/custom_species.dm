
/datum/species/custom
	name = SPECIES_CUSTOM
	name_plural = "Custom"
	selects_bodytype = TRUE
	base_species = SPECIES_HUMAN

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)

	blurb = "This is a custom species where you can assign various species traits to them as you wish, to \
	create a (hopefully) balanced species. You will see the options to customize them on the Species Customization tab once \
	you select and set this species as your species. Please look at the Species Customization tab if you select this species."
	catalogue_data = list(/datum/category_item/catalogue/fauna/custom_species)

	name_language = null // Use the first-name last-name generator rather than a language scrambler
	max_age = 200
	health_hud_intensity = 2
	num_alternate_languages = 3
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair
		)

	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest, "descriptor" = "torso"),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin, "descriptor" = "groin"),
		BP_HEAD =   list("path" = /obj/item/organ/external/head, "descriptor" = "head"),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm, "descriptor" = "left arm"),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right, "descriptor" = "right arm"),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg, "descriptor" = "left leg"),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right, "descriptor" = "right leg"),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand, "descriptor" = "left hand"),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right, "descriptor" = "right hand"),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot, "descriptor" = "left foot"),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right, "descriptor" = "right foot")
		)

/datum/species/custom/get_worn_legacy_bodytype()
	var/datum/species/real = name_static_species_meta(base_species)
	// infinite loop guard
	return istype(real, src)? base_species : real.get_worn_legacy_bodytype()

/datum/species/custom/get_race_key(mob/living/carbon/human/H)
	var/datum/species/real = name_static_species_meta(base_species)
	return real.real_race_key(H)

// Stub species overrides for shoving trait abilities into

//Called when face-down in the water or otherwise over their head.
// Return: TRUE for able to breathe fine in water.
/datum/species/custom/can_breathe_water()
	return ..()

//Called during handle_environment in Life() ticks.
// Return: Not used.
/datum/species/custom/handle_environment_special(var/mob/living/carbon/human/H)
	return ..()

//Called when spawning to equip them with special things.
/datum/species/custom/equip_survival_gear(var/mob/living/carbon/human/H)
	/* Example, from Vox:
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H), slot_r_hand)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H.back), slot_in_backpack)
		H.internal = H.r_hand
	H.internal = locate(/obj/item/tank) in H.contents
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"
	*/
	return ..()
