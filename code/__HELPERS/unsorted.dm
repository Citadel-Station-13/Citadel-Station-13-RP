
/**
 *! A large number of misc global procs.
 */

/// Checks if all high bits in req_mask are set in bitfield.
#define BIT_TEST_ALL(bitfield, req_mask) ((~(bitfield) & (req_mask)) == 0)

/// Inverts the colour of an HTML string.
/proc/invertHTML(HTMLstring)
	if (!(istext(HTMLstring)))
		CRASH("Given non-text argument!")
	else if(length(HTMLstring) != 7)
		CRASH("Given non-HTML argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	textr = num2hex(255 - r)
	textg = num2hex(255 - g)
	textb = num2hex(255 - b)
	if (length(textr) < 2)
		textr = text("0[]", textr)
	if (length(textg) < 2)
		textr = text("0[]", textg)
	if (length(textb) < 2)
		textr = text("0[]", textb)
	return text("#[][][]", textr, textg, textb)

/// Calculate the angle between two points and the west|east coordinate.
/proc/Get_Angle(atom/movable/start, atom/movable/end) //For beams.
	if(!start || !end)
		return 0
	var/dy
	var/dx
	dy=(32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	dx=(32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/**
 * Returns location.  Returns null if no location was found.
 *
 *! Variables:
 *? location
 * * location where the teleport begins.
 *? target
 *  * target that will teleport.
 *? distance
 *  * distance to go.
 *? density
 *  * density checking 0/1(TRUE/FALSE).
 *? errorx
 *  * Random error in tile placement x.
 *? errory
 *  * Random error in tile placement y.
 *? eoffsetx
 *  * Random offset in tile placement x.
 *? eoffsety
 *  * Random offset in tile placement y.
 *
 *! Long-form explaination:
 * Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
 * Random error in tile placement x, error in tile placement y, and block offset.
 * Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
 * Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
 * Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
 */
/proc/get_teleport_loc(turf/location, mob/target, distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)

	// Generic location finding variable.
	var/dirx = 0
	var/diry = 0

	// Generic counter for offset location.
	var/xoffset = 0
	var/yoffset = 0

	//Generic placing for point A in box. The lower left.
	var/b1xerror = 0
	var/b1yerror = 0

	//Generic placing for point B in box. The upper right.
	var/b2xerror = 0
	var/b2yerror = 0

	//Error should never be negative.
	errorx = abs(errorx)
	errory = abs(errory)

	//Used for diagonal boxes.
	//var/errorxy = round((errorx+errory)/2)

	// This can be done through equations but switch is the simpler method. And works fast to boot.
	switch(target.dir)
	// Directs on what values need modifying.
		if(1) // North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2) // South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4) // East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8) // West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	// If there is a destination.
	if(destination)
		// If errorx or y were specified.
		if(errorx||errory)
			// To add turfs to list.
			var/destination_list[] = list()
			//destination_list = new()
			/**
			 * This will draw a block around the target turf, given what the error is.
			 * Specifying the values above will basically draw a different sort of block.
			 * If the values are the same, it will be a square. If they are different, it will be a rectengle.
			 * In either case, it will center based on offset. Offset is position from center.
			 * Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			 * the offset should remain positioned in relation to destination.
			 */

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			// Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density&&(T.density||T.contains_dense_objects()))
					// If density was specified.
					continue
				if(T.x>world.maxx || T.x<1)
					// Don't want them to teleport off the map.
					continue
				if(T.y>world.maxy || T.y<1)
					continue
				destination_list += T
			if(destination_list.len)
				destination = pick(destination_list)
			else
				return

		else//Same deal here.
			if(density&&(destination.density||destination.contains_dense_objects()))
				return
			if(destination.x>world.maxx || destination.x<1)
				return
			if(destination.y>world.maxy || destination.y<1)
				return
	else
		return

	return destination


/proc/LinkBlocked(turf/A, turf/B)
	if(A == null || B == null)
		return TRUE
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)

	// Diagonal
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlocked(A,iStep) && !LinkBlocked(iStep,B))
			return FALSE

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlocked(A,pStep) && !LinkBlocked(pStep,B))
			return FALSE
		return TRUE

	if(DirBlocked(A,adir))
		return TRUE
	if(DirBlocked(B,rdir))
		return TRUE
	return FALSE


