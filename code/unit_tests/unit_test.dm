/*

Usage:
Override /Run() to run your test code

Call TEST_FAIL() to fail the test (You should specify a reason)

You may use /New() and /Destroy() for setup/teardown respectively

You can use the run_loc_floor_bottom_left and run_loc_floor_top_right to get turfs for testing

*/

GLOBAL_DATUM(current_test, /datum/unit_test)
GLOBAL_VAR_INIT(failed_any_test, FALSE)
GLOBAL_VAR(test_log)
/// When unit testing, all logs sent to log_mapping are stored here and retrieved in log_mapping unit test.
GLOBAL_LIST_EMPTY(unit_test_mapping_logs)
/// Global assoc list of required mapping items, [item typepath] to [required item datum].
GLOBAL_LIST_EMPTY(required_map_items)

GLOBAL_LIST_EMPTY(test_run_times)

/// A list of every test that is currently focused.
/// Use the PERFORM_ALL_TESTS macro instead.
GLOBAL_VAR_INIT(focused_tests, focused_tests())

/proc/focused_tests()
	var/list/focused_tests = list()
	for (var/datum/unit_test/unit_test as anything in subtypesof(/datum/unit_test))
		if (initial(unit_test.focus))
			focused_tests += unit_test

	return focused_tests.len > 0 ? focused_tests : null

/datum/unit_test
	/// Do not instantiate if type matches this
	abstract_type = /datum/unit_test

	//Bit of metadata for the future maybe
	var/list/procs_tested

	/// The bottom left floor turf of the testing zone
	var/turf/run_loc_floor_bottom_left

	/// The top right floor turf of the testing zone
	var/turf/run_loc_floor_top_right
	///The priority of the test, the larger it is the later it fires
	var/priority = TEST_DEFAULT
	//internal shit
	var/focus = FALSE
	var/succeeded = TRUE
	var/list/allocated
	var/list/fail_reasons

	/// If TRUE, room is reset after. Useful for things that blow shit up.
	var/reset_room_after = FALSE

	/// List of atoms that we don't want to ever initialize in an agnostic context, like for Create and Destroy. Stored on the base datum for usability in other relevant tests that need this data.
	var/static/list/uncreatables = null

	var/static/datum/map_level/reservation

/proc/cmp_unit_test_priority(datum/unit_test/a, datum/unit_test/b)
	return initial(a.priority) - initial(b.priority)

/datum/unit_test/New()
	if (isnull(reservation))
		var/datum/map_level/unit_tests/reserved = new
		SSmapping.load_level(reserved)
		reservation = reserved

	if (isnull(uncreatables))
		uncreatables = build_list_of_uncreatables()

	allocated = new

	run_loc_floor_bottom_left = get_turf(locate(/obj/landmark/unit_test_bottom_left) in GLOB.landmarks_list)
	run_loc_floor_top_right = get_turf(locate(/obj/landmark/unit_test_top_right) in GLOB.landmarks_list)

	//Make sure that the top and bottom locations in the diagonal are floors. Anything else may get in the way of several tests.
	TEST_ASSERT(isfloorturf(run_loc_floor_bottom_left), "run_loc_floor_bottom_left was not a floor ([run_loc_floor_bottom_left])")
	TEST_ASSERT(isfloorturf(run_loc_floor_top_right), "run_loc_floor_top_right was not a floor ([run_loc_floor_top_right])")

/datum/unit_test/Destroy()
	QDEL_LIST(allocated)
	// clear the test area
	for (var/turf/turf in Z_TURFS(run_loc_floor_bottom_left.z))
		for (var/content in turf.contents)
			if (istype(content, /obj/landmark))
				continue
			qdel(content)
	return ..()

/datum/unit_test/proc/Run()
	TEST_FAIL("[type]/Run() called parent or not implemented")

/datum/unit_test/proc/Fail(reason = "No reason", file = "OUTDATED_TEST", line = 1)
	succeeded = FALSE

	if(!istext(reason))
		reason = "FORMATTED: [reason != null ? reason : "NULL"]"

	LAZYADD(fail_reasons, list(list(reason, file, line)))

/// Allocates an instance of the provided type, and places it somewhere in an available loc
/// Instances allocated through this proc will be destroyed when the test is over
/datum/unit_test/proc/allocate(type, ...)
	if(priority > TEST_CREATE_AND_DESTROY) //I'm not using TEST_ASSERT here since these are just numbers that tell nothing useful about the problem.
		TEST_FAIL("allocate() was called for a unit test after 'create_and_destroy' has finished. The unit test room is no longer a reliable testing ground for atoms.")
		return null //you deserve runtime errors for it
	var/list/arguments = args.Copy(2)
	if(ispath(type, /atom))
		if (!arguments.len)
			arguments = list(run_loc_floor_bottom_left)
		else if (arguments[1] == null)
			arguments[1] = run_loc_floor_bottom_left
	var/instance
	// Byond will throw an index out of bounds if arguments is empty in that arglist call. Sigh
	if(length(arguments))
		instance = new type(arglist(arguments))
	else
		instance = new type()
	allocated += instance
	return instance

