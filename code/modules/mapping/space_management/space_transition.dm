//Also sets up the transition IDs and such.
/datum/space_level/proc/set_linkage(new_linkage = traits[ZTRAIT_LINKAGE], defer_update = FALSE, force_update = FALSE)
	neighbours = neighbours || list(TEXT_NORTH, TEXT_SOUTH, TEXT_EAST, TEXT_WEST)
	neighbour_static_ids = list(
		TEXT_NORTH = traits[ZTRAIT_TRANSITION_ID_NORTH],
		TEXT_SOUTH = traits[ZTRAIT_TRANSITION_ID_SOUTH],
		TEXT_EAST = traits[ZTRAIT_TRANSITION_ID_EAST],
		TEXT_WEST = traits[ZTRAIT_TRANSITION_ID_WEST])
	var/selflooping = new_linkage == SELFLOOPING
	var/list/checking = list(
		ZTRAIT_TRANSITION_ID_NORTH = NORTH,
		ZTRAIT_TRANSITION_ID_SOUTH = SOUTH,
		ZTRAIT_TRANSITION_ID_EAST = EAST,
		ZTRAIT_TRANSITION_ID_WEST = WEST
	)
	var/list/affected = list()				//only update transitions we need to to conserve cpu cycles.
	for(var/i in 1 to checking.len)
		var/trait_id = checking[i]
		var/link_id = traits[trait_id]
		if(link_id)
			var/dir = checking[trait_id]
			var/datum/space_level/SL = SSmapping.zlevels_by_id[link_id]
			if(SL)
				var/list/returned = link_dir_to_z(dir, SL, TRUE)
				if(length(returned) || force_update)
					affected += returned
		else if(selflooping)
			var/dir = checking[trait_id]
			var/list/returned = link_dir_to_z(dir, src, TRUE)
			if(length(returned) || force_update)
				affected += returned
	if(!defer_update)
		for(var/i in affected)
			var/list/L = affected[i]
			var/datum/space_level/level = L[1]
			level.update_transitions(L[2])
	return affected

/datum/space_level/proc/update_all_transitions()
	for(var/i in GLOB.cardinals)
		update_transitions(i)

/datum/space_level/proc/link_dir_to_z(dir, datum/space_level/SL, defer_update = FALSE)
	. = list()
	var/turned_dir = turn(dir, 180)
	if(SL.neighbours["[turned_dir]"] != src && SL.neighbour_static_ids["[turned_dir]"] == src)		//support for one way transitions - only set theirs if their side is set to us too.
		SL.neighbours["[turned_dir]"] = src
		if(!defer_update)
			SL.update_transitions(turned_dir)
		. += list(SL, turned_dir)
	if(neighbours["[dir]"] != SL)
		neighbours["[dir]"] = SL
		if(!defer_update)
			update_transitions(dir)
		. += list(src, dir)

/datum/space_level/proc/update_transitions(dir)
	if(!(dir in GLOB.cardinals))
		return
	var/datum/space_level/target = neighbours["[dir]"]
	if(!target)
		return
	var/our_z = z_value
	var/padding = traits[ZTRAIT_TRANSITION_PADDING] || SPACE_TRANSITION_BORDER
	var/target_padding = target.traits[ZTRAIT_TRANSITION_PADDING] || SPACE_TRANSITION_BORDER
	var/destination_z = target.z_value
	var/mirage_dist = traits[ZTRAIT_MIRAGE_DISTANCE]

	var/x_lower_left
	var/x_upper_right
	var/y_lower_left
	var/y_upper_right
	var/x_transition
	var/y_transition
	switch(dir)
		if(NORTH)
			x_lower_left = 1
			x_upper_right = world.maxx
			y_lower_left = world.maxy - padding
			y_upper_right = world.maxy
			x_transition = null
			y_transition = target_padding + 1
		if(SOUTH)
			x_lower_left = 1
			x_upper_right = world.maxx
			y_lower_left = 1
			y_upper_right = padding
			x_transition = null
			y_transition = world.maxy - target_padding - 1
		if(EAST)
			x_lower_left = world.maxx - padding
			x_upper_right = world.maxx
			y_lower_left = 1
			y_upper_right = world.maxy
			x_transition = target_padding + 1
			y_transition = null
		if(WEST)
			x_lower_left = 1
			x_upper_right = padding
			y_lower_left = 1
			y_upper_right = world.maxy
			x_transition = world.maxx - target_padding - 1
			y_transition = null

	LAZYINITLIST(transition_effects["[dir]"])
	LAZYINITLIST(transition_turfs["[dir]"])
	var/list/transit_effects = transition_effects["[dir]"]
	var/list/transit_turfs = transition_turfs["[dir]"]
	QDEL_LIST(transit_effects)
	for(var/i in transit_turfs)
		var/turf/T = i
		qdel(T.GetComponent(/datum/component/mirage_border))
	transit_turfs.Cut()

	var/list/turf/turfs = block(locate(x_lower_left, y_lower_left, our_z), locate(x_upper_right, y_upper_right, our_z))
	for(var/i in turfs)
		var/turf/T = i
		transit_turfs += T
		var/destination_x = x_transition || T.x
		var/destination_y = y_transition || T.y
		switch(traits[ZTRAIT_TRANSITION_MODE])
			if(ZTRANSITION_MODE_STEP_TELEPORTER)
				var/obj/effect/step_trigger/teleporter/transition/ST = new(T)
				ST.zlevel = src
				ST.zdir = dir
				ST.teleport_z = destination_z
				ST.teleport_x = destination_x
				ST.teleport_y = destination_y
				transit_effects += ST
				if(T.x == 1 || T.x == world.maxx || T.y == 1 || T.y == world.maxy)			//always allow the last tile to transit.
					ST.prevent_entomb = FALSE
					ST.catch_uncross = TRUE
			if(ZTRANSITION_MODE_TURF)
				pass()				//not implemented

		if(!traits[ZTRAIT_TRANSITION_NO_MIRAGE])
			var/mirage_dir
			if(T.x == padding)
				mirage_dir |= WEST
			else if(T.x == (world.maxx - padding))
				mirage_dir |= EAST
			if(T.y == padding)
				mirage_dir |= SOUTH
			else if(T.y == (world.maxy - padding))
				mirage_dir |= NORTH
			if(mirage_dir)
				var/turf/destination = locate(destination_x, destination_y, destination_z)
				T.AddComponent(/datum/component/mirage_border, destination, mirage_dir, mirage_dist)