/proc/DirBlocked(turf/loc, dir)
	for(var/obj/structure/window/D in loc)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return TRUE
		if(D.dir == dir)
			return TRUE

	for(var/obj/machinery/door/D in loc)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))
				return TRUE
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))
				return TRUE
		else
			return TRUE // It's a real, air blocking door.
	return FALSE

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return TRUE
	return FALSE

/proc/sign(x)
	return x!=0?x/abs(x):0

/// Ultra-Fast Bresenham Line-Drawing Algorithm.
/proc/getline(atom/M,atom/N)
	/// Starting x coordinate.
	var/px = M.x
	/// Starting y coordinate.
	var/py = M.y

	var/line[] = list(locate(px,py,M.z))
	/// X distance.
	var/dx = N.x-px
	/// Y distance.
	var/dy = N.y-py
	/// Absolute value of x distance.
	var/dxabs = abs(dx)
	/// Absolute value of y distance.
	var/dyabs = abs(dy)
	///Sign of x distance (+ or -).
	var/sdx = sign(dx)
	///Sign of y distance (+ or -).
	var/sdy = sign(dy)
	/// Counters for steps taken, setting to distance/2.
	var/x = (dxabs >> 1)
	/// Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/y = (dyabs >> 1)
	/// Generic integer for counting.
	var/j

	//? X distance is greater than Y distance.
	if(dxabs >= dyabs)
		//? It'll take dxabs steps to get there.
		for(j=0;j<dxabs;j++)
			y += dyabs
			//? Every dyabs steps, step once in Y direction.
			if(y >= dxabs)
				y  -= dxabs
				py += sdy
			//? Step on in X direction.
			px += sdx
			//? Add the turf to the list.
			line += locate(px, py, M.z)

	//? X distance is less than Y distance.
	else
		//? It'll take dyabs steps to get there.
		for(j=0;j<dyabs;j++)
			x += dxabs
			//? Every dxabs steps, step once in X direction.
			if(x >= dyabs)
				x -= dyabs
				px += sdx
			//? Step on in Y direction.
			py += sdy
			//? Add the turf to the list.
			line += locate(px, py, M.z)
	return line

#define LOCATE_COORDS(X, Y, Z) locate(clamp(X, 1, world.maxx), clamp(Y, 1, world.maxy), Z)
// /Uses a fast Bresenham rasterization algorithm to return the turfs in a thin circle.
/proc/getcircle(turf/center, var/radius)
	if(!radius) return list(center)

	var/x = 0
	var/y = radius
	var/p = 3 - 2 * radius

	. = list()
	while(y >= x) // only formulate 1/8 of circle

		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper right
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper right right
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower right
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower right right

		if(p < 0)
			p += 4*x++ + 6;
		else
			p += 4*(x++ - y--) + 10;

#undef LOCATE_COORDS

