/*

Usage:
Override /Run() to run your test code

Call Fail() to fail the test (You should specify a reason)

You may use /New() and /Destroy() for setup/teardown respectively

You can use the run_loc_bottom_left and run_loc_top_right to get turfs for testing

*/

GLOBAL_DATUM(current_test, /datum/unit_test)
GLOBAL_VAR_INIT(failed_any_test, FALSE)
GLOBAL_VAR(test_log)

/datum/unit_test
	//Bit of metadata for the future maybe
	var/list/procs_tested

	//usable vars
	var/turf/run_loc_bottom_left
	var/turf/run_loc_top_right

	//internal shit
	var/succeeded = TRUE
	var/list/fail_reasons

/datum/unit_test/New()
	run_loc_bottom_left = locate(1, 1, 1)
	run_loc_top_right = locate(5, 5, 1)

/datum/unit_test/Destroy()
	//clear the test area
	for(var/atom/movable/AM in block(run_loc_bottom_left, run_loc_top_right))
		qdel(AM)
	return ..()

/datum/unit_test/proc/Run()
	Fail("Run() called parent or not implemented")

/datum/unit_test/proc/Fail(reason = "No reason")
	succeeded = FALSE

	if(!istext(reason))
		reason = "FORMATTED: [reason != null ? reason : "NULL"]"

	reason = "[ASCII_RED][reason][ASCII_RESET]"

	LAZYADD(fail_reasons, reason)

/proc/RunUnitTests()
	CHECK_TICK

	for(var/I in subtypesof(/datum/unit_test))
		var/datum/unit_test/test = new I

		GLOB.current_test = test
		var/duration = REALTIMEOFDAY

		test.Run()

		duration = REALTIMEOFDAY - duration
		GLOB.current_test = null
		GLOB.failed_any_test |= !test.succeeded

		var/list/log_entry = list("[test.succeeded ? "[ASCII_GREEN]PASS" : "[ASCII_RED]FAIL"]: [I] [duration / 10]s[ASCII_RESET]")
		var/list/fail_reasons = test.fail_reasons

		qdel(test)

		for(var/J in 1 to LAZYLEN(fail_reasons))
			log_entry += "\tREASON #[J]: [fail_reasons[J]]"
		log_test(log_entry.Join("\n"))

		CHECK_TICK

	// SSticker.force_ending = TRUE
	universe_has_ended = TRUE //assume the test is a resonant cascade.
	SSticker.post_game = TRUE //shh, this is bad i know
	SSticker.round_process()
