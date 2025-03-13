//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * The core organ of a chimeric complex-type mob
 *
 * * As of right now, also serves as their consciousness. This is because
 *   'debraining' a chimera generally doesn't mean anything canonically as
 *   they aren't a centralized lifeform.
 */
/obj/item/organ/internal/brain/chimeric_core
	name = "chimeric core"
	desc = {"
		The abstraction representation of a chimera's internal structure.
		How are you even seeing this?
	"}

	/**
	 * Adaptation datums
	 */
	var/list/datum/chimeric_adaptation/adaptations

/obj/item/organ/internal/brain/chimeric_core/Initialize(mapload)

	return ..()

/obj/item/organ/internal/brain/chimeric_core/Destroy()

	return ..()

/obj/item/organ/internal/brain/chimeric_core/on_insert(mob/living/carbon/target, from_init)
	. = ..()

/obj/item/organ/internal/brain/chimeric_core/on_remove(mob/living/carbon/target, from_qdel)
	. = ..()

#warn examine hook

/obj/item/organ/internal/brain/chimeric_core


#warn impl ?