/// Returns whether or not a player is a guest using their ckey as an input.
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return FALSE

	var/i = 7, ch, len = length(key)

	if(copytext(key, 7, 8) == "W") //webclient
		i++

	for (, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0
	return 1

/// Ensure the frequency is within bounds of what it should be sending/recieving at.
/proc/sanitize_frequency(frequency, low = PUBLIC_LOW_FREQ, high = PUBLIC_HIGH_FREQ)
	frequency = round(frequency)
	frequency = max(low, frequency)
	frequency = min(high, frequency)
	// Ensure the last digit is an odd number.
	if ((frequency % 2) == 0)
		frequency += 1
	return frequency

/// Turns 1479 into 147.9.
/proc/format_frequency(frequency)
	return "[round(frequency / 10)].[frequency % 10]"

/// Opposite of format, returns as a number.
/proc/unformat_frequency(frequency)
	frequency = text2num(frequency)
	return frequency * 10




/// Picks a string of symbols to display as the law number for hacked or ion laws.
/proc/ionnum()
	return "[pick("1","2","3","4","5","6","7","8","9","0")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

/// When an AI is activated, it can choose from a list of non-slaved borgs to have as a slave.
/proc/freeborg()
	var/select = null
	var/list/borgs = list()
	for (var/mob/living/silicon/robot/A in GLOB.player_list)
		if (A.stat == 2 || A.connected_ai || A.scrambledcodes || istype(A,/mob/living/silicon/robot/drone))
			continue
		var/name = "[A.real_name] ([A.modtype] [A.braintype])"
		borgs[name] = A

	if (borgs.len)
		// select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null|anything in borgs
		select = tgui_input_list(usr, "Unshackled borg signals detected:", "Borg selection", borgs)
		return borgs[select]

/// When a borg is activated, it can choose which AI it wants to be slaved to.
/proc/active_ais()
	. = list()
	for(var/mob/living/silicon/ai/A in living_mob_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled == 1)
			continue
		. += A
	return .

/// Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs()
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais()
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
			selected = A

	return selected

/proc/select_active_ai(mob/user)
	var/list/ais = active_ais()
	if(ais.len)
		if(user)
			// . = input(usr,"AI signals detected:", "AI selection") in ais
			. = tgui_input_list(user, "AI signals detected:", "AI selection", ais)
		else
			. = pick(ais)
	return .

/proc/get_sorted_mobs()
	var/list/old_list = getmobs()
	var/list/AI_list = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(issilicon(M))
			AI_list |= M
		else if(isobserver(M) || M.stat == 2)
			Dead_list |= M
		else if(M.key && M.client)
			keyclient_list |= M
		else if(M.key)
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	var/list/new_list = list()
	new_list += AI_list
	new_list += keyclient_list
	new_list += key_list
	new_list += logged_list
	new_list += Dead_list
	return new_list

/// Returns a list of all mobs with their name.
/proc/getmobs(ghostfollow = FALSE)

	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(isobserver(M) && ghostfollow && M.client?.holder && M.client.holder.fakekey && M.is_preference_enabled(/datum/client_preference/holder/stealth_ghost_mode))
			continue
		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if (M.stat == 2)
			if(istype(M, /mob/observer/dead/))
				name += " \[ghost\]"
			else
				name += " \[dead\]"
		creatures[name] = M

	return creatures

/proc/getmobs_ghost_follow()
	return getmobs(TRUE)

/// Orders mobs by type then by name.
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortList(GLOB.mob_list, cmp=/proc/cmp_name_asc)
	for(var/mob/observer/eye/M in sortmob)
		moblist.Add(M)
	for(var/mob/observer/blob/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/pai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/robot/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/alien/M in sortmob)
		moblist.Add(M)
	for(var/mob/observer/dead/M in sortmob)
		moblist.Add(M)
	for(var/mob/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/simple_mob/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/bot/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/captive_brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/voice/M in sortmob)
		moblist.Add(M)
//	for(var/mob/living/silicon/hivebot/M in sortmob)
//		GLOB.mob_list.Add(M)
//	for(var/mob/living/silicon/hive_mainframe/M in sortmob)
//		GLOB.mob_list.Add(M)
	return moblist

/// Forces a variable to be positive.
/proc/modulus(variable)
	if(variable >= 0)
		return variable
	if(variable < 0)
		return -variable

/// Returns the turf located at the map edge in the specified direction relative to A.
/proc/get_edge_target_turf(atom/A, direction) //Used for mass driver

	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target

/**
 * returns turf relative to A in given direction at set range
 * result is bounded to map size
 * note range is non-pythagorean
 */
/proc/get_ranged_target_turf(atom/A, direction, range) //Used for disposal system

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x,y,A.z)

/**
 * Returns turf relative to A offset in dx and dy tiles.
 * Bound to map limits.
 */
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)

/// Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value.
/proc/between(var/low, var/middle, var/high)
	return max(min(middle, high), low)

/// Returns random gauss number.
/proc/GaussRand(sigma)
	var/x,y,rsq
	do
		x=2*rand()-1
		y=2*rand()-1
		rsq=x*x+y*y
	while(rsq>1 || !rsq)
	return sigma*y*sqrt(-2*log(rsq)/rsq)

/// Returns random gauss number, rounded to 'roundto'.
/proc/GaussRandRound(sigma, roundto)
	return round(GaussRand(sigma),roundto)

/// Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length = 5) //I couldn't be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	if(!current || !target_turf)
		return 0

	while(current != target_turf)
		if(steps > length)
			return 0
		if(current.opacity)
			return 0
		for(var/atom/A in current)
			if(A.opacity)
				return 0
		current = get_step_towards(current, target_turf)
		steps++

	return 1

/proc/is_blocked_turf(turf/target)
	var/cant_pass = FALSE
	if(target.density)
		cant_pass = TRUE
	for(var/atom/A in target)
		if(A.density)//&&A.anchored
			cant_pass = TRUE
	return cant_pass

