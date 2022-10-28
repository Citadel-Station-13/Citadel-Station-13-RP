/datum/species/vox
	name = SPECIES_VOX
	name_plural = SPECIES_VOX
	uid = SPECIES_ID_VOX
	category = "Vox"
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
	rarity_value = 4

//	taste_sensitivity = TASTE_DULL

	slowdown = -0.5

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

	gluttonous = 0

	breath_type = /datum/gas/phoron
	poison_type = /datum/gas/oxygen
	siemens_coefficient = 0.2

	species_flags = NO_SCAN | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_ALLOWED | SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_WHITELIST_SELECTABLE
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

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong,
	)

	genders = list(NEUTER)

	descriptors = list(
		/datum/mob_descriptor/vox_markings = 0
		)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/proc/eat_trash,
		/mob/living/carbon/human/proc/tie_hair,
		)

/datum/species/vox/get_random_name(gender)
	var/datum/language/species_language = SScharacters.resolve_language_id(default_language)
	return species_language.get_random_name(gender)

/datum/species/vox/equip_survival_gear(mob/living/carbon/human/H, extendedtank = FALSE, comprehensive = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), SLOT_ID_MASK, INV_OP_SILENT | INV_OP_FLUFFLESS)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), SLOT_ID_BACK, INV_OP_SILENT | INV_OP_FLUFFLESS)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), /datum/inventory_slot_meta/abstract/hand/right, INV_OP_SILENT | INV_OP_FLUFFLESS)
		H.internal = H.r_hand
	H.internal = locate(/obj/item/tank) in H.contents
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"
