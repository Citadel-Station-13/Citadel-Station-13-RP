//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
#define RANGE_TURFS(RADIUS, CENTER) \
  block( \
    locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
    locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
  )

/proc/get_area_name(atom/X, format_text = FALSE, get_base_area = FALSE)
	var/area/A = get_area(X) //get_base_area ? get_base_area(X) : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name

/proc/get_areas_in_range(dist = 0, atom/center = usr)
	if(!dist)
		var/turf/T = get_turf(center)
		return T ? list(T.loc) : list()
	if(!center)
		return list()

	var/list/turfs = RANGE_TURFS(dist, center)
	var/list/areas = list()
	for(var/V in turfs)
		var/turf/T = V
		areas |= T.loc
	return areas

/proc/get_adjacent_areas(atom/center)
	. = list(get_area(get_ranged_target_turf(center, NORTH, 1)),
			get_area(get_ranged_target_turf(center, SOUTH, 1)),
			get_area(get_ranged_target_turf(center, EAST, 1)),
			get_area(get_ranged_target_turf(center, WEST, 1)))
	listclearnulls(.)

/proc/get_open_turf_in_dir(atom/center, dir)
	var/turf/simulated/open/T = get_ranged_target_turf(center, dir, 1)
	if(istype(T))
		return T

/proc/get_adjacent_open_areas(atom/center)
	. = list()
	var/list/adjacent_turfs = get_adjacent_open_turfs(center)
	for(var/I in adjacent_turfs)
		. |= get_area(I)

/proc/get_adjacent_open_turfs(atom/center)
	. = list(get_open_turf_in_dir(center, NORTH),
			get_open_turf_in_dir(center, SOUTH),
			get_open_turf_in_dir(center, EAST),
			get_open_turf_in_dir(center, WEST))
	listclearnulls(.)

// Like view but bypasses luminosity check

/proc/get_hear(range, atom/source)
	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard
/* !!COMPATABILITY, DO NOT USE!! */
/proc/hear(range, atom/source)
	return get_hear(range, source)

/proc/alone_in_area(area/the_area, mob/must_be_alone, check_type = /mob/living/carbon)
	var/area/our_area = get_area(the_area)
	for(var/C in human_mob_list) //GLOB.alive_mob_list)
		if(!istype(C, check_type))
			continue
		if(C == must_be_alone)
			continue
		if(our_area == get_area(C))
			return FALSE
	return TRUE

//We used to use linear regression to approximate the answer, but Mloc realized this was actually faster.
//And lo and behold, it is, and it's more accurate to boot.
/proc/cheap_hypotenuse(Ax, Ay, Bx, By)
	return sqrt(abs(Ax - Bx)**2 + abs(Ay - By)**2) //A squared + B squared = C squared

