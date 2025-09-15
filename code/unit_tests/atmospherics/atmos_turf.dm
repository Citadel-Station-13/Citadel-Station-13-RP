// todo: atmos_turf_air_thermal_superconduction

// for /turf/proc/air_thermal_superconduction()
// todo: per-test reservations; this really shouldn't run in main unit test reservation!
/datum/unit_test/atmos_turf_air_thermal_superconduction_unsimulated/Run()
	var/turf/test_turf = run_loc_floor_bottom_left.ChangeTurf(/turf/unsimulated/floor)

	test_turf.initial_gas_mix = "o2=100&TEMP=1000"
	test_turf.make_air()

	TEST_ASSERT_NOTNULL(test_turf.air, null)

	var/hypothetical_container_volume = 1000
	var/hypothetical_exchange_volume = 200
	var/hypothetical_thermal_conductivity = 0.25

	var/initial_temperature = 500
	var/initial_moles = 10
	var/initial_heat_capacity = /datum/gas/oxygen::specific_heat * initial_moles

	// 5 pieces of the exchanger @ 40L each is touching an unsim turf
	var/cell_limit = 5
	// 200
	var/limit_ratio = hypothetical_exchange_volume / hypothetical_container_volume
	// 0.2
	var/equalize_ratio = hypothetical_thermal_conductivity

	// 10 * 500 * 0.2 --> 10 mols of 500K gas, with 0.2 ratio exposed
	// 100 * 1000 * 5 --> 100 mols of 1000K gas, with 5 ratio exposed (5 group multiplier)
	var/estimated_midpoint = (10 * 500 * 0.2 + 100 * 1000 * 5) / (100 * 5 + 10 * 0.2)

	var/expected_temperature = initial_temperature + (estimated_midpoint - initial_temperature) * equalize_ratio * limit_ratio
	var/expected_energy = expected_temperature * initial_heat_capacity

	var/actual_temperature_change = test_turf.air_thermal_superconduction(initial_temperature, initial_heat_capacity, limit_ratio, equalize_ratio, cell_limit)
	var/actual_temperature = initial_temperature + actual_temperature_change
	var/actual_energy = (initial_temperature + actual_temperature_change) * initial_heat_capacity

	if(!XGM_MOSTLY_CLOSE_ENOUGH(actual_temperature, expected_temperature))
		TEST_FAIL("expected temperature [num2text(expected_temperature, 16)], actual [num2text(actual_temperature, 16)]")
	if(!XGM_MOSTLY_CLOSE_ENOUGH(actual_energy, expected_energy))
		TEST_FAIL("expected energy [num2text(expected_energy, 16)], actual [num2text(actual_energy, 16)]")

	test_turf.ChangeTurf(/turf/simulated/floor/plating)

// for /turf/simulated/air_thermal_superconduction()
// todo: per-test reservations; this really shouldn't run in main unit test reservation!
/datum/unit_test/atmos_turf_air_thermal_superconduction_simulated/Run()
	var/turf/simulated/test_turf = run_loc_floor_bottom_left.ChangeTurf(/turf/simulated/floor/plating)

	test_turf.initial_gas_mix = "o2=100&TEMP=1000"
	test_turf.make_air()

	TEST_ASSERT_NOTNULL(test_turf.air, null)
	TEST_ASSERT_NULL(test_turf.zone, null)

	var/hypothetical_container_volume = 1000
	var/hypothetical_exchange_volume = 200
	var/hypothetical_thermal_conductivity = 0.25

	var/initial_temperature = 500
	var/initial_moles = 10
	var/initial_heat_capacity = /datum/gas/oxygen::specific_heat * initial_moles
	var/initial_energy = initial_temperature * initial_heat_capacity

	// 5 pieces of the exchanger @ 40L each is touching a sim turf with a 5-large zone on it
	var/cell_limit = 5
	// jank but this unit test isn't here to test zones
	test_turf.air.group_multiplier = 5
	// 200
	var/limit_ratio = hypothetical_exchange_volume / hypothetical_container_volume
	// 0.2
	var/equalize_ratio = hypothetical_thermal_conductivity

	// 10 * 500 * 0.2 --> 10 mols of 500K gas, with 0.2 ratio exposed
	// 100 * 1000 * 5 --> 100 mols of 1000K gas, with 5 ratio exposed (5 group multiplier)
	var/estimated_midpoint = (10 * 500 * 0.2 + 100 * 1000 * 5) / (100 * 5 + 10 * 0.2)

	var/expected_temperature = initial_temperature + (estimated_midpoint - initial_temperature) * equalize_ratio * limit_ratio
	var/expected_energy = expected_temperature * initial_heat_capacity

	var/total_energy_old = XGM_THERMAL_ENERGY(test_turf.air) + initial_energy

	var/actual_temperature_change = test_turf.air_thermal_superconduction(initial_temperature, initial_heat_capacity, limit_ratio, equalize_ratio, cell_limit)
	var/actual_temperature = initial_temperature + actual_temperature_change
	var/actual_energy = (initial_temperature + actual_temperature_change) * initial_heat_capacity

	var/total_energy_new = XGM_THERMAL_ENERGY(test_turf.air) + actual_energy

	if(!XGM_MOSTLY_CLOSE_ENOUGH(actual_temperature, expected_temperature))
		TEST_FAIL("expected temperature [num2text(expected_temperature, 16)], actual [num2text(actual_temperature, 16)]")
	if(!XGM_MOSTLY_CLOSE_ENOUGH(actual_energy, expected_energy))
		TEST_FAIL("expected energy [num2text(expected_energy, 16)], actual [num2text(actual_energy, 16)]")
	if(!XGM_MOSTLY_CLOSE_ENOUGH(total_energy_old, total_energy_new))
		TEST_FAIL("energy was not conserved: [num2text(total_energy_old, 16)] --> [num2text(total_energy_new, 16)]")

	// revert jank shit we did incase changeturf doesn't
	test_turf.air.group_multiplier = 1

	test_turf.ChangeTurf(/turf/simulated/floor/plating)
