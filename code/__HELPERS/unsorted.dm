/*
 * A large number of misc global procs.
 */

//Inverts the colour of an HTML string
/proc/invertHTML(HTMLstring)
	if(!istext(HTMLstring))
		CRASH("Given non-text argument!")
	else if(length(HTMLstring) != 7)
		CRASH("Given non-HTML argument!")
	else if(length_char(HTMLstring) != 7)
		CRASH("Given non-hex symbols in argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	return rgb(255 - hex2num(textr), 255 - hex2num(textg), 255 - hex2num(textb))

/proc/Get_Angle(atom/movable/start, atom/movable/end)//For beams.
	if(!start || !end)
		return 0
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

/proc/Get_Pixel_Angle(y, x)//for getting the angle when animating something's pixel_x and pixel_y
	if(!y)
		return (x>=0)?90:270
	.=arctan(x/y)
	if(y<0)
		.+=180
	else if(x<0)
		.+=360

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location, mob/target, distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are separate in case you want to teleport some distance from a turf the target is not standing on or something.
*/

	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list[] = list()//To add turfs to list.
			//destination_list = new()
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density&&T.density)
					continue//If density was specified.
				if(T.x>world.maxx || T.x<1)
					continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)
					continue
				destination_list += T
			if(destination_list.len)
				destination = pick(destination_list)
			else
				return

		else//Same deal here.
			if(density&&destination.density)
				return
			if(destination.x>world.maxx || destination.x<1)
				return
			if(destination.y>world.maxy || destination.y<1)
				return
	else
		return

	return destination

/proc/getline(atom/M, atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	var/px=M.x		//starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs = abs(dx)//Absolute value of x distance
	var/dyabs = abs(dy)
	var/sdx = SIGN(dx)	//Sign of x distance (+ or -)
	var/sdy = SIGN(dy)
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px,py,M.z)
	return line

//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return FALSE

	var/i, ch, len = length(key)

	for (i = 7, i <= len, ++i) //we know the first 6 chars are Guest-
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57) //0-9
			return FALSE
	return TRUE






//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
//Last modified by Carn
/mob/proc/rename_self(var/role, var/allow_numbers=0)
	spawn(0)
		var/oldname = real_name

		var/time_passed = world.time
		var/newname

		for(var/i=1,i<=3,i++)	//we get 3 attempts to pick a suitable name.
			newname = input(src,"You are \a [role]. Would you like to change your name to something else?", "Name change",oldname) as text
			if((world.time-time_passed)>3000)
				return	//took too long
			newname = sanitizeName(newname, ,allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.

			for(var/mob/living/M in player_list)
				if(M == src)
					continue
				if(!newname || M.real_name == newname)
					newname = null
					break
			if(newname)
				break	//That's a suitable name!
			to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

		if(!newname)	//we'll stick with the oldname then
			return

		if(cmptext("ai",role))
			if(isAI(src))
				var/mob/living/silicon/ai/A = src
				oldname = null//don't bother with the records update crap
				//world << "<b>[newname] is the AI!</b>"
				//world << sound('sound/AI/newAI.ogg')
				// Set eyeobj name
				A.SetName(newname)


		fully_replace_character_name(oldname,newname)



//Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ionnum()
	return "[pick("!","@","#","$","%","^","&")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

//Returns a list of unslaved cyborgs
/proc/active_free_borgs()
	. = list()
	for(var/mob/living/silicon/robot/R in living_mob_list)
		if(R.connected_ai || istype(R, /mob/living/silicon/robot/drone))// || R.shell) no shell yet
			continue
		if(R.stat == DEAD)
			continue
		if(R.emagged || R.scrambledcodes)
			continue
		. += R
//Returns a list of AI's
/proc/active_ais(check_mind = FALSE)
	. = list()
	for(var/mob/living/silicon/ai/A in living_mob_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled)
			continue
		if(check_mind)
			if(!A.mind)
				continue
		. += A
	return .

//Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs()
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais()
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
			selected = A

	return selected

/proc/select_active_free_borg(mob/user)
	var/list/borgs = active_free_borgs()
	if(borgs.len)
		if(user)
			. = input(user,"Unshackled cyborg signals detected:", "Cyborg Selection", borgs[1]) in borgs
		else
			. = pick(borgs)
	return .

/proc/select_active_ai(mob/user)
	var/list/ais = active_ais()
	if(ais.len)
		if(user)
			. = input(user,"AI signals detected:", "AI Selection", ais[1]) in ais
		else
			. = pick(ais)
	return .

//Orders mobs by type then by name
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortNames(GLOB.mob_list)
	for(var/mob/observer/blob/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/observer/eye/M in sortmob) //assuming this is cammera
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
//	for(var/mob/living/silicon/hivebot/M in sortmob)
//		mob_list.Add(M)
//	for(var/mob/living/silicon/hive_mainframe/M in sortmob)
//		mob_list.Add(M)
	return moblist

// Format a power value in W, kW, MW, or GW.
/proc/DisplayPower(powerused)
	if(powerused < 1000) //Less than a kW
		return "[powerused] W"
	else if(powerused < 1000000) //Less than a MW
		return "[round((powerused * 0.001),0.01)] kW"
	else if(powerused < 1000000000) //Less than a GW
		return "[round((powerused * 0.000001),0.001)] MW"
	return "[round((powerused * 0.000000001),0.0001)] GW"

// Format an energy value in J, kJ, MJ, or GJ. 1W = 1J/s.
/proc/DisplayEnergy(units)
	// APCs process every (SSmachines.wait * 0.1) seconds, and turn 1 W of
	// excess power into GLOB.CELLRATE energy units when charging cells.
	// With the current configuration of wait=20 and CELLRATE=0.002, this
	// means that one unit is 1 kJ.
	units *= SSmachines.wait * 0.1 / GLOB.CELLRATE
	if (units < 1000) // Less than a kJ
		return "[round(units, 0.1)] J"
	else if (units < 1000000) // Less than a MJ
		return "[round(units * 0.001, 0.01)] kJ"
	else if (units < 1000000000) // Less than a GJ
		return "[round(units * 0.000001, 0.001)] MJ"
	return "[round(units * 0.000000001, 0.0001)] GJ"

/proc/get_mob_by_ckey(key)
	if(!key)
		return
	var/list/mobs = sortmobs()
	for(var/mob/M in mobs)
		if(M.ckey == key)
			return M

//Returns the atom sitting on the turf.
//For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
//Optional arg 'type' to stop once it reaches a specific type instead of a turf.
/proc/get_atom_on_turf(atom/movable/M, stop_type)
	var/atom/loc = M
	while(loc && loc.loc && !isturf(loc.loc))
		loc = loc.loc
		if(stop_type && istype(loc, stop_type))
			break
	return loc

//Returns a list of all locations the target is within.
/proc/get_nested_locs(atom/movable/M, include_turf = FALSE)
	. = list()
	var/atom/A = M.loc
	while(A && !isturf(A))
		. += A
		A = A.loc
	if(A && include_turf) //At this point, only the turf is left.
		. += A

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)
	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH|EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = world.maxy
	else if(direction & SOUTH) //you should not have both NORTH and SOUTH in the provided direction
		y = 1
	if(direction & EAST)
		x = world.maxx
	else if(direction & WEST)
		x = 1
	if(direction in GLOB.diagonals) //let's make sure it's accurately-placed for diagonals
		var/lowest_distance_to_map_edge = min(abs(x - A.x), abs(y - A.y))
		return get_ranged_target_turf(A, direction, lowest_distance_to_map_edge)
	return locate(x, y, A.z)

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)
	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	else if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	else if(direction & WEST) //if you have both EAST and WEST in the provided direction, then you're gonna have issues
		x = max(1, x - range)

	return locate(x, y, A.z)

