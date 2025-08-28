//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * When this is on a mob, allows things to override the air mixture a mob is exposed to.
 */
/datum/component/mob_sealed_atmos_provider
	/// list of registration entries
	/// * callbacks are invoked with (mob, src, for_breathing)
	/// * callbacks should never edit the registration list, otherwise it might brick the component
	///   and cause a memory leak
	var/list/datum/mob_sealed_atmos_provider_entry/entries

#warn impl

/datum/component/mob_sealed_atmos_provider/proc/get_gas_mixture(for_breathing) as /datum/gas_mixture

/datum/component/mob_sealed_atmos_provider/proc/register(datum/handler, datum/callback/callback, priority)

/datum/component/mob_sealed_atmos_provider/proc/unregister(datum/handler)
	for(var/datum/mob_sealed_atmos_provider_entry/entry as anything in entries)
		if(entry.registered_datum == handler)
			entries -= entry
			if(!length(entries))
				entries = null
			return TRUE
	return FALSE

/datum/mob_sealed_atmos_provider_entry
	var/datum/registered_datum
	var/datum/callback/registered_callback
	var/priority
