#ifdef USE_CUSTOM_ERROR_HANDLER

/datum/unit_test/world_error_runs/Run()
	runtime_skip_once = TRUE
	stack_trace("checking world/Error() runs...")
	if(!runtime_trap_triggered)
		Fail("Something is runtiming early in init and preventing world/Error() from working. Go fix it on local with \"dreamseeker -trusted -verbose citadel.dmb\"!")

#endif