/**
  * Get ranged target turf, but with direct targets as opposed to directions
  *
  * Starts at atom A and gets the exact angle between A and target
  * Moves from A with that angle, Range amount of times, until it stops, bound to map size
  * Arguments:
  * * A - Initial Firer / Position
  * * target - Target to aim towards
  * * range - Distance of returned target turf from A
  * * offset - Angle offset, 180 input would make the returned target turf be in the opposite direction
  */
/proc/get_ranged_target_turf_direct(atom/A, atom/target, range, offset)
	var/angle = arctan(target.x - A.x, target.y - A.y)
	if(offset)
		angle += offset
	var/turf/T = get_turf(A)
	for(var/i in 1 to range)
		var/turf/check = locate(A.x + cos(angle) * i, A.y + sin(angle) * i, A.z)
		if(!check)
			break
		T = check

	return T

// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x, y, A.z)

/*
 * Gets all contents of contents and returns them all in a list.
 * @param T as type - optional
 */
/atom/proc/GetAllContents(T)
	var/list/processing_list = list(src)
	if(T)
		. = list()
		var/i = 0
		while(i < length(processing_list))
			var/atom/A = processing_list[++i]
			//Byond does not allow things to be in multiple contents, or double parent-child hierarchies, so only += is needed
			//This is also why we don't need to check against assembled as we go along
			processing_list += A.contents
			if(istype(A, T))
				. += A
	else
		var/i = 0
		while(i < length(processing_list))
			var/atom/A = processing_list[++i]
			processing_list += A.contents
		return processing_list
//GetAllContents, but with a blacklist
/atom/proc/GetAllContentsIgnoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return GetAllContents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	while(i < length(processing))
		var/atom/A = processing[++i]
		if(!ignore_typecache[A.type])
			processing += A.contents
			. += A

//Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 1
	if(current != target_turf)
		current = get_step_towards(current, target_turf)
		while(current != target_turf)
			if(steps > length)
				return FALSE
			if(current.opacity)
				return FALSE
			for(var/thing in current)
				var/atom/A = thing
				if(A.opacity)
					return FALSE
			current = get_step_towards(current, target_turf)
			steps++

	return TRUE

/proc/is_blocked_turf(turf/T, exclude_mobs)
	if(T.density)
		return TRUE
	for(var/i in T)
		var/atom/A = i
		if(A.density && (!exclude_mobs || !ismob(A)))
			return TRUE
	return FALSE

/proc/is_anchored_dense_turf(turf/T) //like the older version of the above, fails only if also anchored
	if(T.density)
		return TRUE
	for(var/i in T)
		var/atom/movable/A = i
		if(A.density && A.anchored)
			return TRUE
	return FALSE

/proc/get_step_towards2(atom/ref , atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)

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

		if(!free_tile)
			return get_step(ref, base_dir)
		else
			return get_step_towards(ref,free_tile)

	else
		return get_step(ref, base_dir)

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(datum/A, varname)
	if(A.vars.Find(lowertext(varname)))
		return TRUE
	else
		return FALSE

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)

//chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1, value)==value)

/proc/view_or_range(distance = world.view , center = usr , type)
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)
	return

/proc/oview_or_orange(distance = world.view , center = usr , type)
	switch(type)
		if("view")
			. = oview(distance,center)
		if("range")
			. = orange(distance,center)
	return

/proc/parse_zone(zone)
	switch(zone)
		if(BODY_ZONE_PRECISE_R_HAND)
			return "right hand"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "left hand"
		if(BODY_ZONE_L_ARM)
			return "left arm"
		if(BODY_ZONE_R_ARM)
			return "right arm"
		if(BODY_ZONE_L_LEG)
			return "left leg"
		if(BODY_ZONE_R_LEG)
			return "right leg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "left foot"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "right foot"
		else
			return zone

/*

 Gets the turf this atom's *ICON* appears to inhabit
 It takes into account:
 * Pixel_x/y
 * Matrix x/y

 NOTE: if your atom has non-standard bounds then this proc
 will handle it, but:
 * if the bounds are even, then there are an even amount of "middle" turfs, the one to the EAST, NORTH, or BOTH is picked
 (this may seem bad, but you're atleast as close to the center of the atom as possible, better than byond's default loc being all the way off)
 * if the bounds are odd, the true middle turf of the atom is returned

*/

