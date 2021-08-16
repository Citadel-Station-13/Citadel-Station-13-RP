/atom/movable
	/// Fluid flow resistance
	var/fluid_flow_resistance = INFINITY

/atom/movable/proc/FluidPush(dir, strength, height)
	if(strength < fluid_flow_resistance)
		return
	if((locate(/obj/structure/table) in loc) && (height < FLUID_DEEP))
		return
	step(src, dir)
