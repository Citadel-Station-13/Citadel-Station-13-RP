//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * reconcile an airlock towards an external gasmixture
 *
 * @params
 * * cyclers - which cyclers we're driving gas / heat through
 * * vents - which vents we're sinking / sourcing gas / heat from if able
 * * target - what to cycle towards
 * * supply - what to inject gas from; it's assumed that this gas is what we want. if not, abort.
 * * waste - what to expel gas into
 * * config_toggles - AIRLOCK_CONFIG_X; specifies what we need to care about
 * * minimum_tolerable_pressure - do not siphon airlock below this value
 * * power_limit - how much available power there is
 * * dt - time passed in seconds
 *
 * @return power used
 */
/proc/airlock_adaptive_reconcile(
	list/obj/machinery/airlock_component/cycler/cyclers,
	list/obj/machinery/airlock_component/vent/vents,
	datum/gas_mixture/target,
	datum/gas_mixture/supply,
	datum/gas_mixture/waste,
	config_toggles,
	minimum_tolerable_pressure,
	power_limit = INFINITY,
	dt = 1,
)



/**
 * reconcile an airlock towards an ideal environment
 *
 * @params
 * * cyclers - which cyclers we're driving gas / heat through
 * * vents - which vents we're sinking / sourcing gas / heat from if able
 * * target - what to cycle towards
 * * supply - what to inject gas from; it's assumed that this gas is what we want. if not, abort.
 * * waste - what to expel gas into
 * * config_toggles - AIRLOCK_CONFIG_X; specifies what we need to care about
 * * minimum_tolerable_pressure - do not siphon airlock below this value
 * * power_limit - how much available power there is
 * * dt - time passed in seconds
 *
 * @return power used
 */
/proc/airlock_fixed_reconcile(
	list/obj/machinery/airlock_component/cycler/cyclers,
	list/obj/machinery/airlock_component/vent/vents,
	datum/airlock_environment/target,
	datum/gas_mixture/supply,
	datum/gas_mixture/waste,
	config_toggles,
	minimum_tolerable_pressure,
	power_limit = INFINITY,
	dt = 1,
)

#warn impl all
