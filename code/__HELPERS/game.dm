
/proc/dopage(src, target)
	var/href_list
	var/href
	href_list = params2list("src=\ref[src]&[target]=1")
	href = "src=\ref[src];[target]=1"
	src:temphtml = null
	src:Topic(href, href_list)
	return null

/proc/is_on_same_plane_or_station(z1, z2)
	if (z1 == z2)
		return TRUE
	if ((z1 in GLOB.using_map.station_levels) &&	(z2 in GLOB.using_map.station_levels))
		return TRUE
	return FALSE

/proc/max_default_z_level()
	var/max_z = 0
	for(var/z in GLOB.using_map.station_levels)
		max_z = max(z, max_z)
	for(var/z in GLOB.using_map.admin_levels)
		max_z = max(z, max_z)
	for(var/z in GLOB.using_map.player_levels)
		max_z = max(z, max_z)
	return max_z

/proc/get_area(atom/A)
	RETURN_TYPE(/area)
	if (isarea(A))
		return A
	var/turf/T = get_turf(A)
	return T ? T.loc : null

/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/A = isarea(X) ? X : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name

/proc/get_area_master(const/O)
	var/area/A = get_area(O)
	if (isarea(A))
		return A


/**
 * Checks if any living humans are in a given area.
 */
/proc/area_is_occupied(area/myarea)
	// Testing suggests looping over human_mob_list is quicker than looping over area contents
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.stat >= DEAD) //Conditions for exclusion here, like if disconnected people start blocking it.
			continue
		var/area/A = get_area(H)
		if(A == myarea) //The loc of a turf is the area it is in.
			return 1
	return 0

/// Like view but bypasses luminosity check.
/proc/hear(range, atom/source)

	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

/proc/get_hearers_in_view(R, atom/source)
	var/turf/T = get_turf(source)
	. = list()
	if(!T)
		return
	var/list/processing = list()
	if(R == 0)
		processing += T.contents
	else
		var/lum = T.luminosity
		T.luminosity = 6
		var/list/cached_view = view(R, T)
		for(var/mob/M in cached_view)
			processing += M
		for(var/obj/O in cached_view)
			processing += O
		T.luminosity = lum
	var/i = 0
	while(i < length(processing))
		var/atom/A = processing[++i]
		if(A.atom_flags & ATOM_HEAR)
			. += A
			SEND_SIGNAL(A, COMSIG_ATOM_HEARER_IN_VIEW, processing, .)
		processing += A.contents

/proc/isStationLevel(level)
	return level in GLOB.using_map.station_levels

/proc/isNotStationLevel(level)
	return !isStationLevel(level)

/proc/isPlayerLevel(level)
	return level in GLOB.using_map.player_levels

/proc/isAdminLevel(level)
	return level in GLOB.using_map.admin_levels

/proc/isNotAdminLevel(level)
	return !isAdminLevel(level)

/proc/circlerange(center = usr, radius = 3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center = usr, radius = 3)

	var/turf/centerturf = get_turf(center)
	var/list/atoms = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

/**
 * Alternative to range (ONLY processes turfs and thus less intensive).
 */
/proc/trange(rad = 0, turf/centre = null)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