/proc/circlerange(center = usr, radius = 3)
	var/turf/centerturf = get_turf(center)
	var/list/turfs = list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center = usr, radius = 3)
	var/turf/centerturf = get_turf(center)
	var/list/atoms = list()
	var/rsq = radius * (radius + 0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

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

/proc/circleviewturfs(center = usr, radius = 3)	//Is there even a diffrence between this proc and circlerangeturfs()?
	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs

/** recursive_organ_check
  * inputs: O (object to start with)
  * outputs:
  * description: A pseudo-recursive loop based off of the recursive mob check, this check looks for any organs held
  *				 within 'O', toggling their frozen flag. This check excludes items held within other safe organ
  *				 storage units, so that only the lowest level of container dictates whether we do or don't decompose
  */
/*
/proc/recursive_organ_check(atom/O)
	var/list/processing_list = list(O)
	var/list/processed_list = list()
	var/index = 1
	var/obj/item/organ/found_organ

	while(index <= length(processing_list))
		var/atom/A = processing_list[index]

		if(istype(A, /obj/item/organ))
			found_organ = A
			found_organ.organ_flags ^= ORGAN_FROZEN

		else if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/Q = A
			for(var/organ in Q.internal_organs)
				found_organ = organ
				found_organ.organ_flags ^= ORGAN_FROZEN

		for(var/atom/B in A)	//objects held within other objects are added to the processing list, unless that object is something that can hold organs safely
			if(!processed_list[B] && !istype(B, /obj/structure/closet/crate/freezer) && !istype(B, /obj/structure/closet/secure_closet/freezer))
				processing_list+= B

		index++
		processed_list[A] = A

	return
*/
// Better recursive loop, technically sort of not actually recursive cause that shit is stupid, enjoy.
//No need for a recursive limit either
/*
/proc/recursive_mob_check(atom/O, client_check = TRUE, sight_check = TRUE, include_radio = TRUE)
	var/list/processing_list = list(O)
	var/list/processed_list = list()
	var/list/found_mobs = list()

	while(processing_list.len)
		var/atom/A = processing_list[1]
		var/passed = FALSE

		if(ismob(A))
			var/mob/A_tmp = A
			passed = TRUE
			if(client_check && !A_tmp.client)
				passed = FALSE
			if(sight_check && !isInSight(A_tmp, O))
				passed = FALSE

		else if(include_radio && istype(A, /obj/item/radio))
			passed = TRUE

			if(sight_check && !isInSight(A, O))
				passed = FALSE

		if(passed)
			found_mobs |= A

		for(var/atom/B in A)
			if(!processed_list[B])
				processing_list |= B

		processing_list.Cut(1, 2)
		processed_list[A] = A

	return found_mobs
*/

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
		if(A.flags & HEAR)
			. += A
			SEND_SIGNAL(A, COMSIG_ATOM_HEARER_IN_VIEW, processing, .)
		processing += A.contents

//viewers() but with a signal, for blacklisting.
/*
/proc/fov_viewers(depth = world.view, atom/center)
	if(!center)
		return
	. = viewers(depth, center)
	for(var/k in .)
		var/mob/M = k
		SEND_SIGNAL(M, COMSIG_MOB_FOV_VIEWER, center, depth, .)
*/

/proc/get_mobs_in_radio_ranges(list/radios)
	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	for(var/obj/item/radio/R in radios)
		if(R)
			. |= get_hearers_in_view(R.canhear_range, R)

#define SIGNV(X) ((X<0)?-1:1)

/proc/inLineOfSight(X1, Y1, X2, Y2, Z = 1, PX1 = 16.5, PY1 = 16.5, PX2 = 16.5, PY2 = 16.5)
	var/turf/T
	if(X1 == X2)
		if(Y1 == Y2)
			return TRUE //Light cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1 += s
			while(Y1!=Y2)
				T = locate(X1,Y1,Z)
				if(T.opacity)
					return FLASH_PROTECTION_MAJOR
				Y1 += s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIGN(X2-X1)
		var/signY = SIGN(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.opacity)
				return 0
	return 1
#undef SIGNV

/proc/isInSight(atom/A, atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return FALSE

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return TRUE

	else
		return FALSE

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs(dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/try_move_adjacent(atom/movable/AM)
	var/turf/T = get_turf(AM)
	for(var/direction in GLOB.cardinals)
		if(AM.Move(get_step(T, direction)))
			break

/proc/get_mob_by_key(key)
	var/ckey = ckey(key)
	for(var/i in mob_list) //GLOB.player_list)
		var/mob/M = i
		if(M.ckey == ckey)
			return M
	return null
/*
/proc/considered_alive(datum/mind/M, enforce_human = TRUE)
	if(M && M.current)
		if(enforce_human)
			var/mob/living/carbon/human/H
			if(ishuman(M.current))
				H = M.current
			return M.current.stat != DEAD && !issilicon(M.current) && !isbrain(M.current) && (!H || H.dna.species.id != "memezombies")
		else if(isliving(M.current))
			return M.current.stat != DEAD
	return FALSE
*/
/*
/proc/considered_afk(datum/mind/M)
	return !M || !M.current || !M.current.client || M.current.client.is_afk()
*/
/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))
		O = new /obj/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I

/proc/flick_overlay(image/I, list/show_to, duration)
	for(var/client/C in show_to)
		C.images += I
	addtimer(CALLBACK(GLOBAL_PROC, /proc/remove_images_from_clients, I, show_to), duration, TIMER_CLIENT_TIME)

/proc/flick_overlay_view(image/I, atom/target, duration) //wrapper for the above, flicks to everyone who can see the target atom
	var/list/viewing = list()
	for(var/m in viewers(target))
		var/mob/M = m
		if(M.client)
			viewing += M.client
	flick_overlay(I, viewing, duration)
/*
/proc/get_active_player_count(alive_check = FALSE, afk_check = FALSE, human_check = FALSE)
	// Get active players who are playing in the round
	. = 0
	for(var/mob/M in player_list) //not yet GLOB.
		if(M && M.client)
			if(alive_check && M.stat)
				continue
			else if(afk_check && M.client.is_afk())
				continue
			else if(human_check && !ishuman(M))
				continue
			else if(isnewplayer(M)) // exclude people in the lobby
				continue
			else if(isobserver(M)) // Ghosts are fine if they were playing once (didn't start as observers)
				var/mob/dead/observer/O = M
				if(O.started_as_observer) // Exclude people who started as observers
					continue
			.++ //magic(not)
*/
/* Insert better pollcode for ghosts here */
/*
/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new //The mob being spawned.
	//SSjob.SendToLateJoin(new_character) //does not exist yet

	G_found.client.prefs.copy_to(new_character)
	//new_character.dna.update_dna_identity()
	new_character.dna.ResetUIFrom(new_character)
	new_character.sync_organ_dna()
	G_found.transfer_ckey(new_character, FALSE)

	return new_character
*/
/proc/send_to_playing_players(thing) //sends a whatever to all playing players; use instead of to_chat(world, where needed)
	for(var/M in player_list) //not GLOB.
		if(M && !isnewplayer(M))
			to_chat(M, thing)

/proc/window_flash(client/C, ignorepref = FALSE)
	if(ismob(C))
		var/mob/M = C
		if(M.client)
			C = M.client
	if(!C) //|| (!C.prefs.windowflashing && !ignorepref))
		return
	winset(C, "mainwindow", "flash=5")

//Recursively checks if an item is inside a given type, even through layers of storage. Returns the atom if it finds it.
/proc/recursive_loc_check(atom/movable/target, type)
	var/atom/A = target
	if(istype(A, type))
		return A

	while(!istype(A.loc, type))
		if(!A.loc)
			return
		A = A.loc

	return A.loc

/proc/AnnounceArrival(mob/living/carbon/human/character, rank, join_message = "will arrive at the station shortly")
	if(SSticker.current_state != GAME_STATE_PLAYING || QDELETED(character))
		return
	var/area/A = get_area(character)
	var/message = "<span class='game deadsay'><span class='name'>\
		[character.real_name]</span> ([rank]) has arrived at the station at \
		<span class='name'>[A.name]</span>.</span>"
	say_dead_direct(message, follow_target = character)
	//deadchat_broadcast(message, follow_target = character, message_type=DEADCHAT_ARRIVALRATTLE)
	if((!global_announcer) || (!character.mind)) //GLOB.announcement_systems.len
		return
	if((character.mind.assigned_role == "Cyborg") || (character.mind.assigned_role == character.mind.special_role))
		return
	if(character.mind.role_alt_title) //vorestation specific
		rank = character.mind.role_alt_title

	//"%PERSON, %RANK, will arrive at the station shortly"
	global_announcer.autosay("[character.real_name], [rank], [join_message].", "Arrivals Announcement Computer")
	//var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
	//announcer.announce("ARRIVAL", character.real_name, rank, list()) //make the list empty to make it announce it in common

/proc/GetHexColors(const/hexa) //anyone know why this gets divided by 255 over at tg?
	return list(
			GetRedPart(hexa),
			GetGreenPart(hexa),
			GetBluePart(hexa)
		)

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa,6,8))

