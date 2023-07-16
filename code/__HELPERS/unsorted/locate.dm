/proc/clamped_locate(x, y, z)
	return locate(
		clamp(x, 1, world.maxx),
		clamp(y, 1, world.maxy),
		z,
	)
