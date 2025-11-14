//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Gets the gas mixture our environment is.
 * This is a wrapper proc that lets things override it as needed.
 * @params
 * * for_breathing - this is for breath procs. If this is TRUE, some things like helmets may override
 *                   even if the suit it's part of is not sealed.
 */
/mob/proc/get_environment_gas_mixture(for_breathing) as /datum/gas_mixture
	var/datum/component/mob_sealed_atmos_provider/sealed_atmos_provider_component = GetComponent(/datum/component/mob_sealed_atmos_provider)
	if(sealed_atmos_provider_component)
		. = sealed_atmos_provider_component.get_gas_mixture(for_breathing)
	if(.)
		return
	. = loc?.return_air_for_internal_mob(src)