/* lavaland thing */

/* pipewire thing */
/*
// Find a obstruction free turf that's within the range of the center. Can also condition on if it is of a certain area type.
/proc/find_obstruction_free_location(range, atom/center, area/specific_area)
	var/list/turfs = RANGE_TURFS(range, center)
	var/list/possible_loc = list()
	for(var/turf/found_turf in turfs)
		var/area/turf_area = get_area(found_turf)
		if(specific_area)	// We check if both the turf is a floor, and that it's actually in the area. // We also want a location that's clear of any obstructions.
			if(!istype(turf_area, specific_area))
				continue
		if(!isspaceturf(found_turf))
			if(!is_blocked_turf(found_turf))
				possible_loc.Add(found_turf)
	if(possible_loc.len < 1)	// Need at least one free location.
		return FALSE
	return pick(possible_loc)
*/

/* power fail on the station's z's*/

/*
 * ==================================
 *    VORESTATION SPECIFICS
 * ==================================
 */
//OLDCODE BEGIN
// HEY! Upgrade these vote code!
// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/get_active_candidates(buffer = 1)
	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in player_list)
			if(((G.client.inactivity/10)/60) <= buffer + i) // the most active players are more likely to become an alien
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		i++
	return candidates

// Same as above but for alien candidates.
/proc/get_alien_candidates()
	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in player_list)
			if(G.client.prefs.be_special & BE_ALIEN)
				if(((G.client.inactivity/10)/60) <= ALIEN_SELECT_AFK_BUFFER + i) // the most active players are more likely to become an alien
					if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
						candidates += G.key
		i++
	return candidates