/// Resets the air of our testing room to its default
// TODO implement this on ZAS
// /datum/unit_test/proc/restore_atmos()
// 	var/area/working_area = run_loc_floor_bottom_left.loc
// 	var/list/turf/to_restore = working_area.get_turfs_from_all_zlevels()
// 	for(var/turf/open/restore in to_restore)
// 		var/datum/gas_mixture/GM = SSair.parse_gas_string(restore.initial_gas_mix, /datum/gas_mixture/turf)
// 		restore.copy_air(GM)
// 		restore.temperature = initial(restore.temperature)
// 		restore.air_update_turf(update = FALSE, remove = FALSE)

/datum/unit_test/proc/test_screenshot(name, icon/icon)
	if (!istype(icon))
		TEST_FAIL("[icon] is not an icon.")
		return

	var/path_prefix = replacetext(replacetext("[type]", "/datum/unit_test/", ""), "/", "_")
	name = replacetext(name, "/", "_")

	var/filename = "code/modules/unit_tests/screenshots/[path_prefix]_[name].png"

	if (fexists(filename))
		var/data_filename = "data/screenshots/[path_prefix]_[name].png"
		fcopy(icon, data_filename)
		log_test("\t[path_prefix]_[name] was found, putting in data/screenshots")
	else
#ifdef CIBUILDING
		// We are runing in real CI, so just pretend it worked and move on
		fcopy(icon, "data/screenshots_new/[path_prefix]_[name].png")

		log_test("\t[path_prefix]_[name] was put in data/screenshots_new")
#else
		// We are probably running in a local build
		fcopy(icon, filename)
		TEST_FAIL("Screenshot for [name] did not exist. One has been created.")
#endif


/// Helper for screenshot tests to take an image of an atom from all directions and insert it into one icon
/datum/unit_test/proc/get_flat_icon_for_all_directions(atom/thing, no_anim = TRUE)
	var/icon/output = icon('icons/effects/effects.dmi', "nothing")

	for (var/direction in GLOB.cardinal)
		var/icon/partial = get_flat_icon(thing, dir = direction, no_anim = no_anim)
		output.Insert(partial, dir = direction)

	return output

/// Logs a test message. Will use GitHub action syntax found at https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions
/datum/unit_test/proc/log_for_test(text, priority, file, line)
	var/map_name = (LEGACY_MAP_DATUM).name

	// Need to escape the text to properly support newlines.
	var/annotation_text = replacetext(text, "%", "%25")
	annotation_text = replacetext(annotation_text, "\n", "%0A")

	log_world("::[priority] file=[file],line=[line],title=[map_name]: [type]::[annotation_text]")

/**
 * Helper to perform a click
 *
 * * clicker: The mob that will be clicking
 * * clicked_on: The atom that will be clicked
 * * passed_params: A list of parameters to pass to the click
 */
/datum/unit_test/proc/click_wrapper(mob/living/clicker, atom/clicked_on, list/passed_params = list("left" = 1, "button" = "left"))
	clicker.next_click = -1
	clicker.next_move = -1
	usr = clicker // bypass check
	clicker.click_on(clicked_on, raw_params = list2params(passed_params))

/datum/unit_test/proc/reset_room()
	var/list/turf/interior = block(get_turf(run_loc_floor_bottom_left), get_turf(run_loc_floor_top_right))
	for(var/turf/T as anything in interior)
		T.empty(/turf/simulated/floor/tiled)

