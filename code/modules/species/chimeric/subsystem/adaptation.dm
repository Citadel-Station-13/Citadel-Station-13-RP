//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * These are instanced, not shared singletons.
 */
/datum/chimeric_subsystem/adaptation
	/**
	 * Our name
	 */
	var/name = "Chimeric Adaptation"
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
	 * Requires ticking.
	 * * We have no control over our tick interval.
	 */
	var/requires_ticking = FALSE

#warn todo: base-level examine api, impl for all adaptations

/datum/chimeric_subsystem/adaptation/proc/on_register(obj/item/organ/internal/chimeric_core/core)

/datum/chimeric_subsystem/adaptation/proc/on_unregister(obj/item/organ/internal/chimeric_core/core)

/datum/chimeric_subsystem/adaptation/proc/on_mob_associate(mob/living/carbon/person)

/datum/chimeric_subsystem/adaptation/proc/on_mob_deassociate(mob/living/carbon/person)

/datum/chimeric_subsystem/adaptation/proc/on_organ_associate(obj/item/organ/organ)
	if(istype(organ, /obj/item/organ/internal))
		on_internal_organ_associate(organ)
	else if(istype(organ, /obj/item/organ/external))
		on_external_organ_associate(organ)

/datum/chimeric_subsystem/adaptation/proc/on_organ_deassociate(obj/item/organ/organ)
	if(istype(organ, /obj/item/organ/internal))
		on_internal_organ_deassociate(organ)
	else if(istype(organ, /obj/item/organ/external))
		on_external_organ_deassociate(organ)

/datum/chimeric_subsystem/adaptation/proc/on_internal_organ_associate(obj/item/organ/internal/organ)

/datum/chimeric_subsystem/adaptation/proc/on_internal_organ_deassociate(obj/item/organ/internal/organ)

/datum/chimeric_subsystem/adaptation/proc/on_external_organ_associate(obj/item/organ/external/organ)

/datum/chimeric_subsystem/adaptation/proc/on_external_organ_deassociate(obj/item/organ/external/organ)

#warn impl

/datum/chimeric_subsystem/adaptation/proc/panel_push_data(list/data)

/datum/chimeric_subsystem/adaptation/proc/panel_get_static_data()

/datum/chimeric_subsystem/adaptation/proc/panel_get_data()

/datum/chimeric_subsystem/adaptation/proc/panel_on_act(action, list/params)
	#warn wip

