//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/biology
	//* Hardcoded *//

	/// The type for our organ state. Defaults to not making a state holder.
	var/organ_state_holder_type
	/// The type for our mob state. Defaults to not making a state holder.
	var/mob_state_holder_type
	/// The biology type we're considered. This is for quick lookups.
	var/biology_type = NONE

	//* Organs & Mappings *//
	/// The typepaths to map specific organ slots to, by default.
	var/list/default_organ_mappings = list(
		ORGAN_KEY_EXT_HEAD = /obj/item/organ/external/head,
		ORGAN_KEY_EXT_CHEST = /obj/item/organ/external/chest,
		ORGAN_KEY_EXT_GROIN = /obj/item/organ/external/groin,
		ORGAN_KEY_EXT_LEFT_ARM = /obj/item/organ/external/arm/left,
		ORGAN_KEY_EXT_LEFT_HAND = /obj/item/organ/external/hand/left,
		ORGAN_KEY_EXT_RIGHT_ARM = /obj/item/organ/external/arm/right,
		ORGAN_KEY_EXT_RIGHT_HAND = /obj/item/organ/external/hand/right,
		ORGAN_KEY_EXT_LEFT_LEG = /obj/item/organ/external/leg/left,
		ORGAN_KEY_EXT_LEFT_FOOT = /obj/item/organ/external/foot/left,
		ORGAN_KEY_EXT_RIGHT_LEG = /obj/item/organ/external/leg/right,
		ORGAN_KEY_EXT_RIGHT_FOOT = /obj/item/organ/external/foot/right,
	)
	/// Default organ keys we should have.
	///
	/// * Species may override this by key.
	/// * Anything in this must be in [default_organ_mappings].
	/// * `ORGAN_KEY_BRAIN` is implicitly in this list.
	var/list/default_internal_organ_keys = list()

	//* Ticking *//

	/// Requires life ticking on the mob's global biological life tick.
	var/requires_mob_tick = FALSE
	/// Requires life ticking on an organ's biological life tick.
	var/requires_organ_tick = FALSE

/**
 * Called on organ Initialize, or biology change.
 */
/datum/biology/proc/on_organ_bind(obj/item/organ/organ, datum/biology_organ_state/state)
	#warn impl

/**
 * Called on organ Destroy, or biology change.
 */
/datum/biology/proc/on_organ_unbind(obj/item/organ/organ, datum/biology_organ_state/state)
	#warn impl

/**
 * Called when a mob receives us for the first time.
 */
/datum/biology/proc/on_mob_bind(mob/living/carbon/target, datum/biology_mob_state/state)
	#warn impl

/**
 * Called when a mob has us removed; usually from the last organ with our biology being removed from them.
 */
/datum/biology/proc/on_mob_unbind(mob/living/carbon/target, datum/biology_mob_state/state)
	#warn impl

/**
 * Called when an organ is created in a mob or otherwise inserted into a mob with us.
 *
 * * This happens after we are added to the mob, and `on_mob_bind` runs.
 */
/datum/biology/proc/on_organ_insert(obj/item/organ/organ, mob/living/carbon/target, datum/biology_organ_state/organ_state, datum/biology_mob_state/target_state)
	#warn impl

/**
 * Called when the last organ with us as its biology is removed from or destroyed for a given mob.
 *
 * * This happens before we are removed from the mob, and `on_mob_unbind` runs.
 */
/datum/biology/proc/on_organ_remove(obj/item/organ/organ, mob/living/carbon/target, datum/biology_organ_state/organ_state, datum/biology_mob_state/target_state)
	#warn impl

/**
 * Master life tick hook for the mob.
 *
 * @params
 * * dt - Time of tick in seconds.
 * * notch - Arbitrary number that should increment by 1 per fire.
 *           This is not a high-precision number, and is only provided so you
 *           may do slow-update handling.
 * * state - The `/datum/biology_mob_state` on this mob. You may typecast
 *           this to the value of `mob_state_holder_type`.
 */
/datum/biology/proc/mob_life_tick(dt, notch, datum/biology_mob_state/state)
	#warn impl

/**
 * Master life tick hook for an organ.
 *
 * @params
 * * dt - Time of tick in seconds.
 * * notch - Arbitrary number that should increment by 1 per fire.
 *           This is not a high-precision number, and is only provided so you
 *           may do slow-update handling.
 * * organ - The organ being ticked.
 * * state - The `/datum/biology_organ_state` on this organ. You may typecast
 *           this to the value of `organ_state_holder_type`.
 */
/datum/biology/proc/organ_life_tick(dt, notch, obj/item/organ/organ, datum/biology_mob_state/state)
	#warn impl