/proc/RunUnitTest(datum/unit_test/test_path, list/test_results)
	if(ispath(test_path, /datum/unit_test/focus_only))
		return

	if(initial(test_path.abstract_type) == test_path)
		return

	var/datum/unit_test/test = new test_path

	GLOB.current_test = test
	var/duration = REALTIMEOFDAY
	var/test_output_desc = "[test_path]"
	var/message = ""

	log_world("::group::[test_path]")

	test.Run()
	if(test.reset_room_after)
		test.reset_room()
	// if(test.priority < TEST_CREATE_AND_DESTROY) //We shouldn't care about restoring atmos after create_and_destroy.
	// 	test.restore_atmos()

	duration = REALTIMEOFDAY - duration
	GLOB.current_test = null
	GLOB.failed_any_test |= !test.succeeded

	var/list/log_entry = list()
	var/list/fail_reasons = test.fail_reasons

	for(var/reasonID in 1 to LAZYLEN(fail_reasons))
		var/text = fail_reasons[reasonID][1]
		var/file = fail_reasons[reasonID][2]
		var/line = fail_reasons[reasonID][3]

		test.log_for_test(text, "error", file, line)

		// Normal log message
		log_entry += "\tFAILURE #[reasonID]: [text] at [file]:[line]"

	if(length(log_entry))
		message = log_entry.Join("\n")
		log_test(message)

	test_output_desc += " [duration / 10]s"
	if(duration > 10)
		GLOB.test_run_times[test_path] = duration
	if (test.succeeded)
		log_world("[TEST_OUTPUT_GREEN("PASS")] [test_output_desc]")

	log_world("::endgroup::")

	if (!test.succeeded)
		log_world("::error::[TEST_OUTPUT_RED("FAIL")] [test_output_desc]")

	var/final_status = (test.succeeded ? UNIT_TEST_PASSED : UNIT_TEST_FAILED)
	test_results[test_path] = list("status" = final_status, "message" = message, "name" = test_path)

	qdel(test)

/// Builds (and returns) a list of atoms that we shouldn't initialize in generic testing, like Create and Destroy.
/// It is appreciated to add the reason why the atom shouldn't be initialized if you add it to this list.
/datum/unit_test/proc/build_list_of_uncreatables()
	RETURN_TYPE(/list)
	var/list/returnable_list = list()
	// The following are just generic, singular types.
	returnable_list = list(
		//Never meant to be created, errors out the ass for mobcode reasons
		/mob/living/carbon,
		//Template type
		/obj/machinery/power/turbine,
		//Singleton
		/mob/dview,
		//This is meant to fail extremely loud every single time it occurs in any environment in any context, and it falsely alarms when this unit test iterates it. Let's not spawn it in.
		/obj/merge_conflict_marker,
		// requires a borg
		/obj/item/reagent_containers/borghypo,
	)

	// Everything that follows is a typesof() check.

	//Say it with me now, type template
	returnable_list += typesof(/obj/map_helper)
	//This turf existing is an error in and of itself
	returnable_list += typesof(/turf/baseturf_skipover)
	returnable_list += typesof(/turf/baseturf_bottom)
	//We have a baseturf limit of 10, adding more than 10 baseturf helpers will kill CI, so here's a future edge case to fix.
	returnable_list += typesof(/obj/effect/baseturf_helper)
	//Sparks can ignite a number of things, causing a fire to burn the floor away. Only you can prevent CI fires
	returnable_list += typesof(/obj/effect/particle_effect/sparks)
	//these can explode and cause the turf to be destroyed at unexpected moments
	returnable_list += typesof(/obj/effect/mine)
	//Asks for a shuttle that may not exist, let's leave it alone
	returnable_list += typesof(/obj/item/pinpointer/shuttle)

	return returnable_list

/proc/RunUnitTests()
	CHECK_TICK

	var/list/tests_to_run = subtypesof(/datum/unit_test)
	var/list/focused_tests = list()
	for (var/_test_to_run in tests_to_run)
		var/datum/unit_test/test_to_run = _test_to_run
		if (initial(test_to_run.focus))
			focused_tests += test_to_run
	if(length(focused_tests))
		tests_to_run = focused_tests

	tim_sort(tests_to_run, GLOBAL_PROC_REF(cmp_unit_test_priority))

	var/list/test_results = list()

	//Hell code, we're bound to end the round somehow so let's stop if from ending while we work
	SSticker.delay_end = TRUE
	for(var/unit_path in tests_to_run)
		CHECK_TICK //We check tick first because the unit test we run last may be so expensive that checking tick will lock up this loop forever
		RunUnitTest(unit_path, test_results)
	SSticker.delay_end = FALSE

	log_world("::group::Expensive Unit Test Times")
	tim_sort(GLOB.test_run_times, cmp = GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	for(var/type, duration in GLOB.test_run_times)
		log_world("[type] took [duration/10]s")
	log_world("::endgroup::")

	var/file_name = "data/unit_tests.json"
	fdel(file_name)
	file(file_name) << json_encode(test_results)

	SSticker.force_ending = TRUE
	//We have to call this manually because del_text can preceed us, and SSticker doesn't fire in the post game
	SSticker.declare_completion()

/datum/map_level/unit_tests
	id = "__UnitTestLevel"
	name = "Unit Tests Zone"
	path = "maps/templates/unit_tests.dmm"
