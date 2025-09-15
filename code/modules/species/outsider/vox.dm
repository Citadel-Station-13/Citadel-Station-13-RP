/datum/species/vox
	name = SPECIES_VOX
	name_plural = SPECIES_VOX
	uid = SPECIES_ID_VOX
	category = SPECIES_CATEGORY_VOX
	default_bodytype = BODYTYPE_VOX

	icobase = 'icons/mob/species/vox/body.dmi'
	deform  = 'icons/mob/species/vox/deformed_body.dmi'

	max_additional_languages = 1
	intrinsic_languages = LANGUAGE_ID_VOX
	default_language = LANGUAGE_ID_VOX
	name_language = LANGUAGE_ID_VOX
	assisted_langs   = list(LANGUAGE_ROOTGLOBAL)

	blurb = {"
	The Vox are the broken remnants of a once-proud race, now reduced to little more than
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible
	smell.

	Most humans will never meet a Vox raider, instead learning of this insular species through
	dealing with their traders and merchants; those that do rarely enjoy the experience.
	"}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_The_Vox"
	catalogue_data = list(/datum/category_item/catalogue/fauna/vox)
	//rarity_value = 4

//	taste_sensitivity = TASTE_DULL

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	scream_verb = "shrieks"
	male_scream_sound   = 'sound/voice/shriek1.ogg'
	female_scream_sound = 'sound/voice/shriek1.ogg'
	male_cough_sounds   = list('sound/voice/shriekcough.ogg')
	female_cough_sounds = list('sound/voice/shriekcough.ogg')
	male_sneeze_sound   = 'sound/voice/shrieksneeze.ogg'
	female_sneeze_sound = 'sound/voice/shrieksneeze.ogg'

	warning_low_pressure = 50
	hazard_low_pressure  = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	movement_base_speed = 6.66
	gluttonous = 0

	breath_type = GAS_ID_PHORON
	poison_type = GAS_ID_OXYGEN
	siemens_coefficient = 0.2

	species_flags = NO_SCAN | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED
	species_appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR

	blood_color = "#9066BD"
	flesh_color = "#a3a593"
	base_color  = "#2e3302"
	meat_type   = /obj/item/reagent_containers/food/snacks/meat/vox

	reagent_tag = IS_VOX

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vox),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
		)


	has_organ = list(
		O_HEART   = /obj/item/organ/internal/heart/vox,
		O_LUNGS   = /obj/item/organ/internal/lungs/vox,
		O_VOICE   = /obj/item/organ/internal/voicebox,
		O_LIVER   = /obj/item/organ/internal/liver/vox,
		O_KIDNEYS = /obj/item/organ/internal/kidneys/vox,
		O_BRAIN   = /obj/item/organ/internal/brain/vox,
		O_EYES    = /obj/item/organ/internal/eyes,
	)
	vision_organ = O_EYES

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws/strong,
		/datum/melee_attack/unarmed/bite/strong,
	)

	genders = list(NEUTER)

	descriptors = list(
		/datum/mob_descriptor/vox_markings = 0
		)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/proc/eat_trash,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
		)

/datum/species/vox/get_random_name(gender)
	var/datum/prototype/language/species_language = RSlanguages.fetch(default_language)
	return species_language.get_random_name(gender)

/datum/species/vox/apply_survival_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	// ensure they have a valid mask
	var/mask_type = /obj/item/clothing/mask/breath
	if(for_target)
		var/obj/item/existing_mask = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/mask)
		if(existing_mask?.clothing_flags & ALLOWINTERNALS)
		else
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
	// ensure they have a vox tank
	var/tank_type = /obj/item/tank/vox
	if(for_target)
		var/obj/item/tank/equipping_tank = new tank_type
		var/could_place = TRUE
		if(for_target.inventory.equip_to_slot_if_possible(equipping_tank, /datum/inventory_slot/inventory/pocket/left))
		else if(for_target.inventory.equip_to_slot_if_possible(equipping_tank, /datum/inventory_slot/inventory/pocket/right))
		else if(for_target.inventory.put_in_hands(equipping_tank))
		else
			could_place = FALSE
		if(could_place)
			// todo: refactor this shit
			for_target.internal = equipping_tank
			for_target.internals.icon_state = "internal1"
		else
			into_inv?.Add(tank_type)
	else
		into_inv?.Add(tank_type)

	return ..()
