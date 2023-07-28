//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/proc/generate_procedural_gas(path, list/arguments)
	var/datum/procedural_gas/instance = new path(arglist(arguments))
	if(!instance.instance())
		return
	if(!instance.generate())
		return
	if(!instance.register())
		return
	return instance

/**
 * datums used to procedurally generate gas
 */
/datum/procedural_gas
	/// id to use
	var/id
	/// numerical id - used internally
	var/number
	/// name
	var/name
	/// gas flags
	var/gas_flags = NONE
	/// gas groups
	var/gas_groups = NONE
	/// specific heat
	var/specific_heat = 1
	/// molar mass
	var/molar_mass = 1

	// todo: reagents
	// todo: reagents
	// todo: reagents

	/// gas generation flags
	var/procedural_gas_flags = NONE

/datum/procedural_gas/New(procedural_gas_flags)
	src.procedural_gas_flags = procedural_gas_flags

/datum/procedural_gas/proc/instance()
	RETURN_TYPE(/datum/gas)
	number = ++global.gas_data.next_procedural_gas_id
	id = "[GAS_ID_PREFIX_PROCGEN][number]"

/datum/procedural_gas/proc/generate()
	. = FALSE
	CRASH("not implemented")

/datum/procedural_gas/proc/register()
	var/datum/gas/gas = new
	gas.id = id
	gas.name = name
	gas.gas_flags = gas_flags
	gas.gas_groups = gas_groups
	gas.specific_heat = specific_heat
	gas.molar_mass = molar_mass

/datum/procedural_gas/proc/round_stable_random_name()
	// todo: this is not round stable. we'd need db/whatever for that, deal with this when we do repository systems + persistence
	return "unkw#[number]"

/**
 * standard random
 */
/datum/procedural_gas/random
	var/oxidizer_chance = 30
	var/fuel_chance = 15
	var/unary_burnmix_chance = 25

	// todo: molar mass vars
	// todo: specific heat vars

/datum/procedural_gas/random/generate()
	name = round_stable_random_name()
	gas_flags = GAS_FLAG_UNKNOWN
	gas_groups = GAS_GROUP_UNKNOWN

	if(prob(oxidizer_chance) && (procedural_gas_flags & PROCEDURAL_GAS_ALLOW_OXIDIZER))
		gas_flags |= GAS_FLAG_OXIDIZER
		if(prob(unary_burnmix_chance) && (procedural_gas_flags & PROCEDURAL_GAS_ALLOW_UNARY_BURNMIX))
			gas_flags |= GAS_FLAG_FUEL
	else if(prob(fuel_chance) && (procedural_gas_flags & PROCEDURAL_GAS_ALLOW_FUEL))
		gas_flags |= GAS_FLAG_FUEL
		if(prob(unary_burnmix_chance) && (procedural_gas_flags & PROCEDURAL_GAS_ALLOW_UNARY_BURNMIX))
			gas_flags |= GAS_FLAG_OXIDIZER

	// todo: optimize this shit
	for(var/i in 1 to 1000)
		var/potential = rand(3 * GAS_COLLISION_FACTOR_MOLAR_MASS, 150 * GAS_COLLISION_FACTOR_MOLAR_MASS) / GAS_COLLISION_FACTOR_MOLAR_MASS
		var/success = TRUE
		for(var/id in global.gas_data.molar_masses)
			var/mass = global.gas_data.molar_masses[id]
			if(abs(mass - potential) <= GAS_COLLISION_THRESHOLD_MOLAR_MASS)
				success = FALSE
				break
		if(success)
			molar_msas = potential
			break

	specific_heat = rand(3 * 10, 300 * 10) / 10