/proc/get_turf_pixel(atom/AM)
	if(!istype(AM))
		return

	//Find AM's matrix so we can use it's X/Y pixel shifts
	var/matrix/M = matrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x + M.get_x_shift()
	var/pixel_y_offset = AM.pixel_y + M.get_y_shift()

	//Irregular objects
	var/icon/AMicon = icon(AM.icon, AM.icon_state)
	var/AMiconheight = AMicon.Height()
	var/AMiconwidth = AMicon.Width()
	if(AMiconheight != world.icon_size || AMiconwidth != world.icon_size)
		pixel_x_offset += ((AMiconwidth/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMiconheight/world.icon_size)-1)*(world.icon_size*0.5)

	//DY and DX
	var/rough_x = round(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rough_y = round(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//Find coordinates
	var/turf/T = get_turf(AM) //use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom
	if(!T)
		return null
	var/final_x = T.x + rough_x
	var/final_y = T.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

//Finds the distance between two atoms, in pixels
//centered = 0 counts from turf edge to edge
//centered = 1 counts from turf center to turf center
//of course mathematically this is just adding world.icon_size on again
/proc/getPixelDistance(atom/A, atom/B, centered = TRUE)
	if(!istype(A)||!istype(B))
		return 0
	. = bounds_dist(A, B) + sqrt((((A.pixel_x+B.pixel_x)**2) + ((A.pixel_y+B.pixel_y)**2)))
	if(centered)
		. += world.icon_size

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

//For objects that should embed, but make no sense being is_sharp or is_pointed()
//e.g: rods
GLOBAL_LIST_INIT(can_embed_types, typecacheof(list(
	/obj/item/stack/rods,
	/obj/item/pipe)))

/*
Checks if that loc and dir has an item on the wall
*/
GLOBAL_LIST_INIT(WALLITEMS, typecacheof(list(
	/obj/machinery/power/apc, /obj/machinery/alarm, /obj/item/radio/intercom,
	/obj/structure/extinguisher_cabinet, /obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/requests_console, /obj/machinery/light_switch, /obj/structure/sign,
	/obj/machinery/newscaster, /obj/machinery/firealarm, /obj/structure/noticeboard, /obj/machinery/button,
	/obj/machinery/computer/security/telescreen, /obj/machinery/embedded_controller/radio,
	/obj/item/storage/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/structure/mirror, /obj/structure/fireaxecabinet, /obj/machinery/computer/security/telescreen/entertainment,
	/obj/structure/frame //assuming this is the pictureframe
	)))

GLOBAL_LIST_INIT(WALLITEMS_EXTERNAL, typecacheof(list(
	/obj/machinery/camera, /* /obj/structure/camera_assembly,*/
	/obj/machinery/light_construct, /obj/machinery/light)))

GLOBAL_LIST_INIT(WALLITEMS_INVERSE, typecacheof(list(
	/obj/machinery/light_construct, /obj/machinery/light)))

/proc/gotwallitem(loc, dir, check_external = FALSE) //NOTE: add one on the apc later!
	var/locdir = get_step(loc, dir)
	for(var/obj/O in loc)
		if(is_type_in_typecache(O, GLOB.WALLITEMS) && check_external != 2)
			//Direction works sometimes
			if(is_type_in_typecache(O, GLOB.WALLITEMS_INVERSE))
				if(O.dir == turn(dir, 180))
					return TRUE
			else if(O.dir == dir)
				return TRUE

			//Some stuff doesn't use dir properly, so we need to check pixel instead
			//That's exactly what get_turf_pixel() does
			if(get_turf_pixel(O) == locdir)
				return TRUE

		if(is_type_in_typecache(O, GLOB.WALLITEMS_EXTERNAL) && check_external)
			if(is_type_in_typecache(O, GLOB.WALLITEMS_INVERSE))
				if(O.dir == turn(dir, 180))
					return TRUE
			else if(O.dir == dir)
				return TRUE

	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in locdir)
		if(is_type_in_typecache(O, GLOB.WALLITEMS) && check_external != 2)
			if(O.pixel_x == 0 && O.pixel_y == 0)
				return TRUE
	return FALSE

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/check_target_facings(mob/living/initator, mob/living/target)
	/*This can be used to add additional effects on interactions between mobs depending on how the mobs are facing each other, such as adding a crit damage to blows to the back of a guy's head.
	Given how click code currently works (Nov '13), the initiating mob will be facing the target mob most of the time
	That said, this proc should not be used if the change facing proc of the click code is overridden at the same time*/
	if(!ismob(target) || target.lying)
	//Make sure we are not doing this for things that can't have a logical direction to the players given that the target would be on their side
		return FALSE
	if(initator.dir == target.dir) //mobs are facing the same direction
		return FACING_SAME_DIR
	if(is_A_facing_B(initator,target) && is_A_facing_B(target,initator)) //mobs are facing each other
		return FACING_EACHOTHER
	if(initator.dir + 2 == target.dir || initator.dir - 2 == target.dir || initator.dir + 6 == target.dir || initator.dir - 6 == target.dir) //Initating mob is looking at the target, while the target mob is looking in a direction perpendicular to the 1st
		return FACING_INIT_FACING_TARGET_TARGET_FACING_PERPENDICULAR

/proc/random_step(atom/movable/AM, steps, chance)
	var/initial_chance = chance
	while(steps > 0)
		if(prob(chance))
			step(AM, pick(GLOB.alldirs))
		chance = max(chance - (initial_chance / steps), 0)
		steps--

/proc/living_player_count()
	var/living_player_count = 0
	for(var/mob in player_list)
		if(mob in living_mob_list)
			living_player_count += 1
	return living_player_count

/proc/randomColor(mode = 0)	//if 1 it doesn't pick white, black or gray
	switch(mode)
		if(0)
			return pick(list("white","black","gray","red","green","blue","brown","yellow","orange","darkred",
						"crimson","lime","darkgreen","cyan","navy","teal","purple","indigo"))
		if(1)
			return pick(list("red","green","blue","brown","yellow","orange","darkred","crimson",
						"lime","darkgreen","cyan","navy","teal","purple","indigo"))
		else
			return "white"

/proc/params2turf(scr_loc, turf/origin, client/C)
	if(!scr_loc)
		return null
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = clamp(origin.x + text2num(tX) - round(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = clamp(origin.y + text2num(tY) - round(actual_view[2] / 2) - 1, 1, world.maxy)
	return locate(tX, tY, tZ)

/proc/screen_loc2turf(text, turf/origin, client/C)
	if(!text)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")//we use `-` not `:` (see click.dm)
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = clamp(origin.x + round(actual_view[1] / 2) - tX, 1, world.maxx)
	tY = clamp(origin.y + round(actual_view[2] / 2) - tY, 1, world.maxy)
	return locate(tX, tY, tZ)

/proc/IsValidSrc(datum/D)
	if(istype(D))
		return !QDELETED(D)
	return 0

//Compare A's dir, the clockwise dir of A and the anticlockwise dir of A
//To the opposite dir of the dir returned by get_dir(B,A)
//If one of them is a match, then A is facing B
/proc/is_A_facing_B(atom/A, atom/B)
	if(!istype(A) || !istype(B))
		return FALSE
	if(isliving(A))
		var/mob/living/LA = A
		if(LA.lying)
			return FALSE
	var/goal_dir = get_dir(A,B)
	var/clockwise_A_dir = turn(A.dir, -45)
	var/anticlockwise_A_dir = turn(A.dir, 45)

	if(A.dir == goal_dir || clockwise_A_dir == goal_dir || anticlockwise_A_dir == goal_dir)
		return TRUE
	return FALSE

/*
 * Rough example of the "cone" made by the 3 dirs checked
 *
 *   B
 *    \
 *     \
 *      >
 *       <
 *        \
 *         \
 * B --><-- A
 *         /
 *        /
 *       <
 *      >
 *     /
 *    /
 *   B
 * ==================================================
 * Center's an image.
 * Requires:
 * The Image
 * The x dimension of the icon file used in the image
 * The y dimension of the icon file used in the image
 * eg: center_image(I, 32,32)
 * eg2: center_image(I, 96,96)
 */
/proc/center_image(image/I, x_dimension = 0, y_dimension = 0)
	if(!I)
		return

	if(!x_dimension || !y_dimension)
		return

	if((x_dimension == world.icon_size) && (y_dimension == world.icon_size))
		return I

	//Offset the image so that it's bottom left corner is shifted this many pixels
	//This makes it infinitely easier to draw larger inhands/images larger than world.iconsize
	//but still use them in game
	var/x_offset = -((x_dimension/world.icon_size)-1)*(world.icon_size*0.5)
	var/y_offset = -((y_dimension/world.icon_size)-1)*(world.icon_size*0.5)

	//Correct values under world.icon_size
	if(x_dimension < world.icon_size)
		x_offset *= -1
	if(y_dimension < world.icon_size)
		y_offset *= -1

	I.pixel_x = x_offset
	I.pixel_y = y_offset

	return I

//ultra range (no limitations on distance, faster than range for distances > 8); including areas drastically decreases performance
/proc/urange(dist=0, atom/center=usr, orange=0, areas=0)
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

//similar function to range(), but with no limitations on the distance; will search spiralling outwards from the center
//this is used by clockies and lavaland mobs over at the tg one
/proc/spiral_range(dist=0, center=usr, orange=0)
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

//similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs)
/proc/spiral_range_turfs(dist = 0, center=usr, orange  =FALSE, list/outlist = list(), tick_checked)
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

/atom/proc/contains(atom/A)
	if(!A)
		return FALSE
	for(var/atom/location = A.loc, location, location = location.loc)
		if(location == src)
			return TRUE

/proc/flick_overlay_static(O, atom/A, duration)
	set waitfor = 0
	if(!A || !O)
		return
	A.add_overlay(O)
	sleep(duration)
	A.cut_overlay(O)

/proc/get_random_station_turf()
	return safepick(get_area_turfs(pick(all_areas))) //GLOB.the_station_areas

/proc/get_safe_random_station_turf() //excludes dense turfs (like walls) and areas that have valid_territory set to FALSE
	for (var/i in 1 to 5)
		var/list/L = get_area_turfs(pick(all_areas)) // GLOB.the_station_areas
		var/turf/target
		while (L.len && !target)
			var/I = rand(1, L.len)
			var/turf/T = L[I]
			var/area/X = get_area(T)
			if(!T.density && X.valid_territory)
				var/clear = TRUE
				for(var/obj/O in T)
					if(O.density)
						clear = FALSE
						break
				if(clear)
					target = T
			if (!target)
				L.Cut(I, I + 1)
		if (target)
			return target

/proc/get_closest_atom(type, list, source)
	var/closest_atom
	var/closest_distance
	for(var/A in list)
		if(!istype(A, type))
			continue
		var/distance = get_dist(source, A)
		if(!closest_atom)
			closest_distance = distance
			closest_atom = A
		else
			if(closest_distance > distance)
				closest_distance = distance
				closest_atom = A
	return closest_atom

/proc/pick_closest_path(value, list/matches = get_fancy_list_of_atom_types())
	if (value == FALSE) //nothing should be calling us with a number, so this is safe
		value = input("Enter type to find (blank for all, cancel to cancel)", "Search for type") as null|text
		if (isnull(value))
			return
	value = trim(value)
	if(!isnull(value) && value != "")
		matches = filter_fancy_list(matches, value)

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select a type", "Pick Type", matches[1]) as null|anything in matches
		if(!chosen)
			return
	chosen = matches[chosen]
	return chosen

//gives us the stack trace from CRASH() without ending the current proc.
/proc/stack_trace(msg)
	CRASH(msg)

/datum/proc/stack_trace(msg)
	CRASH(msg)

GLOBAL_REAL_VAR(list/stack_trace_storage)
/proc/gib_stack_trace()
	stack_trace_storage = list()
	stack_trace()
	stack_trace_storage.Cut(1, min(3,stack_trace_storage.len))
	. = stack_trace_storage
	stack_trace_storage = null

//Key thing that stops lag. Cornerstone of performance in ss13, Just sitting here, in unsorted.dm.

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(TICK_USAGE, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)

//returns the number of ticks slept
/proc/stoplag(initial_delay)
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	if (!initial_delay)
		initial_delay = world.tick_lag
	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += CEILING(i*DELTA_CALC, 1)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (TICK_USAGE > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC

/proc/flash_color(mob_or_client, flash_color="#960000", flash_time=20)
	var/client/C
	if(ismob(mob_or_client))
		var/mob/M = mob_or_client
		if(M.client)
			C = M.client
		else
			return
	else if(istype(mob_or_client, /client))
		C = mob_or_client

	if(!istype(C))
		return

	var/animate_color = C.color
	C.color = flash_color
	animate(C, color = animate_color, time = flash_time)

#define RANDOM_COLOUR (rgb(rand(0,255),rand(0,255),rand(0,255)))

/proc/random_nukecode()
	var/val = rand(0, 99999)
	var/str = "[val]"
	while(length(str) < 5)
		str = "0" + str
	. = str

/atom/proc/Shake(pixelshiftx = 15, pixelshifty = 15, duration = 250)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	var/shiftx = rand(-pixelshiftx,pixelshiftx)
	var/shifty = rand(-pixelshifty,pixelshifty)
	animate(src, pixel_x = pixel_x + shiftx, pixel_y = pixel_y + shifty, time = 0.2, loop = duration)
	pixel_x = initialpixelx
	pixel_y = initialpixely

/atom/proc/do_jiggle(targetangle = 45, timer = 20)
	var/matrix/OM = matrix(transform)
	var/matrix/M = matrix(transform)
	var/halftime = timer * 0.5
	M.Turn(pick(-targetangle, targetangle))
	animate(src, transform = M, time = halftime, easing = ELASTIC_EASING)
	animate(src, transform = OM, time = halftime, easing = ELASTIC_EASING)

/atom/proc/do_squish(squishx = 1.2, squishy = 0.6, timer = 20)
	var/matrix/OM = matrix(transform)
	var/matrix/M = matrix(transform)
	var/halftime = timer * 0.5
	M.Scale(squishx, squishy)
	animate(src, transform = M, time = halftime, easing = BOUNCE_EASING)
	animate(src, transform = OM, time = halftime, easing = BOUNCE_EASING)

/proc/weightclass2text(w_class)
	switch(w_class)
		if(WEIGHT_CLASS_TINY)
			. = "tiny"
		if(WEIGHT_CLASS_SMALL)
			. = "small"
		if(WEIGHT_CLASS_NORMAL)
			. = "normal-sized"
		if(WEIGHT_CLASS_BULKY)
			. = "bulky"
		if(WEIGHT_CLASS_HUGE)
			. = "huge"
		if(WEIGHT_CLASS_GIGANTIC)
			. = "gigantic"
		else
			. = ""

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

//Version of view() which ignores darkness, because BYOND doesn't have it (I actually suggested it but it was tagged redundant, BUT HEARERS IS A T- /rant).
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center

	GLOB.dview_mob.see_invisible = invis_flags

	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	name = "INTERNAL DVIEW MOB"
	invisibility = 101
	density = FALSE
	see_in_dark = 1e6
	move_resist = INFINITY
	var/ready_to_die = FALSE

/mob/dview/Initialize() //Properly prevents this mob from gaining huds or joining any global lists
	return INITIALIZE_HINT_NORMAL

/mob/dview/Destroy(force = FALSE)
	if(!ready_to_die)
		stack_trace("ALRIGHT WHICH FUCKER TRIED TO DELETE *MY* DVIEW?")

		if (!force)
			return QDEL_HINT_LETMELIVE

		log_world("EVACUATE THE SHITCODE IS TRYING TO STEAL MUH JOBS")
		GLOB.dview_mob = new
	return ..()


#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center;           \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define FOR_DVIEW_END GLOB.dview_mob.loc = null

//can a window be here, or is there a window blocking it?
/proc/valid_window_location(turf/T, dir_to_check)
	if(!T)
		return FALSE
	for(var/obj/O in T)
		if(istype(O, /obj/machinery/door/window) && (O.dir == dir_to_check || dir_to_check == FULLTILE_WINDOW_DIR))
			return FALSE
		if(istype(O, /obj/structure/windoor_assembly))
			var/obj/structure/windoor_assembly/W = O
			if(W.ini_dir == dir_to_check || dir_to_check == FULLTILE_WINDOW_DIR)
				return FALSE
		if(istype(O, /obj/structure/window))
			var/obj/structure/window/W = O
			if(W.ini_dir == dir_to_check || W.ini_dir == FULLTILE_WINDOW_DIR || dir_to_check == FULLTILE_WINDOW_DIR)
				return FALSE
	return TRUE

//There's a good reason we have this. I think.
/proc/pass()
	return
/*
/proc/get_mob_or_brainmob(occupant)
	var/mob/living/mob_occupant

	if(isliving(occupant))
		mob_occupant = occupant

	else if(isbodypart(occupant))
		var/obj/item/bodypart/head/head = occupant

		mob_occupant = head.brainmob

	else if(isorgan(occupant))
		var/obj/item/organ/brain/brain = occupant
		mob_occupant = brain.brainmob

	return mob_occupant
*/

//counts the number of bits in Byond's 16-bit width field
//in constant time and memory!
/proc/BitCount(bitfield)
	var/temp = bitfield - ((bitfield>>1)&46811) - ((bitfield>>2)&37449) //0133333 and 0111111 respectively
	temp = ((temp + (temp>>3))&29127) % 63	//070707
	return temp

//same as do_mob except for movables and it allows both to drift and doesn't draw progressbar
/*
/proc/do_atom(atom/movable/user , atom/movable/target, time = 30, uninterruptible = 0,datum/callback/extra_checks = null)
	if(!user || !target)
		return TRUE
	var/user_loc = user.loc

	var/drifting = FALSE
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = TRUE

	var/target_drifting = FALSE
	if(!target.Process_Spacemove(0) && target.inertia_dir)
		target_drifting = TRUE

	var/target_loc = target.loc

	var/endtime = world.time+time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if(QDELETED(user) || QDELETED(target))
			. = 0
			break
		if(uninterruptible)
			continue

		if(drifting && !user.inertia_dir)
			drifting = FALSE
			user_loc = user.loc

		if(target_drifting && !target.inertia_dir)
			target_drifting = FALSE
			target_loc = target.loc

		if((!drifting && user.loc != user_loc) || (!target_drifting && target.loc != target_loc) || (extra_checks && !extra_checks.Invoke()))
			. = FALSE
			break
*/

//returns a GUID like identifier (using a mostly made up record format)
//guids are not on their own suitable for access or security tokens, as most of their bits are predictable.
//	(But may make a nice salt to one)
/proc/GUID()
	var/const/GUID_VERSION = "b"
	var/const/GUID_VARIANT = "d"
	var/node_id = copytext_char(md5("[rand()*rand(1,9999999)][world.name][world.hub][world.hub_password][world.internet_address][world.address][world.contents.len][world.status][world.port][rand()*rand(1,9999999)]"), 1, 13)

	var/time_high = "[num2hex(text2num(time2text(world.realtime,"YYYY")), 2)][num2hex(world.realtime, 6)]"

	var/time_mid = num2hex(world.timeofday, 4)

	var/time_low = num2hex(world.time, 3)

	var/time_clock = num2hex(TICK_DELTA_TO_MS(world.tick_usage), 3)

	return "{[time_high]-[time_mid]-[GUID_VERSION][time_low]-[GUID_VARIANT][time_clock]-[node_id]}"

// \ref behaviour got changed in 512 so this is necesary to replicate old behaviour.
// If it ever becomes necesary to get a more performant REF(), this lies here in wait
// #define REF(thing) (thing && istype(thing, /datum) && (thing:datum_flags & DF_USE_TAG) && thing:tag ? "[thing:tag]" : "\ref[thing]")
/proc/REF(input)
	if(istype(input, /datum))
		var/datum/thing = input
		if(thing.datum_flags & DF_USE_TAG)
			if(!thing.tag)
				stack_trace("A ref was requested of an object with DF_USE_TAG set but no tag: [thing]")
				thing.datum_flags &= ~DF_USE_TAG
			else
				return "\[[url_encode(thing.tag)]\]"
	return "\ref[input]"

// Makes a call in the context of a different usr
// Use sparingly
/world/proc/PushUsr(mob/M, datum/callback/CB, ...)
	var/temp = usr
	usr = M
	if (length(args) > 2)
		. = CB.Invoke(arglist(args.Copy(3)))
	else
		. = CB.Invoke()
	usr = temp

//Returns a list of all servants of Ratvar and observers.
/*
/proc/servants_and_ghosts()
	. = list()
	for(var/V in GLOB.player_list)
		if(is_servant_of_ratvar(V) || isobserver(V))
			. += V
*/

//datum may be null, but it does need to be a typed var
#define NAMEOF(datum, X) (#X || ##datum.##X)

#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##target, ##var_name, ##var_value)
//dupe code because dm can't handle 3 level deep macros
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##datum, NAMEOF(##datum, ##var), ##var_value)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(length(list_or_datum))
		list_or_datum[var_name] = var_value
		return
	var/datum/D = list_or_datum
	if(IsAdminAdvancedProcCall())
		D.vv_edit_var(var_name, var_value)	//same result generally, unless badmemes
	else
		D.vars[var_name] = var_value
/*
#define	TRAIT_CALLBACK_ADD(target, trait, source) CALLBACK(GLOBAL_PROC, /proc/___TraitAdd, ##target, ##trait, ##source)
#define	TRAIT_CALLBACK_REMOVE(target, trait, source) CALLBACK(GLOBAL_PROC, /proc/___TraitRemove, ##target, ##trait, ##source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitAdd(target,trait,source)
	if(!target || !trait || !source)
		return
	if(islist(target))
		for(var/i in target)
			if(!isatom(i))
				continue
			var/atom/the_atom = i
			ADD_TRAIT(the_atom,trait,source)
	else if(isatom(target))
		var/atom/the_atom2 = target
		ADD_TRAIT(the_atom2,trait,source)

///DO NOT USE ___TraitAdd OR ___TraitRemove as a replacement for ADD_TRAIT / REMOVE_TRAIT defines. To be used explicitly for callback.
/proc/___TraitRemove(target,trait,source)
	if(!target || !trait || !source)
		return
	if(islist(target))
		for(var/i in target)
			if(!isatom(i))
				continue
			var/atom/the_atom = i
			REMOVE_TRAIT(the_atom,trait,source)
	else if(isatom(target))
		var/atom/the_atom2 = target
		REMOVE_TRAIT(the_atom2,trait,source)
*/

//For these two procs refs MUST be ref = TRUE format like typecaches!
/proc/weakref_filter_list(list/things, list/refs)
	if(!islist(things) || !islist(refs))
		return
	if(!refs.len)
		return things
	if(things.len > refs.len)
		var/list/f = list()
		for(var/i in refs)
			var/datum/weakref/r = i
			var/datum/d = r.resolve()
			if(d)
				f |= d
		return things & f

	else
		. = list()
		for(var/i in things)
			if(!refs[WEAKREF(i)])
				continue
			. |= i

/proc/weakref_filter_list_reverse(list/things, list/refs)
	if(!islist(things) || !islist(refs))
		return
	if(!refs.len)
		return things
	if(things.len > refs.len)
		var/list/f = list()
		for(var/i in refs)
			var/datum/weakref/r = i
			var/datum/d = r.resolve()
			if(d)
				f |= d

		return things - f
	else
		. = list()
		for(var/i in things)
			if(refs[WEAKREF(i)])
				continue
			. |= i

/proc/special_list_filter(list/L, datum/callback/condition)
	if(!islist(L) || !length(L) || !istype(condition))
		return list()
	. = list()
	for(var/i in L)
		if(condition.Invoke(i))
			. |= i

/proc/CallAsync(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))

/proc/num2sign(numeric)
	if(numeric > 0)
		return 1
	else if(numeric < 0)
		return -1
	else
		return 0

// Converts browser keycodes to BYOND keycodes.
/proc/browser_keycode_to_byond(keycode)
	keycode = text2num(keycode)
	switch(keycode)
		// letters and numbers
		if(65 to 90, 48 to 57)
			return ascii2text(keycode)
		if(17)
			return "Ctrl"
		if(18)
			return "Alt"
		if(16)
			return "Shift"
		if(37)
			return "West"
		if(38)
			return "North"
		if(39)
			return "East"
		if(40)
			return "South"
		if(45)
			return "Insert"
		if(46)
			return "Delete"
		if(36)
			return "Northwest"
		if(35)
			return "Southwest"
		if(33)
			return "Northeast"
		if(34)
			return "Southeast"
		if(112 to 123)
			return "F[keycode-111]"
		if(96 to 105)
			return "Numpad[keycode-96]"
		if(188)
			return ","
		if(190)
			return "."
		if(189)
			return "-"

//used for list-based spawning(new)
/proc/generate_items_inside(list/items_list, where_to)
	for(var/each_item in items_list)
		for(var/i in 1 to items_list[each_item])
			new each_item(where_to)

//sends a message to chat
//config_setting should be one of the following
//null - noop
//empty string - use TgsTargetBroadcast with admin_only = FALSE
//other string - use TgsChatBroadcast with the tag that matches config_setting, only works with TGS4, if using TGS3 the above method is used
/proc/send2chat(message, config_setting)
	if(config_setting == null)
		return

	UNTIL(GLOB.tgs_initialized)
	if(!world.TgsAvailable())
		return

	var/datum/tgs_version/version = world.TgsVersion()
	if(config_setting == "" || version.suite == 3)
		world.TgsTargetedChatBroadcast(message, FALSE)
		return

	var/list/channels_to_use = list()
	for(var/I in world.TgsChatChannelInfo())
		var/datum/tgs_chat_channel/channel = I
		if(channel.tag == config_setting)
			channels_to_use += channel

	if(channels_to_use.len)
		world.TgsChatBroadcast()

//Checks to see if either the victim has a garlic necklace or garlic in their blood
/proc/blood_sucking_checks(mob/living/carbon/target, check_neck, check_blood)
	//Bypass this if the target isnt carbon.
	if(!iscarbon(target))
		return TRUE
	if(check_neck)
		if(istype(target.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/garlic_necklace))
			return FALSE
	if(check_blood)
		if(target.reagents.has_reagent(/datum/reagent/consumable/garlic))
			return FALSE
	return TRUE

/*
 * Vorestation specific
 */


//Returns: all the areas in the world
/proc/return_areas()
	. = list()
	for(var/area/A in all_areas)
		. += A

//Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	return sortTim(return_areas(), /proc/cmp_area_names_asc)

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world. (or blank list if empty!)
/proc/get_areas(area/areatype)
	if(!areatype) 
		return null
	if(istext(areatype))
		areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = list()
	for(var/area/N in all_areas)
		if(istype(N, areatype))
			. += N

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
//this looks dangerously expensive
/proc/get_area_turfs(area/areatype)
	if(!areatype)
		return null
	if(istext(areatype)) 
		areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = list()
	for(var/area/N in all_areas)
		if(!istype(N, areatype))
			continue
		for(var/turf/T in N) 
			. += T

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all atoms	(objs, turfs, mobs) in areas of that type of that type in the world.
/proc/get_area_all_atoms(area/areatype)
	if(!areatype) 
		return null
	if(istext(areatype)) 
		areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = list()
	for(var/area/N in all_areas)
		if(!istype(N, areatype))
			continue
		for(var/atom/A in N)
			. += A

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

//Takes: Area. Optional: turf type to leave behind.
//Returns: Nothing.
//Notes: Attempts to move the contents of one area to another area.
//       Movement based on lower left corner. Tiles that do not fit
//		 into the new area will not be moved.
/area/proc/move_contents_to(area/A, turftoleave = null, direction = null) //dunno where to ship
	if(!A || !src) 
		return 0

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

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T] //T where T is cords
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					//You can stay, though.
					if(istype(T,/turf/space))
						refined_src -= T
						refined_trg -= B
						continue moving

					var/turf/X //New Destination Turf

					//Are we doing shuttlework? Just to save another type check later.
					var/shuttlework = 0

					//Shuttle turfs handle their own fancy moving.
					if(istype(T,/turf/simulated/shuttle))
						shuttlework = 1
						var/turf/simulated/shuttle/SS = T
						if(!SS.landed_holder) SS.landed_holder = new(turf = SS)
						X = SS.landed_holder.land_on(B)

					//Generic non-shuttle turf move.
					else
						var/old_dir1 = T.dir
						var/old_icon_state1 = T.icon_state
						var/old_icon1 = T.icon
						var/old_underlays = T.underlays.Copy()
						var/old_decals = T.decals ? T.decals.Copy() : null

						X = B.ChangeTurf(T.type)
						X.setDir(old_dir1)
						X.icon_state = old_icon_state1
						X.icon = old_icon1
						X.copy_overlays(T, TRUE)
						X.underlays = old_underlays
						X.decals = old_decals

					//Move the air from source to dest
					var/turf/simulated/ST = T
					if(istype(ST) && ST.zone)
						var/turf/simulated/SX = X
						if(!SX.air)
							SX.make_air()
						SX.air.copy_from(ST.zone.air)
						ST.zone.remove(ST)

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
						if(istype(M, /mob/observer/eye)) continue // If we need to check for more mobs, I'll add a variable
						M.loc = X

						if(z_level_change) // Same goes for mobs.
							M.onTransitZ(T.z, X.z)

						if(istype(M, /mob/living))
							var/mob/living/LM = M
							LM.check_shadow() // Need to check their Z-shadow, which is normally done in forceMove().

					if(shuttlework)
						var/turf/simulated/shuttle/SS = T
						SS.landed_holder.leave_turf()
					else if(turftoleave)
						T.ChangeTurf(turftoleave)
					else
						T.ChangeTurf(get_base_turf_by_area(T))

					refined_src -= T
					refined_trg -= B
					continue moving

/* =dropdown break= */

/proc/get_mob_with_client_list()
	. = list()
	for(var/mob/M in mob_list)
		if(M.client)
			. += M

/proc/get_turf_or_move(turf/location)
	return get_turf(location)


//Quick type checks for some tools
var/global/list/common_tools = list(
/obj/item/stack/cable_coil,
/obj/item/tool/wrench,
/obj/item/weldingtool,
/obj/item/tool/screwdriver,
/obj/item/tool/wirecutters,
/obj/item/multitool,
/obj/item/tool/crowbar)

/proc/istool(O)
	if(O && is_type_in_list(O, common_tools))
		return 1
	return 0


/proc/is_wire_tool(obj/item/I)
	if(istype(I, /obj/item/multitool) || I.is_wirecutter())
		return TRUE
	if(istype(I, /obj/item/assembly/signaler))
		return TRUE
	return

proc/is_hot(obj/item/W as obj)
	switch(W.type)
		if(/obj/item/weldingtool)
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				return 3800
			else
				return 0
		if(/obj/item/flame/lighter)
			if(W:lit)
				return 1500
			else
				return 0
		if(/obj/item/flame/match)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/clothing/mask/smokable/cigarette)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/pickaxe/plasmacutter)
			return 3800
		if(/obj/item/melee/energy)
			return 3500
		else
			return 0

	return 0

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O as obj)
	if(!O)
		return FALSE
	if(O.sharp)
		return TRUE
	if(O.edge)
		return TRUE
	return FALSE

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O as obj)
	if(!O)
		return FALSE
	if(O.edge)
		return TRUE
	return FALSE