/proc/get_step_towards2(atom/source , atom/target)
	var/base_dir = get_dir(source, get_step_towards(source, target))
	var/turf/temp = get_step_towards(source, target)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
			breakpoint++

		if(!free_tile) return get_step(source, base_dir)
		else return get_step_towards(source,free_tile)

	else return get_step(source, base_dir)

/**
 * Takes: Anything that could possibly have variables and a varname to check.
 * Returns: 1 if found, 0 if not.
 */
/proc/hasvar(datum/Ref, varname)
	if(Ref.vars.Find(lowertext(varname)))
		return TRUE
	else
		return FALSE

/// Simple datum for storing coordinates.
/datum/coords
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

/**
 * Takes: Area. Optional: turf type to leave behind.
 * Returns: Nothing.
 * Notes: Attempts to move the contents of one area to another area.
 *        Movement based on lower left corner. Tiles that do not fit
 *        into the new area will not be moved.
 */
/area/proc/move_contents_to(area/A, turftoleave = null, direction = null)
	if(!A || !src)
		return FALSE

	var/list/turfs_src = list()
	var/list/turfs_trg = list()
	for(var/turf/T in contents)
		turfs_src += T
	for(var/turf/T in A)
		turfs_trg += T

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					//You can stay, though.
					if(istype(T,/turf/space))
						refined_src -= T
						refined_trg -= B
						continue moving

					var/turf/X //New Destination Turf

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon
					var/old_underlays = T.underlays.Copy()
					var/old_decals = T.decals ? T.decals.Copy() : null

					X = B.PlaceOnTop(T.type)
					X.setDir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1
					X.copy_overlays(T, TRUE)
					X.underlays = old_underlays
					X.decals = old_decals

					//Move the air from source to dest
					var/turf/simulated/ST = T
					if(istype(ST))
						var/turf/simulated/SX = X
						if(!SX.air)
							SX.make_air()
						SX.air.copy_from(ST.copy_cell_volume())

					var/z_level_change = FALSE
					if(T.z != X.z)
						z_level_change = TRUE

					//Move the objects. Not forceMove because the object isn't "moving" really, it's supposed to be on the "same" turf.
					for(var/obj/O in T)
						O.loc = X
						O.update_light()
						if(z_level_change) // The objects still need to know if their z-level changed.
							O.onTransitZ(T.z, X.z)

					//Move the mobs unless it's an AI eye or other eye type.
					for(var/mob/M in T)
						if(istype(M, /mob/observer/eye))
							continue // If we need to check for more mobs, I'll add a variable
						M.loc = X

						if(z_level_change) // Same goes for mobs.
							M.onTransitZ(T.z, X.z)

					if(turftoleave)
						T.ChangeTurf(turftoleave)
					else
						T.ScrapeAway()

					refined_src -= T
					refined_trg -= B
					continue moving

/proc/DuplicateObject(obj/original, perfectcopy = 0 , sameloc = 0)
	if(!original)
		return null

	var/obj/O = null

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(locate(0,0,0))

	if(perfectcopy)
		if((O) && (original))
			for(var/V in original.vars)
				if(!(V in list("type","loc","locs","vars", "parent", "parent_type","verbs","ckey","key")))
					O.vars[V] = original.vars[V]
	return O

/**
 * Takes: Area. Optional: If it should copy to areas that don't have plating
 * Returns: Nothing.
 * Notes: Attempts to move the contents of one area to another area.
 *        Movement based on lower left corner. Tiles that do not fit
 *        into the new area will not be moved.
 *
 * Does *not* affect gases etc; copied turfs will be changed via ChangeTurf,
 * and the dir, icon, and icon_state copied. All other vars will remain default.
 */
