// for /datum/gas_mixture/proc/share_with_congruent_mixture(???, 1)
/datum/unit_test/gas_mixture_share_with_congruent_mixture_full/Run()
	var/datum/gas_mixture/one = new(1000)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 300, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)
	two.group_multiplier = 2

	var/total_energy_old = XGM_THERMAL_ENERGY(one) + XGM_THERMAL_ENERGY(two)

	one.share_with_congruent_mixture(two, 1)

	if(one.gas[GAS_ID_OXYGEN] != (1000 / 3))
		TEST_FAIL("share_with_congruent_mixture() didn't equalize gas (expected [(1000 / 3)], actual [one.gas[GAS_ID_OXYGEN]])")
	if(two.gas[GAS_ID_OXYGEN] != (1000 / 3 * 2))
		TEST_FAIL("share_with_congruent_mixture() didn't conserve gas (expected [(1000 / 3 * 2)], actual [two.gas[GAS_ID_OXYGEN]])")
	if(one.temperature != 280)
		TEST_FAIL("share_with_congruent_mixture() didn't equalize temp on side A (expected 280, actual [one.temperature])")
	if(two.temperature != 280)
		TEST_FAIL("share_with_congruent_mixture() didn't equalize temp on side B (expected 280, actual [two.temperature])")

	var/total_energy_new = XGM_THERMAL_ENERGY(one) + XGM_THERMAL_ENERGY(two)

	if(total_energy_old != total_energy_new)
		TEST_FAIL("share_with_congruent_mixture() didn't conserve energy (expected [total_energy_old], actual [total_energy_new])")

// todo: share_with_congruent_mixture_partial for /datum/gas_mixture/proc/share_with_congruent_mixture(???, 0.75)
// todo: share_with_immutable_full for /datum/gas_mixture/proc/share_with_immutable(???, ??? ???, 1)
// todo: share_with_immutable_partial for /datum/gas_mixture/proc/share_with_immutable(???, ??? ???, 1)

// for /datum/gas_mixture/proc/share_heat_with_mixture()
/datum/unit_test/gas_mixture_proc_share_heat_with_mixture/Run()
	var/datum/gas_mixture/one = new(1500)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 200, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)
	two.group_multiplier = 2

	var/total_energy_old = XGM_THERMAL_ENERGY(one) + XGM_THERMAL_ENERGY(two)

	// energy is same per mol as both us oxy; that's fine, we're not testing heat_capacity() here
	// one has 200 * 200 energy = 40,000, at 200K. 30,000 of that energy is shared.
	// two has 100 * 400 * 2 energy = 80,000, at 400K. 60,000 of that energy is shared.
	//
	// total capacity is 400. 300 of that is shared.
	// target share temperature should be 300.
	//
	// one should be at (10,000 + 300 * 150) / 200
	// two should be at (20,000 + 300 * 150) / 200

	one.share_heat_with_mixture(two, 0.75)

	if(one.temperature != 275)
		TEST_FAIL("share_heat_with_mixture() didn't equalize temp on side A (expected 275, actual [one.temperature])")
	if(two.temperature != 325)
		TEST_FAIL("share_heat_with_mixture() didn't equalize temp on side B (expected 325, actual [one.temperature])")

	var/total_energy_new = XGM_THERMAL_ENERGY(one) + XGM_THERMAL_ENERGY(two)

	if(total_energy_old != total_energy_new)
		TEST_FAIL("share_heat_with_mixture() didn't conserve energy (expected [total_energy_old], actual [total_energy_new])")
