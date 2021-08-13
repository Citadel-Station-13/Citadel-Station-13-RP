/turf
	/// See __DEFINES/fluids.dm
	var/fluid_status = FLUID_STATUS_NORMAL
	/// Last cycle of fluid processing
	var/fluid_process_cycle = 0
	/// Marks if we're fluid active - determines if fluid procs are held
	var/fluid_active = FALSE
	/// Current fluid graphic
	var/obj/effect/overlay/fluid/fluid_graphic

	CanFluidPass = FLUID_PASS_PROC

/**
 * Dumps fluids onto the turf below
 */
/turf/proc/DumpFluidsBelow(ratio = 0.5)
	var/turf/T = GetBelow(src)
	if(!T)
		return
	//

/**
 * Returns if we have fluid
 */
/turf/proc/HasFluid()
	return fluid_active

/turf/Entered(atom/movable/AM)
	. = ..()
	if(fluid_active)
		switch(AM.fluid_processing)
			if(FLUID_PROCESSING_ENTER)
				AM.fluid_act(reagents, TRUE)
			if(FLUID_PROCESSING_SUBSYSTEM)
				AM.fluid_act(reagents, TRUE)
				SSfluids.