/area/proc/copy_contents_to(area/A , platingRequired = 0)
	if(!A || !src)
		return FALSE

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/toupdate = new/list()

	var/copiedobjs = list()


	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon
					var/old_decals = T.decals?.Copy()
					var/old_overlays = copy_overlays(T)
					var/old_underlays = T.underlays.Copy()

					if(platingRequired)
						if(istype(B, GLOB.using_map.base_turf_by_z[B.z]))
							continue moving

					var/turf/X = B
					X.ChangeTurf(T.type)
					X.setDir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi
					X.decals = old_decals
					X.overlays = old_overlays
					X.underlays = old_underlays

					var/list/objs = new/list()
					var/list/newobjs = new/list()
					var/list/mobs = new/list()
					var/list/newmobs = new/list()

					for(var/obj/O in T)

						if(!istype(O,/obj))
							continue

						objs += O


					for(var/obj/O in objs)
						newobjs += DuplicateObject(O , 1)


					for(var/obj/O in newobjs)
						O.loc = X

					for(var/mob/M in T)

						if(!istype(M,/mob) || istype(M, /mob/observer/eye)) continue // If we need to check for more mobs, I'll add a variable
						mobs += M

					for(var/mob/M in mobs)
						newmobs += DuplicateObject(M , 1)

					for(var/mob/M in newmobs)
						M.loc = X

					copiedobjs += newobjs
					copiedobjs += newmobs

//					var/area/AR = X.loc

//					if(AR.dynamic_lighting)
//						X.opacity = !X.opacity
//						X.sd_SetOpacity(!X.opacity)			//TODO: rewrite this code so it's not messed by lighting ~Carn

					toupdate += X

					refined_src -= T
					refined_trg -= B
					continue moving

	if(toupdate.len)
		for(var/turf/simulated/T1 in toupdate)
			T1.queue_zone_update()

	return copiedobjs

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)

/// Chances are 1:value. anyprob(1) will always return true.
/proc/anyprob(value)
	return (rand(1,value)==value)

/proc/view_or_range(distance = world.view, center = usr, type)
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)
	return

/proc/oview_or_orange(distance = world.view, center = usr, type)
	switch(type)
		if("view")
			. = oview(distance,center)
		if("range")
			. = orange(distance,center)
	return

/proc/get_mob_with_client_list()
	var/list/mobs = list()
	for(var/mob/M in GLOB.mob_list)
		if (M.client)
			mobs += M
	return mobs


/proc/parse_zone(zone)
	if      (zone == "r_hand") return "right hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_arm")  return "left arm"
	else if (zone == "r_arm")  return "right arm"
	else if (zone == "l_leg")  return "left leg"
	else if (zone == "r_leg")  return "right leg"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "r_hand") return "right hand"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else                       return zone

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

/proc/get_turf_or_move(turf/location)
	return get_turf(location)

/// Quick type checks for some tools.
/var/global/list/common_tools = list(
	/obj/item/multitool,
	/obj/item/stack/cable_coil,
	/obj/item/tool/crowbar,
	/obj/item/tool/screwdriver,
	/obj/item/tool/wirecutters,
	/obj/item/tool/wrench,
	/obj/item/weldingtool,
)

/proc/istool(O)
	if(O && is_type_in_list(O, common_tools))
		return TRUE
	return FALSE


/proc/is_wire_tool(obj/item/I)
	if(istype(I, /obj/item/multitool) || I.is_wirecutter())
		return TRUE
	if(istype(I, /obj/item/assembly/signaler))
		return TRUE
	return

/proc/is_hot(obj/item/W as obj)
	switch(W.type)
		if(/obj/item/weldingtool)
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				return 3800
			else
				return FALSE
		if(/obj/item/flame/lighter)
			if(W:lit)
				return 1500
			else
				return FALSE
		if(/obj/item/flame/match)
			if(W:lit)
				return 1000
			else
				return FALSE
		if(/obj/item/clothing/mask/smokable/cigarette)
			if(W:lit)
				return 1000
			else
				return FALSE
		if(/obj/item/pickaxe/plasmacutter)
			return 3800
		if(/obj/item/melee/energy)
			return 3500
		else
			return FALSE

/// Whether or not the given item counts as sharp in terms of dealing damage.
/proc/is_sharp(obj/O as obj)
	if(!O)
		return FALSE
	if(O.sharp)
		return TRUE
	if(O.edge)
		return TRUE
	return FALSE

/// Whether or not the given item counts as cutting with an edge in terms of removing limbs.
/proc/has_edge(obj/O as obj)
	if(!O)
		return FALSE
	if(O.edge)
		return TRUE
	return FALSE

/// Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
/proc/can_puncture(obj/item/W as obj) //For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
	if(!W)
		return FALSE
	if(W.sharp)
		return TRUE
	return ( \
		W.is_screwdriver()                                    || \
		istype(W, /obj/item/pen)                              || \
		istype(W, /obj/item/weldingtool)                      || \
		istype(W, /obj/item/flame/lighter/zippo)              || \
		istype(W, /obj/item/flame/match)                      || \
		istype(W, /obj/item/clothing/mask/smokable/cigarette) || \
		istype(W, /obj/item/shovel) \
	)

