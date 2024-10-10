/datum/unit_test/gas_mixture_basic_share/Run()
	var/datum/gas_mixture/one = new(1000)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 300, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)

	one.share_with_mixture(two, 1)

	if(one.gas[GAS_ID_OXYGEN] != 200)
		TEST_FAIL("basic share didn't equalize gas")
	else if(two.gas[GAS_ID_OXYGEN] != 200)
		TEST_FAIL("basic share didn't conserve gas")
	if(one.temperature != 250)
		TEST_FAIL("basic share didn't equalize temp")
	else if(two.temperature != 250)
		TEST_FAIL("basic share didn't conserve temp")

/datum/unit_test/gas_mixture_basic_temp_share/Run()
	var/datum/gas_mixture/one = new(1000)
	one.adjust_gas_temp(GAS_ID_OXYGEN, 100, 200)
	var/datum/gas_mixture/two = new(1000)
	two.adjust_gas_temp(GAS_ID_OXYGEN, 100, 400)

	one.share_heat_with_mixture(two, 0.5)

	if(one.temperature != 250)
		TEST_FAIL("basic temp share didn't equalize temp")
	else if(two.temperature != 350)
		TEST_FAIL("basic temp share didn't conserve temp")