//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
/proc/can_puncture(obj/item/W as obj)		// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
	if(!W)
		return FALSE
	if(W.sharp)
		return TRUE
	return ( \
		W.is_screwdriver()		     				              || \
		istype(W, /obj/item/pen)                           || \
		istype(W, /obj/item/weldingtool)					  || \
		istype(W, /obj/item/flame/lighter/zippo)			  || \
		istype(W, /obj/item/flame/match)            		  || \
		istype(W, /obj/item/clothing/mask/smokable/cigarette) 		      || \
		istype(W, /obj/item/shovel) \
	)

/proc/is_surgery_tool(obj/item/W as obj)
	return (	\
	istype(W, /obj/item/surgical/scalpel)			||	\
	istype(W, /obj/item/surgical/hemostat)		||	\
	istype(W, /obj/item/surgical/retractor)		||	\
	istype(W, /obj/item/surgical/cautery)			||	\
	istype(W, /obj/item/surgical/bonegel)			||	\
	istype(W, /obj/item/surgical/bonesetter)
	)

// check if mob is lying down on something we can operate him on.
// The RNG with table/rollerbeds comes into play in do_surgery() so that fail_step() can be used instead.
/proc/can_operate(mob/living/carbon/M)
	return M.lying

// Returns an instance of a valid surgery surface.
/mob/living/proc/get_surgery_surface()
	if(!lying)
		return null // Not lying down means no surface.
	var/obj/surface = null
	for(var/obj/O in loc) // Looks for the best surface.
		if(O.surgery_odds)
			if(!surface || surface.surgery_odds < O)
				surface = O
	if(surface)
		return surface