/proc/is_surgery_tool(obj/item/W as obj)
	return (	\
	istype(W, /obj/item/surgical/scalpel)   || \
	istype(W, /obj/item/surgical/hemostat)  || \
	istype(W, /obj/item/surgical/retractor) || \
	istype(W, /obj/item/surgical/cautery)   || \
	istype(W, /obj/item/surgical/bonegel)   || \
	istype(W, /obj/item/surgical/bonesetter)
	)

/**
 * check if mob is lying down on something we can operate him on.
 * The RNG with table/rollerbeds comes into play in do_surgery() so that fail_step() can be used instead.
 */
/proc/can_operate(mob/living/carbon/M)
	return M.lying

/// Returns an instance of a valid surgery surface.
/mob/living/proc/get_surgery_surface()
	if(!lying)
		return null //Not lying down means no surface.
	var/obj/surface = null
	for(var/obj/O in loc) //Looks for the best surface.
		if(O.surgery_odds)
			if(!surface || surface.surgery_odds < O)
				surface = O
	if(surface)
		return surface

/**
 * Checks if that loc and dir has a item on the wall
 * TODO - Fix this ancient list of wall items. Preferably make it dynamically populated. ~Leshana
*/
var/list/WALLITEMS = list(
	/obj/machinery/power/apc, /obj/machinery/alarm, /obj/item/radio/intercom, /obj/structure/frame,
	/obj/structure/extinguisher_cabinet, /obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/requests_console, /obj/machinery/light_switch, /obj/structure/sign,
	/obj/machinery/newscaster, /obj/machinery/firealarm, /obj/structure/noticeboard, /obj/machinery/button/remote,
	/obj/machinery/computer/security/telescreen, /obj/machinery/embedded_controller/radio,
	/obj/item/storage/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/structure/mirror, /obj/structure/fireaxecabinet, /obj/machinery/computer/security/telescreen/entertainment,
)

/proc/gotwallitem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in WALLITEMS)
			if(istype(O, item))
				//Direction works sometimes
				if(O.dir == dir)
					return 1

				//Some stuff doesn't use dir properly, so we need to check pixel instead
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return 1
					if(NORTH)
						if(O.pixel_y < -10)
							return 1
					if(WEST)
						if(O.pixel_x > 10)
							return 1
					if(EAST)
						if(O.pixel_x < -10)
							return 1


	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in get_step(loc, dir))
		for(var/item in WALLITEMS)
			if(istype(O, item))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1
	return 0

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/topic_link(datum/D, arglist, content)
	if(istype(arglist,/list))
		arglist = list2params(arglist)
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"

/proc/get_random_colour(simple, lower = 0, upper = 255)
	var/colour
	if(simple)
		colour = pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))
	else
		for(var/i=1;i<=3;i++)
			var/temp_col = "[num2hex(rand(lower,upper))]"
			if(length(temp_col )<2)
				temp_col  = "0[temp_col]"
			colour += temp_col
	return colour


/atom/proc/get_light_and_color(atom/origin)
	if(origin)
		color = origin.color
		set_light(origin.light_range, origin.light_power, origin.light_color)

/// Call to generate a stack trace and print to runtime logs.
/proc/crash_with(msg)
	CRASH(msg)

/proc/screen_loc2turf(scr_loc, turf/origin)
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	tX = max(1, min(world.maxx, origin.x + (text2num(tX) - (world.view + 1))))
	tY = max(1, min(world.maxy, origin.y + (text2num(tY) - (world.view + 1))))
	return locate(tX, tY, tZ)

/// Displays something as commonly used (non-submultiples) SI units.
/proc/format_SI(var/number, var/symbol)
	switch(round(abs(number)))
		if(0 to 1000-1)
			return "[number] [symbol]"
		if(1e3 to 1e6-1)
			return "[round(number / 1000, 0.1)] k[symbol]" // kilo
		if(1e6 to 1e9-1)
			return "[round(number / 1e6, 0.1)] M[symbol]" // mega
		if(1e9 to 1e12-1) // Probably not needed but why not be complete?
			return "[round(number / 1e9, 0.1)] G[symbol]" // giga
		if(1e12 to 1e15-1)
			return "[round(number / 1e12, 0.1)] T[symbol]" // tera

