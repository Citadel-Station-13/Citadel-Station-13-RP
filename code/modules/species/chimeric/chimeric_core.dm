//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * The core organ of a chimeric complex-type mob
 */
/obj/item/organ/internal/chimeric_core
	name = "chimeric core"
	desc = {"
		The abstraction representation of a chimera's internal structure.
		How are you even seeing this?
	"}

	/**
	 * Adaptation datums
	 */
	var/list/datum/chimeric_subsystem/adaptation/adaptations
	/**
	 * Ability datums
	 */
	var/list/datum/chimeric_subsystem/ability/abilities

	/**
	 * Core variable - Agitation
	 * * goes up as
	 */
	var/c_agitation = 0
	/**
	 * Core variable - Attrition
	 * * goes up as we take certain kinds of damage
	 * * goes up as we invoke our abilities more
	 * * falls off slower the higher it is
	 */
	var/c_attrition = 0

	/**
	 * Suppression descriptors
	 * * Chimeras are immune to a source if the ID isn't in here
	 */
	var/list/suppression_descriptors
	/**
	 * Suppression amounts
	 */
	var/list/suppression_amounts


/obj/item/organ/internal/chimeric_core/Initialize(mapload)
	initialize_suppression_tracking()
	return ..()

/obj/item/organ/internal/chimeric_core/Destroy()
	QDEL_LIST_ASSOC_VAL(suppression_descriptors)
	suppression_amounts?.len = 0
	return ..()

/obj/item/organ/internal/chimeric_core/proc/initialize_suppression_tracking()
	suppression_amounts = list()
	suppression_descriptors = list()

	for(var/datum/chimeric_suppression/suppression_path as anything in subtypesof(/datum/chimeric_suppression))
		suppression_descriptors[suppression_path.id] = new suppression_path

/obj/item/organ/internal/chimeric_core/on_insert(mob/living/carbon/target, from_init)
	. = ..()

/obj/item/organ/internal/chimeric_core/on_remove(mob/living/carbon/target, from_qdel)
	. = ..()

#warn examine hook



#warn impl ?

//* Abilities *//

/**
 * @params
 * * dt - time elapsed in seconds
 */
/obj/item/organ/internal/chimeric_core/proc/tick_abilities(dt)
	for(var/datum/chimeric_subsystem/ability as anything in abilities)
		if(!ability.requires_ticking)
			continue
		ability.on_chimeric_tick(dt)

//* Adaptations *//

/**
 * @params
 * * dt - time elapsed in seconds
 */
/obj/item/organ/internal/chimeric_core/proc/tick_adaptations(dt)
	for(var/datum/chimeric_subsystem/adaptation as anything in adaptations)
		if(!adaptation.requires_ticking)
			continue
		adaptation.on_chimeric_tick(dt)

//* Suppression *//

/obj/item/organ/internal/chimeric_core/proc/inflict_suppression(id, power)

/obj/item/organ/internal/chimeric_core/proc/get_suppression(id)

/**
 * @params
 * * dt - time elapsed in seconds.
 */
/obj/item/organ/internal/chimeric_core/proc/tick_suppression(dt)
