// todo: atmos_turf_air_thermal_superconduction

// for /turf/proc/air_thermal_superconduction()
// todo: per-test reservations; this really shouldn't run in main unit test reservation!
/datum/unit_test/atmos_turf_air_thermal_superconduction_unsimulated/Run()
	var/turf/test_turf = run_loc_floor_bottom_left.ChangeTurf(/turf/unsimulated/floor)


	test_turf.ChangeTurf(/turf/simulated/floor/plating)

// for /turf/simulated/air_thermal_superconduction()
// todo: per-test reservations; this really shouldn't run in main unit test reservation!
/datum/unit_test/atmos_turf_air_thermal_superconduction_simulated/Run()
	var/turf/test_turf = run_loc_floor_bottom_left.ChangeTurf(/turf/unsimulated/floor)


	test_turf.ChangeTurf(/turf/simulated/floor/plating)

#warn unit tests