//OLDCODE END

//var/debug_mob = FALSE

/proc/get_area_master(O)
	var/area/A = get_area(O)
	if(isarea(A))
		return A

/** Checks if any living humans are in a given area. */
/proc/area_is_occupied(area/myarea)
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.stat >= DEAD) //Conditions for exclusion here, like if disconnected people start blocking it.
			continue
		var/area/A = get_area(H)
		if(A == myarea) //The loc of a turf is the area it is in.
			return TRUE
	return FALSE

/proc/isStationLevel(level)
	return (level in GLOB.using_map.station_levels)

/proc/isPlayerLevel(level)
	return (level in GLOB.using_map.player_levels)

/proc/isAdminLevel(level)
	return (level in GLOB.using_map.admin_levels)
//defines instead of proc for tiny speed boost
#define isNotAdminLevel(level) (!isAdminLevel(level))
#define isNotStationLevel(level) (!isStationLevel(level))

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

/proc/Show2Group4Delay(obj/O, list/group, delay=0)
	if(!isobj(O))
		return
	if(!group)	group = GLOB.clients
	for(var/client/C in group)
		C.screen += O
	if(delay)
		spawn(delay)
			for(var/client/C in group)
				C.screen -= O


// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_content_check(var/atom/O,  var/list/L = list(), var/recursion_limit = 3, var/client_check = 1, var/sight_check = 1, var/include_mobs = 1, var/include_objects = 1, var/ignore_show_messages = 0)
	if(!recursion_limit)
		return L

	for(var/I in O.contents)
		//can just solve this with recursive_loc_check(O, /mob/)
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

// Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.

/proc/get_mobs_or_objects_in_view(var/R, var/atom/source, var/include_mobs = 1, var/include_objects = 1)

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

/* expensive and bad
/proc/get_mobs_in_radio_ranges(var/list/obj/item/radio/radios)
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
	for(var/i = 1; i <= player_list.len; i++)
		var/mob/M = player_list[i]
		if(M)
			var/turf/ear = get_turf(M)
			if(ear)
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (istype(M, /mob/observer/dead) && M.is_preference_enabled(/datum/client_preference/ghost_radio)))
					. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .
*/


