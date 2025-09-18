//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* API - Get *//

/mob/living/carbon/get_organs()
	return external_organs + internal_organs

/mob/living/carbon/get_internal_organs()
	return internal_organs.Copy()

/mob/living/carbon/get_external_organs()
	return external_organs.Copy()

/mob/living/carbon/get_organ_by_key(key)
	RETURN_TYPE(/obj/item/organ)
	return keyed_organs[key]

/mob/living/carbon/get_organs_by_key(key)
	RETURN_TYPE(/list)
	. = list()
	if(keyed_organs[key])
		. += keyed_organs[key]

/mob/living/carbon/get_organ_for_zone(target_zone)
	var/static/list/target_zone_rewrites = list(
		TARGET_ZONE_HEAD = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_EYES = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_MOUTH = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_LEFT_ARM = ORGAN_KEY_EXT_LEFT_ARM,
		TARGET_ZONE_LEFT_HAND = ORGAN_KEY_EXT_LEFT_HAND,
		TARGET_ZONE_RIGHT_ARM = ORGAN_KEY_EXT_RIGHT_ARM,
		TARGET_ZONE_RIGHT_HAND = ORGAN_KEY_EXT_RIGHT_HAND,
		TARGET_ZONE_GROIN = ORGAN_KEY_EXT_GROIN,
		TARGET_ZONE_LEFT_LEG = ORGAN_KEY_EXT_LEFT_LEG,
		TARGET_ZONE_LEFT_FOOT = ORGAN_KEY_EXT_LEFT_FOOT,
		TARGET_ZONE_RIGHT_LEG = ORGAN_KEY_EXT_RIGHT_LEG,
		TARGET_ZONE_RIGHT_FOOT = ORGAN_KEY_EXT_RIGHT_FOOT,
	)
	return keyed_organs[target_zone_rewrites[target_zone]]

/mob/living/carbon/get_internal_organs_for_zone(target_zone)
	var/obj/item/organ/external/bodypart = get_organ_for_zone(target_zone)
	return bodypart ? bodypart.get_internal_organs() : list()

/mob/living/carbon/get_non_stump_organ_for_zone(target_zone)
	var/static/list/target_zone_rewrites = list(
		TARGET_ZONE_HEAD = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_EYES = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_MOUTH = ORGAN_KEY_EXT_HEAD,
		TARGET_ZONE_LEFT_ARM = ORGAN_KEY_EXT_LEFT_ARM,
		TARGET_ZONE_LEFT_HAND = ORGAN_KEY_EXT_LEFT_HAND,
		TARGET_ZONE_RIGHT_ARM = ORGAN_KEY_EXT_RIGHT_ARM,
		TARGET_ZONE_RIGHT_HAND = ORGAN_KEY_EXT_RIGHT_HAND,
		TARGET_ZONE_GROIN = ORGAN_KEY_EXT_GROIN,
		TARGET_ZONE_LEFT_LEG = ORGAN_KEY_EXT_LEFT_LEG,
		TARGET_ZONE_LEFT_FOOT = ORGAN_KEY_EXT_LEFT_FOOT,
		TARGET_ZONE_RIGHT_LEG = ORGAN_KEY_EXT_RIGHT_LEG,
		TARGET_ZONE_RIGHT_FOOT = ORGAN_KEY_EXT_RIGHT_FOOT,
	)
	var/obj/item/organ/external/fetched = keyed_organs[target_zone_rewrites[target_zone]]
	return (fetched && !fetched.is_stump()) ? fetched : null

//* API - Insert / Remove *//

/**
 * called on organ insert
 *
 * @params
 * * organ - the organ
 * * from_init - we are performing initial setup in Initialize() after we've grabbed our organs and templates from species / persistence.
 *                  this is not set in any other case.
 */
/mob/living/carbon/proc/on_organ_insert(obj/item/organ/organ, from_init)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called on insert
 *
 * @params
 * * organ - the organ
 * * from_qdel - we and the organ are being qdeleted in the QDEL_LIST loop.
 *               this is not set in any other case, including on gib and set_species().
 */
/mob/living/carbon/proc/on_organ_remove(obj/item/organ/organ, from_qdel)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

#warn impl

//! Usage of the below procs is heavily discouraged. They're just here to aid in transition. !//

/**
 * legacy: bodyzone to organ. technically works with internal organ keys too but please don't
 */
/mob/living/carbon/proc/legacy_organ_by_zone(what = BP_TORSO)
	// you'll notice this proc is the same as get_organ_for_zone.
	// it's because this proc doesn't have an assumption that we'll pass in only target zones.
	var/static/list/target_zone_rewrites = list(
		O_EYES = BP_HEAD,
		O_MOUTH = BP_HEAD,
	)
	return keyed_organs[what]

/**
 * legacy: get organ of type. **DANGEROUS.**
 */
/mob/living/carbon/proc/legacy_organ_by_type(type)
	return (locate(type) in internal_organs) || (locate(type) in external_organs)
