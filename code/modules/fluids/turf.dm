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

/turf/RemoveFluid(units)

/turf/RemoveFluidRatio(ratio)

/turf/AddFluid(reagent, amount)

/turf/GetFluids()

/turf/MergeFluids(datum/reagents/reagents)

/**
 * Ensures our fluid system is set up
 */
/turf/proc/MakeFluid()

/**
 * Tears down our fluids, deleting it all
 */
/turf/proc/RemoveFluid()

/**
 * Garbage collects our fluids, removing it if we don't have enough
 */
/turf/proc/FluidGarbageCollect()
	if(!reagents)
		return
	if(reagents.total_volume < FLUID_GC_POINT)
		RemoveFluid()

/**
 * Fluid processing: Equalizes with fluid turfs around ourselves.
 */
/turf/proc/FluidShare()