/proc/get_dist_euclidian(atom/Loc1, atom/Loc2)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/circlerangeturfs(center = usr, radius = 3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs

/**
 * Is there even a diffrence between this proc and circlerangeturfs()?
 */
/proc/circleviewturfs(center = usr, radius = 3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs



//var/debug_mob = 0

/**
 * Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
 * It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
 * being unable to hear people due to being in a box within a bag.
 */
/proc/recursive_content_check(atom/O, list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_mobs = 1, include_objects = 1, ignore_show_messages = 0)

	if(!recursion_limit)
		return L

	for(var/I in O.contents)

		if(ismob(I))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
				if(include_mobs)
					if(client_check)
						var/mob/M = I
						if(M.client)
							L |= M
					else
						L |= I

		else if(istype(I,/obj/))
			var/obj/check_obj = I
			if(ignore_show_messages || check_obj.show_messages)
				if(!sight_check || isInSight(I, O))
					L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
					if(include_objects)
						L |= I

	return L

/**
 * Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.
 */
/proc/get_mobs_or_objects_in_view(R, atom/source, include_mobs = 1, include_objects = 1)

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/I in range)
		if(ismob(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear += M
		else if(istype(I,/obj/))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			var/obj/O = I
			if(O.show_messages && include_objects)
				hear += I

	return hear


/proc/get_mobs_in_radio_ranges(list/obj/item/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/radio/R in radios)
		if(R)
			//Cyborg checks. Receiving message uses a bit of cyborg's charge.
			var/obj/item/radio/borg/BR = R
			if(istype(BR) && BR.myborg)
				var/mob/living/silicon/robot/borg = BR.myborg
				var/datum/robot_component/CO = borg.get_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!borg.is_component_functioning("radio") || !borg.cell_use_power(CO.active_usage))
					continue //No power.

			var/turf/speaker = get_turf(R)
			if(speaker)
				for(var/turf/T in hear(R.canhear_range,speaker))
					speaker_coverage[T] = T


	// Try to find all the players who can hear the message
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/M = GLOB.player_list[i]
		if(M)
			var/turf/ear = get_turf(M)
			if(ear)
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (istype(M, /mob/observer/dead) && M.is_preference_enabled(/datum/client_preference/ghost_radio)))
					. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

/**
 * Uses dview to quickly return mobs and objects in view,
 * then adds additional mobs or objects if they are in range 'smartly',
 * based on their presence in lists of players or registered objects
 * Type: 1-audio, 2-visual, 0-neither
 */
/proc/get_mobs_and_objs_in_view_fast(turf/T, range, type = 1, remote_ghosts = TRUE)
	var/list/mobs = list()
	var/list/objs = list()

	var/list/hear = list()
	DVIEW(hear, range, T, INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/atom/movable/AM in hear)
		if(ismob(AM))
			mobs += AM
			hearturfs += get_turf(AM)
		else if(isobj(AM))
			objs += AM
			hearturfs += get_turf(AM)

	// A list of every mob with a client.
	for(var/mob in GLOB.player_list)
		if(!ismob(mob))
			GLOB.player_list -= mob
			crash_with("There is a null or non-mob reference inside GLOB.player_list ([mob]).")
			continue
		if(get_turf(mob) in hearturfs)
			mobs |= mob
			continue

		var/mob/M = mob
		if(M && M.stat == DEAD && remote_ghosts && !M.forbid_seeing_deadchat)
			switch(type)
				// Audio messages use ghost_ears.
				if(1)
					if(M.is_preference_enabled(/datum/client_preference/ghost_ears))
						mobs |= M
				// Visual messages use ghost_sight.
				if(2)
					if(M.is_preference_enabled(/datum/client_preference/ghost_sight))
						mobs |= M

	// For objects below the top level who still want to hear.
	for(var/obj/O in global.listening_objects)
		if(get_turf(O) in hearturfs)
			objs |= O

	return list("mobs" = mobs, "objs" = objs)

/proc/inLineOfSight(X1, Y1, X2, Y2, Z=1, PX1=16.5, PY1=16.5, PX2=16.5, PY2=16.5)
	var/turf/T
	if(X1 == X2)
		if(Y1 == Y2)
			return TRUE //Light cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1 += s
			while(Y1 != Y2)
				T = locate(X1, Y1, Z)
				if(T.opacity)
					return FALSE
				Y1 += s
	else
		var/m = (32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b = (Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIGN(X2 - X1)
		var/signY = SIGN(Y2 - Y1)
		if(X1 < X2)
			b += m
		while(X1 != X2 || Y1 != Y2)
			if(round(m*X1+b-Y1))
				Y1 += signY //Line exits tile vertically
			else
				X1 += signX //Line exits tile horizontally
			T=locate(X1, Y1, Z)
			if(T.opacity)
				return FALSE
	return TRUE

/proc/isInSight(atom/A, atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return FALSE

	if(inLineOfSight(Aturf.x, Aturf.y, Bturf.x, Bturf.y, Aturf.z))
		return TRUE

	else
		return FALSE

/**
 * Returns the position of a step from start away from finish, in one of the cardinal directions.
 */
/proc/get_cardinal_step_away(atom/start, atom/finish)
	// Returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	// Slope is above 1:1 (move horizontally in a tie)
	if(abs(dy) > abs (dx))
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/get_mob_by_key(key)
	return GLOB.directory[ckey(key)]

/**
 * Will return a list of active candidates.
 * It increases the buffer 5 times until it finds a candidate which is active within the buffer.
 */
/proc/get_active_candidates(buffer = 1)

	/// List of candidate KEYS to assume control of the new larva ~Carn
	var/list/candidates = list()
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in GLOB.player_list)
			// The most active players are more likely to become an alien.
			if(((G.client.inactivity/10)/60) <= buffer + i)
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		i++
	return candidates

/**
 * Same as above but for alien candidates.
 */
/proc/get_alien_candidates()

	/// List of candidate KEYS to assume control of the new larva ~Carn
	var/list/candidates = list()
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in GLOB.player_list)
			if(G.client.prefs.be_special & BE_ALIEN)
				// The most active players are more likely to become an alien.
				if(((G.client.inactivity/10)/60) <= ALIEN_SELECT_AFK_BUFFER + i)
					if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
						candidates += G.key
		i++
	return candidates

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))	O = new /atom/movable/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/proc/Show2Group4Delay(obj/O, list/group, delay=0)
	if(!isobj(O))	return
	if(!group)	group = GLOB.clients
	for(var/client/C in group)
		C.screen += O
	if(delay)
		spawn(delay)
			for(var/client/C in group)
				C.screen -= O

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(src_x, src_y, rotation, angle, power)

	// returns the destination (Vx,y) that a projectile shot at [src_x], [src_y], with an angle of [angle],
	// rotated at [rotation] and with the power of [power]
	// Thanks to VistaPOWA for this function

	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = 2* power_y / 10 //10 = g

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa,6,8))

