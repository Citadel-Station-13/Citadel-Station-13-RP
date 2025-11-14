//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * gas tanks used to provide gas to the suit's other modules
 */
/obj/item/rig_module/resource_store/gas_tank
	name = /obj/item/rig_module::name + " (gas tank)"
	desc = /obj/item/rig_module::desc + " This one provides gas storage."

/obj/item/rig_module/resource_store/gas_tank/slotted
	/// starting tank, typepath
	var/starting_tank
	/// override starting tank volume
	var/starting_tank_volume
	/// override starting tank gas, typepath or id
	/// * ignored if [starting_tank_pressure] is unset
	var/starting_tank_gas
	/// override starting tank pressure
	/// * ignored if [starting_tank_gas] is unset
	var/starting_tank_pressure

#warn impl

/obj/item/rig_module/resource_store/gas_tank/slotted

/obj/item/rig_module/resource_store/gas_tank/slotted/breathing
	name = /obj/item/rig_module::name + " (breathing gas tank slot)"
	desc = /obj/item/rig_module::desc + " This one provides gas storage, and \
	is restrained to the 'breathing' gas channel after numerous accidents involving \
	users accidentally routing maneuvering jet CO2 to their life support systems."

/obj/item/rig_module/resource_store/gas_tank/slotted/breathing/loaded

/obj/item/rig_module/resource_store/gas_tank/slotted/breathing/loaded/oxygen
	starting_tank = /obj/item/tank/oxygen
	starting_tank_pressure = ONE_ATMOSPHERE * 10
	starting_tank_gas = /datum/gas/oxygen

/obj/item/rig_module/resource_store/gas_tank/slotted/breathing/loaded/phoron
	starting_tank = /obj/item/tank/vox
	starting_tank_pressure = ONE_ATMOSPHERE * 10
	starting_tank_gas = /datum/gas/phoron

/obj/item/rig_module/resource_store/gas_tank/slotted/jetpack
	name = /obj/item/rig_module::name + " (jetpack gas tank slot)"
	desc = /obj/item/rig_module::desc + " This one provides gas storage, and \
	is restrained to the 'jetpack' gas channel after numerous accidents involving \
	users accidentally routing CO2 to their life support systems."

/obj/item/rig_module/resource_store/gas_tank/slotted/jetpack/loaded

/obj/item/rig_module/resource_store/gas_tank/slotted/jetpack/loaded/nitrogen
	starting_tank = /obj/item/tank/nitrogen
	starting_tank_pressure = ONE_ATMOSPHERE * 10
	starting_tank_gas = /datum/gas/nitrogen

/obj/item/rig_module/resource_store/gas_tank/internal
	/// starting volume
	var/starting_volume = 150
	/// starting gas
	var/starting_gas = /datum/gas/nitrogen::id
	/// starting pressure
	var/starting_pressure = 1013.15

// TODO: impl internal.
