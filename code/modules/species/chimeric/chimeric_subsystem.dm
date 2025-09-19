//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * These are instanced, not shared singletons.
 */
/datum/chimeric_subsystem
	/**
	 * Our name
	 */
	var/name = "biological process"
	/**
	 * Our name as presented to players
	 * * If not set, defaults to name.
	 */
	var/display_name

	/**
	 * The core we belong to
	 */
	var/obj/item/organ/internal/chimeric_core/host_core

	/**
	 * Our TGUI interface key
	 */
	var/ui_interface

	/**
	 * Does this require ticking?
	 * * We have no control over how fast we are ticked. If you need
	 *   a 'fast ticker', implement it yourself with START_PROCESSING.
	 *   Abilities are deisnged like this to encourage not defaulting to
	 *   fast ticking.
	 */
	var/requires_ticking = FALSE

	/**
	 * Our actions, if any
	 * * Lazy list
	 */
	var/list/datum/action/actions

	/**
	 * Generalized suppression sources.
	 * * get_generalized_suppression() will return from all of these sources.
	 * * Use generalized suppression if it makes sense to. If it doesn't,
	 *   make additional suppression sources as variables.
	 * * DO NOT hardcode suppression IDs or typepaths, everything must be variables.
	 */
	var/list/generalized_suppression_source_ids

#warn todo: base-level examine api, impl for all adaptations

#warn impl all

//* Action *//

/**
 * Loads action buttons if they don't exist.
 */
/datum/chimeric_subsystem/proc/load_actions()
	if(actions)
		return
	create_actions()

/**
 * Creates our action buttons.
 * * Call `create_action()` from a subtype as needed, calling ..() first.
 */
/datum/chimeric_subsystem/proc/create_actions()
	QDEL_LIST_NULL(actions)
	actions = list()

/**
 * Creates an action button.
 * * Action will be created with ourselves as the target.
 */
/datum/chimeric_subsystem/proc/create_action(action_type)
	actions += new /datum/action(src)

//* Ticking *//

/datum/chimeric_subsystem/proc/on_chimeric_tick(dt)

//* TGUI Panel *//

/datum/chimeric_subsystem/proc/panel_push_data(list/data)

/datum/chimeric_subsystem/proc/panel_get_static_data()

/datum/chimeric_subsystem/proc/panel_get_data()

/datum/chimeric_subsystem/proc/panel_on_act(action, list/params)
	#warn wip

//*       Add / Remove Hooks       *//
//* Called from external handling  *//

/datum/chimeric_subsystem/proc/on_register(obj/item/organ/internal/chimeric_core/core)

/datum/chimeric_subsystem/proc/on_unregister(obj/item/organ/internal/chimeric_core/core)

/datum/chimeric_subsystem/proc/on_mob_associate(mob/living/carbon/person)

/datum/chimeric_subsystem/proc/on_mob_deassociate(mob/living/carbon/person)

/datum/chimeric_subsystem/proc/on_organ_associate(obj/item/organ/organ)
	if(istype(organ, /obj/item/organ/internal))
		on_internal_organ_associate(organ)
	else if(istype(organ, /obj/item/organ/external))
		on_external_organ_associate(organ)

/datum/chimeric_subsystem/proc/on_organ_deassociate(obj/item/organ/organ)
	if(istype(organ, /obj/item/organ/internal))
		on_internal_organ_deassociate(organ)
	else if(istype(organ, /obj/item/organ/external))
		on_external_organ_deassociate(organ)

/datum/chimeric_subsystem/proc/on_internal_organ_associate(obj/item/organ/internal/organ)

/datum/chimeric_subsystem/proc/on_internal_organ_deassociate(obj/item/organ/internal/organ)

/datum/chimeric_subsystem/proc/on_external_organ_associate(obj/item/organ/external/organ)

/datum/chimeric_subsystem/proc/on_external_organ_deassociate(obj/item/organ/external/organ)

//* Suppression *//

/**
 * Get generalized suppression amount.
 */
/datum/chimeric_subsystem/proc/get_generalized_suppression_via_add_tally()
	#warn impl

/**
 * Get generalized suppression amount.
 */
/datum/chimeric_subsystem/proc/get_generalized_suppression_via_max_tally()
	#warn impl