/datum/controller/subsystem/mapping/proc/setup_map_transitions()
	transitions_initialized = TRUE
	var/list/cached_z_list = z_list
	var/list/zlevels_selflooping = list()
	var/list/zlevels_crosslinked = list()
	var/list/zlevels_staticlinked = list()
	for(var/z in 1 to length(cached_z_list))
		var/datum/space_level/zlevel = cached_z_list[z]
		switch(zlevel.traits[ZTRAIT_LINKAGE])
			if(CROSSLINKED)
				zlevels_crosslinked += zlevel
			if(STATIC)
				zlevels_staticlinked += zlevel
			if(SELFLOOPING)
				zlevels_selflooping += zlevel
		zlevel.neighbours = list()
		zlevel.set_linkage(zlevel.traits[ZTRAIT_LINKAGE], TRUE, TRUE)		//force update every zlevel so their selflooping/staticlinking gets set
		//but don't actually have them set up transitions (defer them, we'll do that later.)

	//We don't need the rest of the code until we need random space, for now this only does static trnasitions.
	//INSERT RANDOM TRANSITION SYSTEM HERE

	//make all the zlevels force update.
	for(var/i in 1 to length(cached_z_list))
		var/datum/space_level/zlevel = cached_z_list[i]
		zlevel.update_all_transitions()


