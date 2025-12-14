/proc/clamped_locate(x, y, z)
	return locate(
		clamp(x, 1, world.maxx),
		clamp(y, 1, world.maxy),
		z,
	)


/proc/get_atom_before_turf(var/obj/A)
	while(!(A.loc == get_turf(A)))
		A = A.loc
	return A