//Uses dview to quickly return mobs and objects in view,
// then adds additional mobs or objects if they are in range 'smartly',
// based on their presence in lists of players or registered objects
// Type: 1-audio, 2-visual, 0-neither
/proc/get_mobs_and_objs_in_view_fast(var/turf/T, var/range, var/type = 1, var/remote_ghosts = TRUE)
	var/list/mobs = list()
	var/list/objs = list()

	var/list/hear = dview(range,T,INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/thing in hear)
		if(istype(thing,/obj))
			objs += thing
			hearturfs |= get_turf(thing)
		else if(istype(thing,/mob))
			mobs += thing
			hearturfs |= get_turf(thing)

	//A list of every mob with a client
	for(var/mob in player_list)
		//VOREStation Edit - Trying to fix some vorestation bug.
		if(!istype(mob, /mob))
			player_list -= mob
			crash_with("There is a null or non-mob reference inside player_list ([mob]).")
			continue
		//VOREStation Edit End - Trying to fix some vorestation bug.
		if(get_turf(mob) in hearturfs)
			mobs |= mob
			continue

		var/mob/M = mob
		if(M && M.stat == DEAD && remote_ghosts && !M.forbid_seeing_deadchat)
			switch(type)
				if(1) //Audio messages use ghost_ears
					if(M.is_preference_enabled(/datum/client_preference/ghost_ears))
						mobs |= M
				if(2) //Visual messages use ghost_sight
					if(M.is_preference_enabled(/datum/client_preference/ghost_sight))
						mobs |= M

	//For objects below the top level who still want to hear
	for(var/obj in listening_objects)
		if(get_turf(obj) in hearturfs)
			objs |= obj

	return list("mobs" = mobs, "objs" = objs)

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

/proc/mixOneColor(var/list/weight, var/list/color)
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

	//until someone writes a formal proof for this algorithm, let's keep this in
//	if(mixedcolor<0x00 || mixedcolor>0xFF)
//		return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
* Gets the highest and lowest pressures from the tiles in cardinal directions
* around us, then checks the difference.
*/
/proc/getOPressureDifferential(turf/loc)
	var/minp = 16777216;
	var/maxp = 0;
	for(var/dir in GLOB.cardinals)
		var/turf/simulated/T = get_turf(get_step(loc,dir))
		var/cp = 0
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T, /turf/simulated))
				continue
		if(cp < minp)
			minp = cp
		if(cp > maxp)
			maxp = cp
	return abs(minp-maxp)

/proc/convert_k2c(temp)
	return ((temp - T0C))

/proc/convert_c2k(temp)
	return ((temp + T0C))

/proc/getCardinalAirInfo(turf/loc, list/stats=list("temperature"))
	var/list/temps = new/list(4)
	for(var/dir in GLOB.cardinals)
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

/proc/MinutesToTicks(ds)
	return ds MINUTES

/proc/SecondsToTicks(ds) //this isn't ticks, this is desiseconds.
	return ds SECONDS

/proc/dopage(src, target)
	var/href_list = params2list("src=[REF(src)]&[target]=1")
	var/href = "src=[REF(src)];[target]=1"
	src:temphtml = null
	src:Topic(href, href_list)
	return null

/proc/is_on_same_plane_or_station(z1, z2)
	if(z1 == z2)
		return TRUE
	if((z1 in GLOB.using_map.station_levels) &&	(z2 in GLOB.using_map.station_levels))
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
	if(isarea(A))
		return A
	var/turf/T = get_turf(A)
	return T ? T.loc : null

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

	// returns the destination (Vx,y) that a projectile shot at [src_x], [src_y], with an angle of [angle],
	// rotated at [rotation] and with the power of [power]
	// Thanks to VistaPOWA for this function
/proc/projectile_trajectory(src_x, src_y, rotation, angle, power)
	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = 2* power_y / 10 //10 = g

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)
