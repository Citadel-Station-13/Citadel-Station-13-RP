//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * hold data on a preferred atmosphere for an airlock
 */
/datum/airlock_environment
	/// set this to just autoset from atmosphere (not the tolerances though!)
	/// atmosphere IDs and typepaths allowed; typepaths are encouraged.
	var/set_from_atmosphere

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
	/// please put them in with ratio format.
	var/list/gas_ratios_ideal = list(
		GAS_ID_OXYGEN = 0.21,
		GAS_ID_NITROGEN = 0.79,
	)
	/// gasmix ratio % tolerances
	/// this means for it to be considered safe we need to be within this % of normal
	/// not this much ratio, but this much % of nominal.
	/// set to a 0.x value; this value is a percentage as decimal. 20% is 0.2.
	var/gas_ratios_tolerance = 0.2

/**
 * @params
 * * import_from - either a /datum/atmosphere path/instance/id, a turf, or a json serialize()'d list
 */
/datum/airlock_environment/New(import_from)
	if(isturf(import_from))
		set_from_turf(import_from)
	// is either atmosphere datum typepath, instance, or not a json string; we assume atmosphere ID
	else if(ispath(import_from, /datum/atmosphere) || (istext(import_from) && import_from[1] == "{") || istype(import_from, /datum/atmosphere))
		set_from_atmosphere(import_from)
	else if(import_from)
		set_from_import(import_from)
	else if(set_from_atmosphere)
		set_from_atmosphere(set_from_atmosphere)

/datum/airlock_environment/serialize()
	. = ..()
	.["pressure"] = pressure_ideal
	.["pressureTolerance"] = pressure_tolerance
	.["temperature"] = temperature_ideal
	.["temperatureTolerance"] = temperature_tolerance
	.["gasRatios"] = gas_ratios_ideal
	.["gasTolerance"] = gas_ratios_tolerance

/datum/airlock_environment/deserialize(list/data)
	. = ..()
	OPTIONALLY_DESERIALIZE_NUMBER(data["gasTolerance"], gas_ratios_tolerance)
	OPTIONALLY_DESERIALIZE_NUMBER(data["temperatureTolerance"], temperature_tolerance)
	OPTIONALLY_DESERIALIZE_NUMBER(data["pressureTolerance"], pressure_tolerance)
	if(data["fromAtmosphere"])
		set_from_atmosphere(data["fromAtmosphere"])
		return
	REQUIRED_DESERIALIZE_NUMBER(data["pressure"], pressure_ideal)
	REQUIRED_DESERIALIZE_NUMBER(data["temperature"], temperature_ideal)
	REQUIRED_DESERIALIZE_LIST(data["gasRatios"], gas_ratios_ideal)

/datum/airlock_environment/proc/set_from_atmosphere(what)
	var/datum/atmosphere/fetched = SSair.generated_atmospheres[what]
	if(isnull(fetched))
		stack_trace("failed atmosphere fetch on [what]")
		return
	pressure_ideal = fetched.gas_pressure
	temperature_ideal = fetched.gas_temperature
	gas_ratios_ideal = fetched.gas_ratios

/datum/airlock_environment/proc/set_from_turf(turf/what)
	var/list/returned = SSair._parse_gas_string(what.initial_gas_mix, what)
	var/list/gases = returned[1]
	var/list/ratios = list()
	var/total_moles = 0
	for(var/id in gases)
		total_moles += gases[id]
	for(var/id in gases)
		ratios[id] = gases[id] / total_moles
	var/temperature = returned[2]

	temperature_ideal = temperature
	pressure_ideal = (R_IDEAL_GAS_EQUATION * temperature * total_moles) / CELL_VOLUME
	gas_ratios_ideal = ratios

/datum/airlock_environment/proc/set_from_import(what)
	if(istext(what))
		deserialize(safe_json_decode(what))
	else if(islist(what))
		deserialize(what)
	else
		CRASH("invalid data")
