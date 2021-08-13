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
