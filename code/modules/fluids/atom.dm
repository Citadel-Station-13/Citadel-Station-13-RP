/atom
	/// Can fluids pass us?
	var/CanFluidPass = FLUID_PASS_YES
	/// Do we process fluid_act?
	var/fluid_processing = FLUID_PROCESSING_NONE

/**
 * Fluid act called for processing
 * **An assumption is made that we're on the turf acting on us, for performance reasons.**
 *
 * @params
 * * reagents - reagents of the turf we're on
 * * entering - if we're initially entering a fluid object
 */
/atom/proc/fluid_act(datum/reagents/reagents, entering)

/**
 * Called to check if fluid can pass us
 */
/atom/proc/CanFluidPass(turf/other)
	switch(CanFluidPass)
		if(FLUID_PASS_DENSITY)
			return !density
		if(FLUID_PASS_ATMOS)
			return CANATMOSPASS(src, other)
	return CanFluidPass == FLUID_PASS_NO? FLUID_PASS_NO : FLUID_PASS_YES

/**
 * Returns the reagents of the fluids we're in
 *
 * WARNING: This does not clone it, this **references** it.
 */
/atom/proc/GetFluids()
	return isturf(loc)? loc.GetFluids() : null

/**
 * Removes a ratio of fluids from ourselves or our location
 *
 * Returns the /datum/reagents removed
 */
/atom/proc/RemoveFluidRatio(ratio)
	return isturf(loc)? loc.RemoveFluidRatio(ratio) : null

/**
 * Removes an amount of units of fluids from ourselves or our location
 *
 * Returns the /datum/reagents removed
 */
/atom/proc/RemoveFluid(units)
	return isturf(loc)? loc.RemoveFluid(units) : null

/**
 * Adds x units of y reagent to ourselves
 */
/atom/proc/AddFluid(reagent, amount)
	return isturf(loc)? loc.AddFluid(reagent, amount)

/**
 * Merges a reagent holder into our fluids.
 * Empties it out.
 */
/atom/proc/MergeFluids(datum/reagents/reagents)
	return isturf(loc)? loc.MergeFluids(reagents)
