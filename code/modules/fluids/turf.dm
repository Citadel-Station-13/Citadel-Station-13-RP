/turf
	/// See __DEFINES/fluids.dm
	var/fluid_status = FLUID_STATUS_NORMAL
	/// Last cycle of fluid processing
	var/fluid_process_cycle = 0
	/// Marks if we're fluid active - determines if fluid procs are held
	var/fluid_active = FALSE
	/// Current fluid graphic
	var/obj/effect/overlay/fluid/fluid_graphic
	/// Innate fluid depth
	var/fluid_depth_innate = 0
	/// Current fluid depth - this **MUST** be the same as fluid_depth_innate to save memory, and is enforced by an unit test!
	var/fluid_depth = 0
	/// The fluid excited group we're part of, if any
	var/datum/fluid_group/fluid_group

	CanFluidPass = FLUID_PASS_PROC

/**
 * Dumps fluids onto the turf below
 */
/turf/proc/DumpFluidsBelow(ratio = 0.5)
	var/turf/T = GetBelow(src)
	if(!T)
		return
	T.MergeFluids(RemoveFluidRatio(0.5))

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
				SSfluids.StartActProcessing(src, TRUE)

/turf/RemoveFluid(units)
	if(!fluid_active)
		return
	. = new /datum/reagents(FLUID_MAX_VOLUME)
	reagents.trans_to(., units)
	FluidGarbageCollect()

/turf/RemoveFluidRatio(ratio)
	if(!fluid_active)
		return
	. = new /datum/reagents(FLUID_MAX_VOLUME)
	reagents.trans_to(., reagents.total_volume * ratio)
	FluidGarbageCollect()

/turf/AddFluid(reagent, amount)
	MakeFluidSystem()
	reagents.add_reagent(reagent, amount)
	FluidGarbageCollect()

/turf/GetFluids()
	return reagents

/turf/MergeFluids(datum/reagents/reagents)
	MakeFluidSystem()
	reagents.trans_to(src.reagents, reagents.maximum_volume)
	FluidGarbageCollect()

/**
 * Sets our fluid_status to a new value
 */
/turf/proc/SetFluidStatus(status)
	fluid_status = status
	ReconsiderFluids()

/**
 * Ensures our fluid system is set up
 */
/turf/proc/MakeFluidSystem()
	if(fluid_active)
		return
	fluid_active = TRUE
	create_reagents(FLUID_MAX_VOLUME)
	UpdateFluidGraphic()

/**
 * Tears down our fluids, deleting it all
 */
/turf/proc/RemoveFluidSystem()
	if(!fluid_active)
		return
	if(fluid_group)
		fluid_group.remove(src)
	fluid_active = FALSE
	qdel(reagents)
	vis_contents -= fluid_graphic

/**
 * Garbage collects our fluids, removing it if we don't have enough
 */
/turf/proc/FluidGarbageCollect()
	if(!reagents)
		return
	if(reagents.total_volume < FLUID_QDEL_POINT)
		RemoveFluidSystem()

/**
 * Fluid processing: Equalizes with fluid turfs around ourselves.
 */
/turf/proc/FluidShare()

/**
 * Reconsiders if we need to become an active fluid turf.
 */
/turf/proc/ReconsiderFluids()


/**
 * Updates our fluid graphic
 */
/turf/proc/UpdateFluidGraphic()
	if(!fluid_active)
		return
	if(fluid_graphic)
		vis_contents -= fluid_graphic
	fluid_graphic = SSfluids.GetGraphic(reagents)
	if(fluid_graphic)
		vis_contents += fluid_graphic

/**
 * Sets our innate depth
 */
/turf/proc/SetInnateFluidDepth(newdepth)
	var/diff = newdepth - fluid_depth_innate
	fluid_depth += diff
	ReconsiderFluids()

/**
 * Completely recalculates our fluid depth
 * Useful for when someone fucks up royally
 */
/turf/proc/ResetFluidDepth()
	fluid_depth = fluid_depth_innate
	for(var/atom/movable/AM in contents)
		fluid_depth += AM.fluid_depth