/proc/reverse_direction(var/dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(NORTHEAST)
			return SOUTHWEST
		if(EAST)
			return WEST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTH)
			return NORTH
		if(SOUTHWEST)
			return NORTHEAST
		if(WEST)
			return EAST
		if(NORTHWEST)
			return SOUTHEAST



/proc/topic_link(var/datum/D, var/arglist, var/content)
	if(istype(arglist,/list))
		arglist = list2params(arglist)
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"

/proc/get_random_colour(var/simple, var/lower=0, var/upper=255)
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


// call to generate a stack trace and print to runtime logs
/proc/crash_with(msg)
	CRASH(msg)


// Displays something as commonly used (non-submultiples) SI units.
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


#define NOT_FLAG(flag) (!(flag & use_flags))
#define HAS_FLAG(flag) (flag & use_flags)

// Checks if user can use this object. Set use_flags to customize what checks are done.
// Returns 0 if they can use it, a value representing why they can't if not.
// Flags are in `code/__defines/misc.dm`
/atom/proc/use_check(mob/user, use_flags = 0, show_messages = FALSE)
	. = 0
	if (NOT_FLAG(USE_ALLOW_NONLIVING) && !isliving(user))
		// No message for ghosts.
		return USE_FAIL_NONLIVING

	if (NOT_FLAG(USE_ALLOW_NON_ADJACENT) && !Adjacent(user))
		if (show_messages)
			to_chat(user, span("notice","You're too far away from [src] to do that."))
		return USE_FAIL_NON_ADJACENT

	if (NOT_FLAG(USE_ALLOW_DEAD) && user.stat == DEAD)
		if (show_messages)
			to_chat(user, span("notice","You can't do that when you're dead."))
		return USE_FAIL_DEAD

	if (NOT_FLAG(USE_ALLOW_INCAPACITATED) && (user.incapacitated()))
		if (show_messages)
			to_chat(user, span("notice","You cannot do that in your current state."))
		return USE_FAIL_INCAPACITATED

	if (NOT_FLAG(USE_ALLOW_NON_ADV_TOOL_USR) && !user.IsAdvancedToolUser())
		if (show_messages)
			to_chat(user, span("notice","You don't know how to operate [src]."))
		return USE_FAIL_NON_ADV_TOOL_USR

	if (HAS_FLAG(USE_DISALLOW_SILICONS) && issilicon(user))
		if (show_messages)
			to_chat(user, span("notice","You need hands for that."))
		return USE_FAIL_IS_SILICON

	if (HAS_FLAG(USE_FORCE_SRC_IN_USER) && !(src in user))
		if (show_messages)
			to_chat(user, span("notice","You need to be holding [src] to do that."))
		return USE_FAIL_NOT_IN_USER