/*
/datum/controller/subsystem/mapping/proc/setup_map_transitions() //listamania
	var/list/SLS = list()
	var/list/cached_z_list = z_list
	var/conf_set_len = 0
	for(var/A in cached_z_list)
		var/datum/space_level/D = A
		if (D.linkage == CROSSLINKED)
			SLS.Add(D)
		conf_set_len++
	var/list/point_grid[conf_set_len*2+1][conf_set_len*2+1]
	var/list/grid = list()
	var/datum/space_transition_point/P
	for(var/i = 1, i<=conf_set_len*2+1, i++)
		for(var/j = 1, j<=conf_set_len*2+1, j++)
			P = new/datum/space_transition_point(i,j, point_grid)
			point_grid[i][j] = P
			grid.Add(P)
	for(var/datum/space_transition_point/pnt in grid)
		pnt.set_neigbours(point_grid)
	P = point_grid[conf_set_len+1][conf_set_len+1]
	var/list/possible_points = list()
	var/list/used_points = list()
	grid.Cut()
	while(SLS.len)
		var/datum/space_level/D = pick_n_take(SLS)
		D.x	i = P.x
		D.yi = P.y
		P.spl = D
		possible_points |= P.neigbours
		used_points |= P
		possible_points.Remove(used_points)
		D.set_neigbours(used_points)
		P = pick(possible_points)
		CHECK_TICK

	//Lists below are pre-calculated values arranged in the list in such a way to be easily accessable in the loop by the counter
	//Its either this or madness with lotsa math

	var/list/x_pos_beginning = list(1, 1, world.maxx - TRANSITIONEDGE, 1)  //x values of the lowest-leftest turfs of the respective 4 blocks on each side of zlevel
	var/list/y_pos_beginning = list(world.maxy - TRANSITIONEDGE, 1, 1 + TRANSITIONEDGE, 1 + TRANSITIONEDGE)  //y values respectively
	var/list/x_pos_ending = list(world.maxx, world.maxx, world.maxx, 1 + TRANSITIONEDGE)	//x values of the highest-rightest turfs of the respective 4 blocks on each side of zlevel
	var/list/y_pos_ending = list(world.maxy, 1 + TRANSITIONEDGE, world.maxy - TRANSITIONEDGE, world.maxy - TRANSITIONEDGE)	//y values respectively
	var/list/x_pos_transition = list(1, 1, TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 1)		//values of x for the transition from respective blocks on the side of zlevel, 1 is being translated into turfs respective x value later in the code
	var/list/y_pos_transition = list(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 1, 1, 1)		//values of y for the transition from respective blocks on the side of zlevel, 1 is being translated into turfs respective y value later in the code

	for(var/I in cached_z_list)
		var/datum/space_level/D = I
		if(!D.neigbours.len)
			continue
		var/zlevelnumber = D.z_value
		for(var/side in 1 to 4)
			var/turf/beginning = locate(x_pos_beginning[side], y_pos_beginning[side], zlevelnumber)
			var/turf/ending = locate(x_pos_ending[side], y_pos_ending[side], zlevelnumber)
			var/list/turfblock = block(beginning, ending)
			var/dirside = 2**(side-1)
			var/zdestination = zlevelnumber
			if(D.neigbours["[dirside]"] && D.neigbours["[dirside]"] != D)
				D = D.neigbours["[dirside]"]
				zdestination = D.z_value
			else
				dirside = turn(dirside, 180)
				while(D.neigbours["[dirside]"] && D.neigbours["[dirside]"] != D)
					D = D.neigbours["[dirside]"]
				zdestination = D.z_value
			D = I
			for(var/turf/space/S in turfblock)
				S.destination_x = x_pos_transition[side] == 1 ? S.x : x_pos_transition[side]
				S.destination_y = y_pos_transition[side] == 1 ? S.y : y_pos_transition[side]
				S.destination_z = zdestination

				// Mirage border code
				var/mirage_dir
				if(S.x == 1 + TRANSITIONEDGE)
					mirage_dir |= WEST
				else if(S.x == world.maxx - TRANSITIONEDGE)
					mirage_dir |= EAST
				if(S.y == 1 + TRANSITIONEDGE)
					mirage_dir |= SOUTH
				else if(S.y == world.maxy - TRANSITIONEDGE)
					mirage_dir |= NORTH
				if(!mirage_dir)
					continue

				var/turf/place = locate(S.destination_x, S.destination_y, S.destination_z)
				S.AddComponent(/datum/component/mirage_border, place, mirage_dir)

/datum/space_level/proc/set_neigbours(list/L)
	for(var/datum/space_transition_point/P in L)
		if(P.x == xi)
			if(P.y == yi+1)
				neigbours[TEXT_NORTH] = P.spl
				P.spl.neigbours[TEXT_SOUTH] = src
			else if(P.y == yi-1)
				neigbours[TEXT_SOUTH] = P.spl
				P.spl.neigbours[TEXT_NORTH] = src
		else if(P.y == yi)
			if(P.x == xi+1)
				neigbours[TEXT_EAST] = P.spl
				P.spl.neigbours[TEXT_WEST] = src
			else if(P.x == xi-1)
				neigbours[TEXT_WEST] = P.spl
				P.spl.neigbours[TEXT_EAST] = src

/datum/space_transition_point          //this is explicitly utilitarian datum type made specially for the space map generation and are absolutely unusable for anything else
	var/list/neigbours = list()
	var/x
	var/y
	var/datum/space_level/spl

/datum/space_transition_point/New(nx, ny, list/point_grid)
	if(!point_grid)
		qdel(src)
		return
	var/list/L = point_grid[1]
	if(nx > point_grid.len || ny > L.len)
		qdel(src)
		return
	x = nx
	y = ny
	if(point_grid[x][y])
		return
	point_grid[x][y] = src

/datum/space_transition_point/proc/set_neigbours(list/grid)
	var/max_X = grid.len
	var/list/max_Y = grid[1]
	max_Y = max_Y.len
	neigbours.Cut()
	if(x+1 <= max_X)
		neigbours |= grid[x+1][y]
	if(x-1 >= 1)
		neigbours |= grid[x-1][y]
	if(y+1 <= max_Y)
		neigbours |= grid[x][y+1]
	if(y-1 >= 1)
		neigbours |= grid[x][y-1]


*/

/turf/unsimulated/ztransition
	density = FALSE
	plane = TRANSITION_PLANE
	var/destination_x
	var/destination_y
	var/destination_z
	var/turf/target

/turf/unsimulated/ztransition/Entered(atom/movable/AM)
	var/turf/T = locate(destination_x, destination_y, destination_z)
	if(T)
		. = ..()
		AM.forceMove(T)
	else
		return ..()

/turf/unsimulated/ztransition/proc/link_to_turf(turf/other)
	if(!other)
		return
	appearance = other
	vis_contents = list(other)
	target = other
	destination_x = other.x
	destination_y = other.y
	destination_z = other.z