/// Ultra range (no limitations on distance, faster than range for distances > 8); including areas drastically decreases performance.
/proc/urange(dist = 0, atom/center = usr, orange = 0, areas = 0)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()

	var/list/turfs = RANGE_TURFS(dist, center)
	if(orange)
		turfs -= get_turf(center)
	. = list()
	for(var/V in turfs)
		var/turf/T = V
		. += T
		. += T.contents
		if(areas)
			. |= T.loc

/// Similar function to range(), but with no limitations on the distance; will search spiralling outwards from the center.
/proc/spiral_range(dist = 0, center = usr, orange = 0)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()

	var/turf/t_center = get_turf(center)
	if(!t_center)
		return list()

	var/list/L = list()
	var/turf/T
	var/y
	var/x
	var/c_dist = 1

	if(!orange)
		L += t_center
		L += t_center.contents

	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y-c_dist to y)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x-c_dist to x)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
				L += T.contents
		c_dist++

	return L

/// Similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs).
/proc/spiral_range_turfs(dist = 0, center = usr, orange = 0, list/outlist = list(), tick_checked)
	outlist.Cut()
	if(!dist)
		outlist += center
		return outlist

	var/turf/t_center = get_turf(center)
	if(!t_center)
		return outlist

	var/list/L = outlist
	var/turf/T
	var/y
	var/x
	var/c_dist = 1

	if(!orange)
		L += t_center

	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y-c_dist to y)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x-c_dist to x)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
		c_dist++
		if(tick_checked)
			CHECK_TICK

	return L

#define NOT_FLAG(flag) (!(flag & use_flags))
#define HAS_FLAG(flag) (flag & use_flags)

/**
 * Checks if user can use this object. Set use_flags to customize what checks are done.
 * Returns 0 if they can use it, a value representing why they can't if not.
 * Flags are in `code/__defines/misc.dm`
 */
