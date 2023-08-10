//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * system for both
 * 1. bundling together gas string defines so they're not hardcoded gas strings
 * 2. pregenerating random atmosphers
 *
 * generation process:
 * 0. target pressure and temperature are determined
 * 1. base is expanded to base_pressure
 * 2. procedurally generate gases with random vars
 *    if there's no random, use base gases.
 */
/datum/atmosphere
	/// don't initialize abstract datums.
	abstract_type = /datum/atmosphere
	/// generated gas string. do not modify.
	var/gas_string
	/// unique id. defaults to typepath.
	var/id

	/// target volume, incase we want to generate for something that isn't a tile, this lets you set it.
	var/volume = CELL_VOLUME

	var/pressure_gaussian = FALSE
	var/pressure_center
	var/pressure_deviation
	var/pressure_low
	var/pressure_high

	var/temperature_gaussian = FALSE
	var/temperature_center
	var/temperature_deviation
	var/temperature_low
	var/temperature_high

	/// base gases. gas id or typepath to ratio.
	var/list/base = list()
	/// target pressure to fill base to; if null, and base isn't empty, we fill the whole thing!
	var/base_pressure

	// todo: random_markov and have key = list(other key = probability)
	/// key: gasid, typepath, or random_procedural key to probability.
	var/list/random = list()
	/// nominal random steps: the target moles per step is determined by this. actual steps may vary.
	/// higher = more uniform, lower = more rough
	/// 0 = single pick
	var/random_nominal_steps = 10
	/// random procedural gases to throw into the mix.
	/// key = typepath.
	/// this will override gas lookup, so be careful not to use a real gasid.
	var/list/random_procedural = list()

/datum/atmosphere/New()
	if(!id)
		id = "[type]"
	generate()

/datum/atmosphere/proc/generate()
	// generate wanted pressure/temperature
	var/target_pressure = pressure_gaussian? gaussian(pressure_center, pressure_deviation) : (rand(pressure_low * 100, pressure_high * 100) * 0.01)
	var/target_temperature = temperature_gaussian? gaussian(temperature_center, temperature_deviation) : (rand(temperature_low * 100, temperature_high * 100) * 0.01)

	// init tracking
	var/list/target_gases = list()
	var/total_moles = 0
	var/target_moles = (target_pressure * volume) / (R_IDEAL_GAS_EQUATION * target_temperature)

	// generate base
	var/total_base = 0
	for(var/i in 1 to length(base))
		var/what = base[i]
		var/ratio = base[what]
		if(ispath(what, /datum/gas))
			var/datum/gas/casted = what
			what = initial(casted.id)
			base[i] = what
			base[what] = ratio
		total_base += ratio

	var/moles_base = ((isnull(base_pressure)? (length(base)? target_pressure : 0) : base_pressure) * volume) / (R_IDEAL_GAS_EQUATION * target_temperature)
	var/ratio_base = moles_base / total_base
	if(ratio_base)
		for(var/what in base)
			var/amount = ratio_base * base[what]
			total_moles += amount
			target_gases[what] = amount

	// check if we have enough
	if(total_moles >= target_moles)
		gas_string = get_gas_string(target_gases, target_temperature)
		return

	// generate rest
	var/moles_per_step = (target_moles - total_moles) / random_nominal_steps
	// safety
	for(var/i in 1 to 200)
		if(total_moles >= target_moles)
			break
		var/left = target_moles - total_moles
		var/moles_this_step = min(rand(75, 125) * 0.01 * moles_per_step, left)
		// todo: markov chain support by just having pickweight on key = list
		var/key = pickweight(random)
		if(random_procedural[key])
			if(ispath(random_procedural[key]))
				var/datum/procedural_gas/generated = new random_procedural[key]
				generated.instance()
				generated.generate()
				generated.register()
				random_procedural[key] = generated
			key = random_procedural[key]
		target_gases[key] += moles_this_step
		total_moles += moles_this_step

	gas_string = get_gas_string(target_gases, target_temperature)