#undef NOT_FLAG
#undef HAS_FLAG

// Returns direction-string, rounded to multiples of 22.5, from the first parameter to the second
// N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
/proc/get_adir(var/turf/A, var/turf/B)
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

//Checks if all high bits in req_mask are set in bitfield
#define BIT_TEST_ALL(bitfield, req_mask) ((~(bitfield) & (req_mask)) == 0)

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
#define RANGE_TURFS(RADIUS, CENTER) \
  block( \
    locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
    locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
  )

//Returns the middle-most value
/proc/dd_range(low, high, num)
	return max(low,min(high,num))

//Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value.
/proc/between(var/low, var/middle, var/high)
	return max(min(middle, high), low)

/proc/LinkBlocked(turf/A, turf/B)
	if(A == null || B == null) 
		return TRUE
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
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
		if(D.dir == SOUTHWEST)// ??
			return TRUE
		if(D.dir == dir)
			return TRUE

	for(var/obj/machinery/door/D in loc)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))
				return TRUE
			if((dir & EAST) && (D.dir & (NORTH|SOUTH)))
				return TRUE
		else 
			return TRUE	// it's a real, air blocking door
	return FALSE

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return TRUE
	return FALSE


#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
/proc/getcircle(turf/center, var/radius) //Uses a fast Bresenham rasterization algorithm to return the turfs in a thin circle.
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

//returns random gauss number
/proc/GaussRand(sigma)
  var/x, y, rsq
  do
    x=2*rand()-1
    y=2*rand()-1
    rsq=x*x+y*y
  while(rsq>1 || !rsq)
  return sigma*y*sqrt(-2*log(rsq)/rsq)

//returns random gauss number, rounded to 'roundto'
/proc/GaussRandRound(sigma, roundto)
	return round(GaussRand(sigma), roundto)


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

//Returns a list of all mobs with their name
/proc/getmobs()

	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
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
