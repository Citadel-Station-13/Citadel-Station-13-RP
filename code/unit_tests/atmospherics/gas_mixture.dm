/datum/unit_test/gas_mixture_share_with_congruent_mixture/Run()
	var/datum/gas_mixture/one = new(1000)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 300, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)

	one.share_with_congruent_mixture(two, 1)

	if(one.gas[GAS_ID_OXYGEN] != 200)
		TEST_FAIL("basic share didn't equalize gas (expected 200, actual [one.gas[GAS_ID_OXYGEN]])")
	else if(two.gas[GAS_ID_OXYGEN] != 200)
		TEST_FAIL("basic share didn't conserve gas (expected 200, actual [two.gas[GAS_ID_OXYGEN]])")
	if(one.temperature != 250)
		TEST_FAIL("basic share didn't equalize temp (expected 250, actual [one.temperature])")
	else if(two.temperature != 250)
		TEST_FAIL("basic share didn't conserve temp (expected 250, actual [two.temperature])")

// todo: share_with_immutable

/datum/unit_test/gas_mixture_proc_share_heat_with_mixture/Run()
	var/datum/gas_mixture/one = new(1000)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 100, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)

	one.share_heat_with_mixture(two, 0.5)

	if(one.temperature != 250)
		TEST_FAIL("basic share didn't equalize temp (expected 250, actual [one.temperature])")
	else if(two.temperature != 350)
		TEST_FAIL("basic share didn't conserve temp (expected 250, actual [two.temperature])")