/proc/GetHexColors(const/hexa)
	return list(
		GetRedPart(hexa),
		GetGreenPart(hexa),
		GetBluePart(hexa)
	)

/proc/MixColors(const/list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/greens = list()
	var/list/weights = list()

	for (var/i = 0, ++i <= colors.len)
		reds.Add(GetRedPart(colors[i]))
		blues.Add(GetBluePart(colors[i]))
		greens.Add(GetGreenPart(colors[i]))
		weights.Add(1)

	var/r = mixOneColor(weights, reds)
	var/g = mixOneColor(weights, greens)
	var/b = mixOneColor(weights, blues)
	return rgb(r,g,b)

/proc/mixOneColor(list/weight, list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	// Until someone writes a formal proof for this algorithm, let's keep this in.
	// if(mixedcolor<0x00 || mixedcolor>0xFF)
	// 	return 0
	// That's not the kind of operation we are running here, NERD.
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
 * Gets the highest and lowest pressures from the tiles in cardinal directions
 * around us, then checks the difference.
 */
/proc/getOPressureDifferential(turf/loc)
	var/minp=16777216;
	var/maxp=0;
	for(var/dir in GLOB.cardinal)
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/cp=0
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T,/turf/simulated))
				continue
		if(cp<minp)
			minp = cp
		if(cp>maxp)
			maxp = cp
	return abs(minp - maxp)

/proc/convert_k2c(temp)
	return ((temp - T0C))

/proc/convert_c2k(temp)
	return ((temp + T0C))

/proc/getCardinalAirInfo(turf/loc, list/stats=list("temperature"))
	var/list/temps = new/list(4)
	for(var/dir in GLOB.cardinal)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/list/rstats = new /list(stats.len)
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		else if(istype(T, /turf/simulated))
			rstats = null // Exclude zone (wall, door, etc).
		else if(istype(T, /turf))
			// Should still work.  (/turf/return_air())
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		temps[direction] = rstats
	return temps

/proc/MinutesToTicks(minutes)
	return SecondsToTicks(60 * minutes)

/proc/SecondsToTicks(seconds)
	return seconds * 10

/proc/window_flash(client_or_usr)
	if (!client_or_usr)
		return
	winset(client_or_usr, "mainwindow", "flash=5")

/**
 * Used for the multiz camera console stolen from virgo.
 */
/proc/get_bbox_of_atoms(list/atoms)
	var/list/list_x = list()
	var/list/list_y = list()
	for(var/_a in atoms)
		var/atom/a = _a
		list_x += a.x
		list_y += a.y
	return list(
		min(list_x),
		min(list_y),
		max(list_x),
		max(list_y))

/proc/recursive_mob_check(atom/O, list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_radio = 1)

	// GLOB.debug_mob += O.contents.len
	if(!recursion_limit)
		return L
	for(var/atom/A in O.contents)

		if(ismob(A))
			var/mob/M = A
			if(client_check && !M.client)
				L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
				continue
			if(sight_check && !isInSight(A, O))
				continue
			L |= M
			// log_world("[recursion_limit] = [M] - [get_turf(M)] - ([M.x], [M.y], [M.z])")

		else if(include_radio && istype(A, /obj/item/radio))
			if(sight_check && !isInSight(A, O))
				continue
			L |= A

		if(isobj(A) || ismob(A))
			L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
	return L

/proc/get_mobs_in_view(R, atom/source, include_clientless = FALSE)
	// Returns a list of mobs in range of R from source. Used in radio and say code.

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/atom/A in range)
		if(ismob(A))
			var/mob/M = A
			if(M.client || include_clientless)
				hear += M
			// log_world("Start = [M] - [get_turf(M)] - ([M.x], [M.y], [M.z])")
		else if(istype(A, /obj/item/radio))
			hear += A

		if(isobj(A) || ismob(A))
			hear |= recursive_mob_check(A, hear, 3, 1, 0, 1)

	return hear
