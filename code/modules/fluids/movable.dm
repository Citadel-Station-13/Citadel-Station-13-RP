/atom/movable
	/// Fluid flow resistance
	var/fluid_flow_resistance = INFINITY

/**
 * Fluid act called for processing
 * **An assumption is made that we're on the turf acting on us, for performance reasons.**
 *
 * This isn't on /atom level because only /turfs need it, and in which case, snowflake overrides are beter for performance.
 *
 * @params
 * * reagents - reagents of the turf we're on
 * * entering - if we're initially entering a fluid object
 */
/atom/movable/proc/fluid_act(datum/reagents/reagents, entering)

/atom/movable/proc/FluidPush(dir, strength, height)
	if(strength < fluid_flow_resistance)
		return
	if((locate(/obj/structure/table) in loc) && (height < FLUID_DEEP))
		return
	step(src, dir)
