//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/biology/organic/xenomorph
	default_organ_mappings = list(
		ORGAN_KEY_EXT_CHEST = /obj/item/organ/external/chest/unseverable/xeno,
		ORGAN_KEY_EXT_GROIN = /obj/item/organ/external/groin/unseverable/xeno,
		ORGAN_KEY_EXT_HEAD = /obj/item/organ/external/head/unseverable/xeno,
		ORGAN_KEY_EXT_LEFT_ARM = /obj/item/organ/external/arm/unseverable/xeno,
		ORGAN_KEY_EXT_LEFT_HAND = /obj/item/organ/external/hand/unseverable/xeno,
		ORGAN_KEY_EXT_RIGHT_ARM = /obj/item/organ/external/arm/right/unseverable/xeno,
		ORGAN_KEY_EXT_RIGHT_HAND = /obj/item/organ/external/hand/right/unseverable/xeno,
		ORGAN_KEY_EXT_LEFT_FOOT = /obj/item/organ/external/foot/unseverable/xeno,
		ORGAN_KEY_EXT_LEFT_LEG = /obj/item/organ/external/leg/left/unseverable/xenomorph,
		ORGAN_KEY_EXT_RIGHT_FOOT = /obj/item/organ/external/foot/right/unseverable/xeno,
		ORGAN_KEY_EXT_RIGHT_LEG = /obj/item/organ/external/leg/unseverable/xeno,
		ORGAN_KEY_XENOMORPH_HIVE_NODE = /obj/item/organ/internal/xenomorph/hivenode,
		ORGAN_KEY_XENOMORPH_PLASMA_VESSEL = /obj/item/organ/internal/xenomorph/plasmavessel,
		ORGAN_KEY_XENOMORPH_ACID_GLAND = /obj/item/organ/internal/xenomorph/acidgland,
		ORGAN_KEY_XENOMORPH_RESIN_SPINNER = /obj/item/organ/internal/xenomorph/resinspinner,
		ORGAN_KEY_XENOMORPH_EGG_SAC = /obj/item/organ/internal/xenomorph/eggsac,
	)
	default_internal_organ_keys = list(
	)

#warn impl + merge in below

		// O_HEART =    /obj/item/organ/internal/heart,
		// O_BRAIN =    /obj/item/organ/internal/brain/xeno,
		// O_NUTRIENT = /obj/item/organ/internal/diona/nutrients,
		// O_STOMACH =		/obj/item/organ/internal/stomach/xeno,
		// O_INTESTINE =	/obj/item/organ/internal/intestine/xeno
