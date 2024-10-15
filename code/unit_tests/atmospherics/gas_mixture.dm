// for /datum/gas_mixture/proc/share_with_mixture(???, 1)
/datum/unit_test/gas_mixture_share_with_mixture_full/Run()
	// 1000L
	var/datum/gas_mixture/air_A = new(1000)
	air_A.adjust_gas_temp(GAS_ID_OXYGEN, 300, 200)
	// 1000L * 2
	var/datum/gas_mixture/air_B = new(1000)
	air_B.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)
	air_B.group_multiplier = 2

	air_A.update_values()
	air_B.update_values()

	var/total_energy_old = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	air_A.share_with_mixture(air_B, 1)

	if(air_A.gas[GAS_ID_OXYGEN] != (500 / 3))
		TEST_FAIL("share_with_mixture() didn't equalize gas (expected [(500 / 3)], actual [air_A.gas[GAS_ID_OXYGEN]])")
	if(air_B.gas[GAS_ID_OXYGEN] != (500 / 3))
		TEST_FAIL("share_with_mixture() didn't conserve gas (expected [(500 / 3)], actual [air_B.gas[GAS_ID_OXYGEN]])")
	if(air_A.temperature != 280)
		TEST_FAIL("share_with_mixture() didn't equalize temp on side A (expected 280, actual [air_A.temperature])")
	if(air_B.temperature != 280)
		TEST_FAIL("share_with_mixture() didn't equalize temp on side B (expected 280, actual [air_B.temperature])")

	var/total_energy_new = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	if(total_energy_old != total_energy_new)
		TEST_FAIL("share_with_mixture() didn't conserve energy (expected [total_energy_old], actual [total_energy_new])")

// todo: share_with_immutable_full for /datum/gas_mixture/proc/share_with_immutable(???, ??? ???, 1)
// todo: share_with_immutable_partial for /datum/gas_mixture/proc/share_with_immutable(???, ??? ???, 1)

// for /datum/gas_mixture/proc/share_heat_with_mixture()
/datum/unit_test/gas_mixture_proc_share_heat_with_mixture/Run()
	var/datum/gas_mixture/air_A = new(1500)
	air_A.adjust_gas_temp(GAS_ID_OXYGEN, 200, 200)
	var/datum/gas_mixture/air_B = new(1000)
	air_B.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)
	air_B.group_multiplier = 2

	var/total_energy_old = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	// energy is same per mol as both us oxy; that's fine, we're not testing heat_capacity() here
	// air_A has 200 * 200 energy = 40,000, at 200K. 30,000 of that energy is shared.
	// air_B has 100 * 400 * 2 energy = 80,000, at 400K. 60,000 of that energy is shared.
	//
	// total capacity is 400. 300 of that is shared.
	// target share temperature should be 300.
	//
	// air_A should be at (10,000 + 300 * 150) / 200
	// air_B should be at (20,000 + 300 * 150) / 200

	air_A.share_heat_with_mixture(air_B, 0.75)

	if(air_A.temperature != 275)
		TEST_FAIL("share_heat_with_mixture() didn't equalize temp on side A (expected 275, actual [air_A.temperature])")
	if(air_B.temperature != 325)
		TEST_FAIL("share_heat_with_mixture() didn't equalize temp on side B (expected 325, actual [air_A.temperature])")

	var/total_energy_new = XGM_THERMAL_ENERGY(air_A) + XGM_THERMAL_ENERGY(air_B)

	if(total_energy_old != total_energy_new)
		TEST_FAIL("share_heat_with_mixture() didn't conserve energy (expected [total_energy_old], actual [total_energy_new])")
