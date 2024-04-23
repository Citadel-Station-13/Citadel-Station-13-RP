//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * hold data on a preferred atmosphere for an airlock
 */
/datum/airlock_environment
	/// set this to just autoset from atmosphere (not the tolerances though!)
	/// atmosphere IDs and typepaths allowed; typepaths are encouraged.
	var/set_from_atmosphere
	#warn hook in New()

	/// ideal pressure in kpa
	var/pressure_ideal = 101.325
	/// pressure tolerance around ideal
	/// we still try to cycle to ideal, but if we're unable to,
	/// we can still open if within tolerance
	var/pressure_tolerance = 25

	/// ideal temperature in K
	var/temperature_ideal = T20C
	/// temperature tolerance
	/// if we're within this, we can still automatically open after cycling
	/// and getting stuck.
	var/temperature_tolerance = 20

	/// ideal gasmix ratios
	/// these should add up to 1
	var/list/gas_ratios_ideal = list(
		GAS_ID_OXYGEN = 0.21,
		GAS_ID_NITROGEN = 1 - 0.21,
	)
	/// gasmix ratio % tolerances
	/// this means for it to be considered safe we need to be within this % of normal
	/// not this much ratio, but this much % of nominal.
	/// set to a 0.x value; this value is a percentage as decimal. 20% is 0.2.
	var/gas_ratios_tolerance = 0.2

/datum/airlock_environment/New()
	#warn impl