/atom/proc/use_check(mob/user, use_flags = 0, show_messages = FALSE)
	. = 0
	if (NOT_FLAG(USE_ALLOW_NONLIVING) && !isliving(user))
		//No message for ghosts.
		return USE_FAIL_NONLIVING

	if (NOT_FLAG(USE_ALLOW_NON_ADJACENT) && !Adjacent(user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You're too far away from [src] to do that."))
		return USE_FAIL_NON_ADJACENT

	if (NOT_FLAG(USE_ALLOW_DEAD) && user.stat == DEAD)
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You can't do that when you're dead."))
		return USE_FAIL_DEAD

	if (NOT_FLAG(USE_ALLOW_INCAPACITATED) && (user.incapacitated()))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You cannot do that in your current state."))
		return USE_FAIL_INCAPACITATED

	if (NOT_FLAG(USE_ALLOW_NON_ADV_TOOL_USR) && !user.IsAdvancedToolUser())
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You don't know how to operate [src]."))
		return USE_FAIL_NON_ADV_TOOL_USR

	if (HAS_FLAG(USE_DISALLOW_SILICONS) && issilicon(user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You need hands for that."))
		return USE_FAIL_IS_SILICON

	if (HAS_FLAG(USE_FORCE_SRC_IN_USER) && !(src in user))
		if (show_messages)
			to_chat(user, SPAN_NOTICE("You need to be holding [src] to do that."))
		return USE_FAIL_NOT_IN_USER

#undef NOT_FLAG
#undef HAS_FLAG

/**
 * Returns direction-string, rounded to multiples of 22.5, from the first parameter to the second
 * N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
 */
/proc/get_adir(turf/A, turf/B)
	var/degree = Get_Angle(A, B)
	switch(round(degree%360, 22.5))
		if(0)
			return "North"
		if(22.5)
			return "North-Northeast"
		if(45)
			return "Northeast"
		if(67.5)
			return "East-Northeast"
		if(90)
			return "East"
		if(112.5)
			return "East-Southeast"
		if(135)
			return "Southeast"
		if(157.5)
			return "South-Southeast"
		if(180)
			return "South"
		if(202.5)
			return "South-Southwest"
		if(225)
			return "Southwest"
		if(247.5)
			return "West-Southwest"
		if(270)
			return "West"
		if(292.5)
			return "West-Northwest"
		if(315)
			return "Northwest"
		if(337.5)
			return "North-Northwest"

/atom/proc/Shake(pixelshiftx = 15, pixelshifty = 15, duration = 250)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	var/shiftx = rand(-pixelshiftx,pixelshiftx)
	var/shifty = rand(-pixelshifty,pixelshifty)
	animate(src, pixel_x = pixel_x + shiftx, pixel_y = pixel_y + shifty, time = 0.2, loop = duration)
	pixel_x = initialpixelx
	pixel_y = initialpixely

/**
 * get_holder_at_turf_level(): Similar to get_turf(), will return the "highest up" holder of this atom, excluding the turf.
 * Example: A fork inside a box inside a locker will return the locker. Essentially, get_just_before_turf().
 */ //Credit to /vg/
/proc/get_holder_at_turf_level(const/atom/movable/O)
	if(!istype(O)) //atom/movable does not include areas
		return
	var/atom/A
	for(A=O, A && !isturf(A.loc), A=A.loc); //Semicolon is for the empty statement
	return A

/proc/get_safe_ventcrawl_target(obj/machinery/atmospherics/component/unary/vent_pump/start_vent)
	if(!start_vent.network || !start_vent.network.normal_members.len)
		return
	var/list/vent_list = list()
	for(var/obj/machinery/atmospherics/component/unary/vent_pump/vent in start_vent.network.normal_members)
		if(vent == start_vent)
			continue
		if(vent.welded)
			continue
		if(istype(get_area(vent), /area/crew_quarters/sleep)) //No going to dorms
			continue
		vent_list += vent
	if(!vent_list.len)
		return
	return pick(vent_list)

/proc/split_into_3(total)
	if(!total || !isnum(total))
		return

	var/part1 = rand(0,total)
	var/part2 = rand(0,total)
	var/part3 = total-(part1+part2)

	if(part3<0)
		part1 = total-part1
		part2 = total-part2
		part3 = -part3

	return list(part1, part2, part3)

/// Sender is optional
/proc/admin_chat_message(message = "Debug Message", color = "#FFFFFF", sender)
	// Adds TGS3 integration to those fancy verbose round event messages.
	if(message)
		send2irc("Event", message)
	if (!config_legacy.chat_webhook_url || !message)
		return
	spawn(0)
		var/query_string = "type=adminalert"
		query_string += "&key=[url_encode(config_legacy.chat_webhook_key)]"
		query_string += "&msg=[url_encode(message)]"
		query_string += "&color=[url_encode(color)]"
		if(sender)
			query_string += "&from=[url_encode(sender)]"
		world.Export("[config_legacy.chat_webhook_url]?[query_string]")

/// This is a helper for anything that wants to render the map in TGUI.
/proc/get_tgui_plane_masters()
	. = list()

	//! 'Utility' planes
	/// Lighting system (lighting_overlay objects)
	. += new /atom/movable/screen/plane_master/fullbright
	/// Lighting system (but different!)
	. += new /atom/movable/screen/plane_master/lighting
	. += new /atom/movable/screen/plane_master/emissive
	/// Ghosts!
	. += new /atom/movable/screen/plane_master/ghosts
	/// AI Eye!
	. += new /atom/movable/screen/plane_master{plane = PLANE_AI_EYE}

	/// For admin use
	. += new /atom/movable/screen/plane_master{plane = PLANE_ADMIN1}
	/// For admin use
	. += new /atom/movable/screen/plane_master{plane = PLANE_ADMIN2}
	/// For admin use
	. += new /atom/movable/screen/plane_master{plane = PLANE_ADMIN3}

	/// Meson-specific things like open ceilings.
	. += new /atom/movable/screen/plane_master{plane = PLANE_MESONS}
	/// Things that only show up while in build mode.
	// . += new /atom/movable/screen/plane_master{plane = PLANE_BUILDMODE}

	//! Real tangible stuff planes
	. += new /atom/movable/screen/plane_master/main{plane = TURF_PLANE}
	. += new /atom/movable/screen/plane_master/main{plane = OBJ_PLANE}
	. += new /atom/movable/screen/plane_master/main{plane = MOB_PLANE}
	/// Cloaked atoms!
	// . += new /atom/movable/screen/plane_master/cloaked

	//! Random other plane masters from Virgo
	// Augmented reality.
	. += new /atom/movable/screen/plane_master{plane = PLANE_AUGMENTED}
	. += new /atom/movable/screen/plane_master/parallax{plane = PARALLAX_PLANE}
