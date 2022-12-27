
/proc/vortex_blast(turf/T)

/proc/vortex_blast_line(turf/center, dir, offset, length)
	if(offset)
		for(var/i in 1 to offset)
			center = get_step(center, dir)
			if(!center)
				return
	for(var/i in 1 to length)
		if(!center)
			break
		vortex_blast(center)
		center = get_step(center, dir)

/proc/vortex_blast_cardinals(turf/center, offset, length)
	if(!offset)
		vortex_blast(center)
		offset = 1
	for(var/i in GLOB.cardinal)
		vortex_blast_line(center, i, offset, length)

/proc/vortex_blast_diagonals(turf/center, offset, length)
	if(!offset)
		vortex_blast(center)
		offset = 1
	for(var/i in GLOB.cornerdirs)
		vortex_blast_line(center, i, offset, length)

/proc/vortex_blast_alldirs(turf/center, offset, length)
	if(!offset)
		vortex_blast(center)
		offset = 1
	for(var/i in GLOB.alldirs)
		vortex_blast_line(center, i, offset, length)

/proc/vortex_blast_ring(turf/center, radius)
	for(var/turf/T as anything in RING_TURF_FROM_CENTER(radius, center))
		vortex_blast(center)

/proc/vortex_blast_square_radius(turf/center, radius)
	for(var/turf/T as anything in RANGE_TURFS(radius, center))
		vortex_blast(center)

/proc/vortex_blast_line_both_dirs(turf/center, dir, offset, length)
	if(!offset)
		vortex_blast(center)
		offset = 1
	vortex_blast_line(center, dir, offset, length)
	vortex_blast_line(center, turn(dir, 180), offset, length)

#warn instance vars on all
