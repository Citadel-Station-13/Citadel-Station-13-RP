GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/simulated/floor/custom_smooth()
	return		// we'll update_icon().

/turf/simulated/floor/calculate_adjacencies()
	return NONE

GLOBAL_LIST_EMPTY(turf_edge_cache)

var/list/flooring_cache = list()

/turf/simulated/floor/update_icon()
	cut_overlays()
	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.base_icon_state
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		if(flooring.flags & TURF_HAS_EDGES)
			var/has_border = 0
			for(var/step_dir in GLOB.cardinal)
				var/turf/simulated/floor/T = get_step(src, step_dir)
				if(!flooring.test_link(src, T))
					has_border |= step_dir
					add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-edge-[step_dir]", "[flooring.base_icon_state]_edges", step_dir))

			//Note: Doesn't actually check northeast, this is bitmath to check if we're edge'd (aka not smoothed) to NORTH and EAST
			//North = 0001, East = 0100, Northeast = 0101, so (North|East) == Northeast, therefore (North|East)&Northeast == Northeast
			if((has_border & NORTHEAST) == NORTHEAST)
				add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-edge-[NORTHEAST]", "[flooring.base_icon_state]_edges", NORTHEAST))
			if((has_border & NORTHWEST) == NORTHWEST)
				add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-edge-[NORTHWEST]", "[flooring.base_icon_state]_edges", NORTHWEST))
			if((has_border & SOUTHEAST) == SOUTHEAST)
				add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-edge-[SOUTHEAST]", "[flooring.base_icon_state]_edges", SOUTHEAST))
			if((has_border & SOUTHWEST) == SOUTHWEST)
				add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-edge-[SOUTHWEST]", "[flooring.base_icon_state]_edges", SOUTHWEST))

			if(flooring.flags & TURF_HAS_CORNERS)
				//Like above but checking for NO similar bits rather than both similar bits.
				if((has_border & NORTHEAST) == 0) //Are connected NORTH and EAST
					var/turf/simulated/floor/T = get_step(src, NORTHEAST)
					if(!flooring.test_link(src, T)) //But not NORTHEAST
						add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-corner-[NORTHEAST]", "[flooring.base_icon_state]_corners", NORTHEAST))
				if((has_border & NORTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, NORTHWEST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-corner-[NORTHWEST]", "[flooring.base_icon_state]_corners", NORTHWEST))
				if((has_border & SOUTHEAST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-corner-[SOUTHEAST]", "[flooring.base_icon_state]_corners", SOUTHEAST))
				if((has_border & SOUTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-corner-[SOUTHWEST]", "[flooring.base_icon_state]_corners", SOUTHWEST))
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-broken-[broken]","broken[broken]"))
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(flooring.get_flooring_overlay("[flooring.base_icon_state]-burned-[burnt]","burned[burnt]"))
	else
		// no flooring - just handle plating stuff
		if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
			icon = 'icons/turf/flooring/plating.dmi'
			icon_state = "dmg[rand(1,4)]"

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	// Show 'ceilingless' overlay.
	var/turf/above = Above(src)
	if(isopenturf(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(GLOB.no_ceiling_image)

	update_border_spillover()	// sigh

	// ..() has to be last to prevent trampling managed overlays
	. = ..()

/**
 * welcome to the less modular but more sensical and efficient way to do icon edges
 * instead of having every turf check, we only have turfs tha can spill onto others check, and apply their edges to other turfs
 * now only on /turf/simulated/floor, because let's be honest,
 * 1. no one used borders on walls
 * 2. if you want a floor to spill onto a wall, go ahead and reconsider your life/design choices
 * 3. i can think of a reason but honestly performance is better than some niche case of floor resin creeping onto walls or something, use objs for that.
 */
/turf/simulated/floor/proc/update_border_spillover()
	if(!edge_blending_priority)
		return		// not us
	for(var/d in GLOB.cardinal)
		var/turf/simulated/F = get_step(src, d)
		// todo: BETTER ICON SYSTEM BUT HEY I GUESS WE'LL CHECK DENSITY
		if(!istype(F) || F.density)
			continue
		// check that their priority is lower than ours, and we don't have the same icon state
		if(F.edge_blending_priority < edge_blending_priority && icon_state != F.icon_state)
			var/key = "[icon_state || edge_icon_state]-[d]"
			add_overlay(GLOB.turf_edge_cache[key] || generate_border_cache_for(icon_state || edge_icon_state, d))

// todo: better system
/proc/generate_border_cache_for(state, dir)
	// make it
	var/static/list/states = icon_states('icons/turf/outdoors_edge.dmi')
	var/actual
	if(state in states)
		actual = state
	else if("[state]-edge" in states)
		actual = "[state]-edge"
	var/image/I = image('icons/turf/outdoors_edge.dmi', icon_state = actual, layer = ABOVE_TURF_LAYER, dir = turn(dir, 180))
	I.plane = FLOAT_PLANE
	switch(dir)
		if(NORTH)
			I.pixel_y = 32
		if(SOUTH)
			I.pixel_y = -32
		if(EAST)
			I.pixel_x = 32
		if(WEST)
			I.pixel_x = -32
	GLOB.turf_edge_cache["[state]-[dir]"] = I
	return I

// wip - turf icon stuff needs to be refactored

//Tests whether this flooring will smooth with the specified turf
//You can override this if you want a flooring to have super special snowflake smoothing behaviour
/singleton/flooring/proc/test_link(var/turf/origin, var/turf/T, var/countercheck = FALSE)

	var/is_linked = FALSE
	if (countercheck)
		//If this is a countercheck, we skip all of the above, start off with true, and go straight to the atom lists
		is_linked = TRUE
	else if(T)

		//If it's a wall, use the wall_smooth setting
		if(istype(T, /turf/simulated/wall))
			if(wall_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If it's space or openspace, use the space_smooth setting
		else if(isspaceturf(T) || isopenturf(T))
			if(space_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If we get here then its a normal floor
		else if (istype(T, /turf/simulated/floor))
			var/turf/simulated/floor/t = T
			//If the floor is the same as us,then we're linked,
			if (t.flooring?.type == type)
				is_linked = TRUE
				/*
					But there's a caveat. To make atom black/whitelists work correctly, we also need to check that
					they smooth with us. Ill call this counterchecking for simplicity.
					This is needed to make both turfs have the correct borders

					To prevent infinite loops we have a countercheck var, which we'll set true
				*/

				if (smooth_movable_atom != SMOOTH_NONE)
					//We do the countercheck, passing countercheck as true
					is_linked = test_link(T, origin, countercheck = TRUE)

			else if (floor_smooth == SMOOTH_ALL)
				is_linked = TRUE

			else if (floor_smooth != SMOOTH_NONE)
				//If we get here it must be using a whitelist or blacklist
				if (floor_smooth == SMOOTH_WHITELIST)
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = TRUE
							break
				else if(floor_smooth == SMOOTH_BLACKLIST)
					is_linked = TRUE //Default to true for the blacklist, then make it false if a match comes up
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = FALSE
							break

	//Alright now we have a preliminary answer about smoothing, however that answer may change with the following
	//Atom lists!
	var/best_priority = -1
	//A white or blacklist entry will only override smoothing if its priority is higher than this
	//And then this value becomes its priority
	if (smooth_movable_atom != SMOOTH_NONE)
		if (smooth_movable_atom == SMOOTH_WHITELIST || smooth_movable_atom == SMOOTH_GREYLIST)
			for (var/list/v in movable_atom_whitelist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				//Priority is the quickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok, now we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						//Typecast it to a movable atom
						//Lets make sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that may runtime if the coder screwed up


						var/match = TRUE
						for (var/d_var in d_vars)
							//For each variable we want to check
							if (AM.vars[d_var] != d_vars[d_var])
								//We get a var of the same name from the atom's vars list.
								//And check if it equals our desired value
								match = FALSE
								break //If any var doesn't match the desired value, then this atom is not a match, move on


						if (match)
							//If we've successfully found an atom which matches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a whitelist, so this match forces is_linked to true
							is_linked = TRUE


		if (smooth_movable_atom == SMOOTH_BLACKLIST || smooth_movable_atom == SMOOTH_GREYLIST)
			//All of this blacklist code is copypasted from above, with only minor name changes
			for (var/list/v in movable_atom_blacklist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				//Priority is the quickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok, now we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						//Typecast it to a movable atom
						//Lets make sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that may runtime if the coder screwed up

						var/match = TRUE
						for (var/d_var in d_vars)
							//For each variable we want to check
							if (AM.vars[d_var] != d_vars[d_var])
								//We get a var of the same name from the atom's vars list.
								//And check if it equals our desired value
								match = FALSE
								break //If any var doesn't match the desired value, then this atom is not a match, move on


						if (match)
							//If we've successfully found an atom which matches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a blacklist, so this match forces is_linked to false
							is_linked = FALSE

	return is_linked

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/base_icon_state, var/icon_dir = 0)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = base_icon_state, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]
