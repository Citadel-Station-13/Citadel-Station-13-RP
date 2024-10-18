// for /datum/zas_edge/zone/proc/equalize()
/datum/unit_test/atmos_zone_edge_equalize/Run()
	var/datum/zas_zone/zone_A = new
	var/datum/zas_zone/zone_B = new

	var/datum/zas_edge/edge = new /datum/zas_edge/zone(zone_A, zone_B)

	var/datum/gas_mixture/air_A = new /datum/gas_mixture(CELL_VOLUME)
	zone_A.air = air_A
	var/datum/gas_mixture/air_B = new /datum/gas_mixture(CELL_VOLUME)
	zone_B.air = air_B

	air_A.group_multiplier = 4
	air_B.group_multiplier = 1

	air_A.gas = list(
		GAS_ID_OXYGEN = 5,
	)
	air_B.gas = list(
		GAS_ID_OXYGEN = 80,
	)
	air_A.temperature = 300
	air_B.temperature = 100

	air_A.update_values()
	air_B.update_values()

	var/total_energy_old = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	edge.equalize()

	TEST_ASSERT_EQUAL(air_A.gas[GAS_ID_OXYGEN], 20, "")
	TEST_ASSERT_EQUAL(air_B.gas[GAS_ID_OXYGEN], 20, "")
	TEST_ASSERT_EQUAL(air_A.temperature, 140, "")
	TEST_ASSERT_EQUAL(air_B.temperature, 140, "")

	var/total_energy_new = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	if(total_energy_old != total_energy_new)
		TEST_FAIL("equalize() didn't conserve energy (expected [total_energy_old], actual [total_energy_new])")

	edge.erase()
	zone_A.c_invalidate()
	zone_B.c_invalidate()
