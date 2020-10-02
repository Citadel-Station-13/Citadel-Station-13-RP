var/all_unit_tests_passed = 1
var/failed_unit_tests = 0
var/total_unit_tests = 0

/datum/unit_test
	var/name = "template"
	var/disabled = ""
	var/async = 0
	var/reported = 0

/datum/unit_test/proc/fail(var/message)
	all_unit_tests_passed = 0
	failed_unit_tests++
	reported = 1
	log_unit_test("[ASCII_RED]!! FAILURE !! \[[name]\]: [message][ASCII_RESET]")

/datum/unit_test/proc/pass(var/message)
	reported = 1
	log_unit_test("[ASCII_GREEN]** SUCCESS ** \[[name]\]: [message][ASCII_RESET]")

/datum/unit_test/proc/start_test()
	fail("No test proc.")

/datum/unit_test/proc/check_result()
	fail("No check results proc.")
	return 1


/proc/initialize_unit_tests()
	log_unit_test("Initializing Unit Testing")

	if(!SSticker)
		stack_trace("No SSticker")
		world.Del()

	var/said_msg = 0
	while(!Master.current_runlevel)	// Make sure the initial startup is complete.
		if(!said_msg)
			said_msg = 1
			log_unit_test("Waiting for subystems initilization to finish.")
		stoplag(10)

	world.save_mode("extended")

	sleep(1)

	SSticker.current_state = GAME_STATE_SETTING_UP
	Master.SetRunLevel(RUNLEVEL_SETUP)

	log_unit_test("Round has been started.  Waiting 10 seconds to start tests.")
	sleep(100)

	var/list/test_datums = typesof(/datum/unit_test)

	var/list/async_test = list()
	var/list/started_tests = list()

	log_unit_test("Testing Started.")

	for(var/test in test_datums)
		var/datum/unit_test/d = new test()

		if(d.disabled)
			d.pass("[ASCII_RED]Check Disabled: [d.disabled][ASCII_RESET]")
			continue

		if(findtext(d.name, "template"))
			continue

		if(isnull(d.start_test()))		// Start the test.
			d.fail("Test Runtimed")

		if(d.async)				// If it's async then we'll need to check back on it later.
			async_test.Add(d)
		total_unit_tests++

	//
	// Check the async tests to see if they are finished.
	//

	while(async_test.len)
		for(var/datum/unit_test/test in async_test)
			if(test.check_result())
				async_test.Remove(test)
		sleep(1)

	//
	// Make sure all Unit Tests reported a result
	//

	for(var/datum/unit_test/test in started_tests)
		if(!test.reported)
			test.fail("Test failed to report a result.")

	if(all_unit_tests_passed)
		log_unit_test("[ASCII_GREEN]*** All Unit Tests Passed \[[total_unit_tests]\] ***[ASCII_RESET]")
		world.Del()
	else
		log_unit_test("[ASCII_RED]!!! \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed !!![ASCII_RESET]")
		world.Del()

/datum/unit_test/proc/get_standard_turf()
	return locate(20,20,1)

/datum/unit_test/proc/log_bad(var/message)
	log_unit_test("[ASCII_RED]\[[name]\]: [message][ASCII_RESET]")

/datum/unit_test/proc/log_debug(var/message)
	log_unit_test("[ASCII_YELLOW]---  DEBUG  --- \[[name]\]: [message][ASCII_RESET]")

//
// VOREStation extensions to unit test framework.
//

/datum/unit_test
	var/static/default_mobloc = null

/datum/unit_test/proc/create_test_mob(var/turf/mobloc = null, var/mobtype = /mob/living/carbon/human, var/with_mind = FALSE)
	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world)
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		fail("Unable to find a location to create test mob")
		return FALSE

	var/mob/living/carbon/human/H = new mobtype(mobloc)

	if(with_mind)
		H.mind_initialize("TestKey[rand(0,10000)]")

	return H
