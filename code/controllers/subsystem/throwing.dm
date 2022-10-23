SUBSYSTEM_DEF(throwing)
	name = "Throwing"
	priority = FIRE_PRIORITY_THROWING
	wait = 1
	subsystem_flags = SS_NO_INIT | SS_KEEP_TIMING | SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun
	var/list/processing = list()

/datum/controller/subsystem/throwing/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/throwing/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/atom/movable/AM = currentrun[currentrun.len]
		var/datum/thrownthing/TT = currentrun[AM]
		currentrun.len--
		if (QDELETED(AM) || QDELETED(TT))
			processing -= AM
			if (MC_TICK_CHECK)
				return
			continue

		TT.tick()

		if (MC_TICK_CHECK)
			return

	currentrun = null

/datum/thrownthing
	//! important stuff
	/// thing we threw
	var/atom/movable/thrownthing
	/// flags
	var/throw_flags = NONE
	/// things we impacted already. associative list for speed.
	var/list/impacted
	/// thing we originally were thrown at
	var/atom/target
	/// turf our original target was on at original time of throw
	var/turf/target_turf
	/// turf we initially started from
	var/turf/initial_turf
	/// initial byond get_dir from thrown thing to target
	var/init_dir
	/// max tiles we can travel
	var/maxrange
	/// tiles to move per decisecond
	var/speed
	/// what threw us
	var/atom/thrower
	/// how hard were we thrown?
	var/force
	/// original throw resist
	var/resist
	/// callback to call when we hit something. called with (hit atom, thrownthing datum)
	var/datum/callback/on_hit
	/// callback to call when we land. will not be called if we do not land on anything. called with (landed atom, thrownthing datum)
	var/datum/callback/on_land
	/// paused?
	var/paused = FALSE

	//! processing vars
	/// have we started yet
	var/started = FALSE
	/// are we done
	var/finished = FALSE
	/// world.time we started
	var/start_time
	/// tiles we travelled
	var/dist_travelled = 0
	/// how long we've been paused for
	var/delayed_time = 0
	/// last world.time we moved
	var/last_move = 0
	/// dx of original throw target
	var/dist_x
	/// dy of original throw target
	var/dist_y
	/// x dir
	var/dx
	/// y dir
	var/dy
	/// tracks diagonal error so we move in a relatively "raycasted" (shittily) path
	var/diagonal_error
	/// are we purely diagonal?
	var/pure_diagonal

	//! fluff shit players use to kill each other
	/// zone selected by user at time of throw
	var/target_zone
	/// damage multiplier
	var/damage_multiplier = 1

/datum/thrownthing/New(atom/movable/AM, atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force)
	src.thrownthing = AM
	if(!target_atom(target))
		qdel(src)
		return
	// todo: multiz throws
	src.maxrange = range
	src.speed = speed
	src.throw_flags = flags
	src.thrower = thrower
	src.on_hit = on_hit
	src.on_land = on_land
	src.force = force
	src.resist = AM.throw_resist
	impacted = list()

/datum/thrownthing/proc/target_atom(atom/target)
	src.target = target
	var/turf/T = get_turf(target)
	var/atom/movable/AM = thrownthing
	if(!T)
		CRASH("tried to throw something at something that wasn't in the game world.")
	target_turf = T
	T = get_turf(AM)
	if(!T)
		CRASH("tried to throw something that wasn't in the game world at something")
	if(!initial_turf)
		initial_turf = T
	init_dir = get_dir(thrownthing, target)

	dist_x = abs(target_turf.x - AM.x)
	dist_y = abs(target_turf.y - AM.y)
	dx = (target_turf.x > AM.x)? EAST : WEST
	dy = (target_turf.y > AM.y)? NORTH : SOUTH

	if(dist_x == dist_y)
		pure_diagonal = TRUE
	else if(dist_x <= dist_y)
		// standardization: i honestly don't understand why we do this but we do this, thanks MSO
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	diagonal_error = dist_x / 2 - dist_y
	return TRUE

/datum/thrownthing/Destroy()
	if(!finished)
		terminate(TRUE)
	if(thrownthing)
		SSthrowing.processing -= thrownthing
		thrownthing.throwing = null
		thrownthing = null
	target = null
	thrower = null
	on_hit = null
	on_land = null
	initial_turf = null
	target_turf = null
	impacted = null
	return ..()

/datum/thrownthing/proc/tick()
	SHOULD_NOT_SLEEP(TRUE)
	var/atom/movable/AM = thrownthing
	// if throwing got cancelled maybe like, don't
	if(!isturf(AM.loc) || !AM.throwing)
		terminate()
		return

	if(paused)
		delayed_time += world.time - last_move
		return

	//calculate how many tiles to move, making up for any missed ticks.
	var/tilestomove = CEILING(min(((((world.time+world.tick_lag) - start_time + delayed_time) * speed) - (dist_travelled ? dist_travelled : -1)), speed*MAX_TICKS_TO_MAKE_UP) * (world.tick_lag * SSthrowing.wait), 1)

	// catch anything in our tile
	//? experimental: removed in favor for cross/bump hooks
	/*
	if(dist_travelled)
		var/atom/to_hit = scan_for_impact(get_turf(AM))
		while(to_hit)
			impact(to_hit)
			if(finished)
				return
			to_hit = scan_for_impact(get_turf(AM))
	*/

	var/atom/stepping
	last_move = world.time
	while(tilestomove-- > 0)
		// if we have gravity we can end, else keep going
		if(AM.has_gravity())
			if(dist_travelled >= maxrange || AM.loc == target_turf)
				terminate()
				return
		else if(dist_travelled >= MAX_THROWING_DIST)
			terminate()
			return

		// if we havne't reached target yet
		if(dist_travelled <= max(dist_x, dist_y))
			// home in
			stepping = get_step(AM, get_dir(AM, target_turf))
		else
			// just go init dir, diagonal error solves the rest
			stepping = get_step(AM, init_dir)

		// solve diagonal error
		if(!pure_diagonal)
			// checks for tile before so we don't raycast past it
			if(diagonal_error >= 0 && (max(dist_x, dist_y) - dist_travelled != 1))
				stepping = get_step(AM, dx)
			diagonal_error += (diagonal_error < 0)? (dist_x / 2) : -dist_y

		// if we're out of tiles.. don't run out of the map
		if(!stepping)
			land()
			return

	//? Experimental: Do not try to hit before movement, instead let cross/whatnot hooks handle it
/*
		var/atom/to_hit = scan_for_impact(stepping)
		while(to_hit)
			impact(to_hit)
			if(finished)
				return
			to_hit = scan_for_impact(stepping)
*/

		AM.Move(stepping, get_dir(AM, stepping))

		// atom somehow got deleted
		if(QDELETED(AM))
			terminate()
			return

		// we hit something during move
		if(finished)
			return

		// tick up dist moved
		++dist_travelled

/**
 * hook for making us impact things on bump (we cross them)
 */
/datum/thrownthing/proc/bump_into(atom/A)
	// if you sleep, eat shit
	set waitfor = FALSE
	if(!can_hit(A, TRUE))
		return
	impact(A)

/**
 * hook for making us impact thing on cross (they cross us)
 */
/datum/thrownthing/proc/crossed_by(atom/movable/AM)
	// if you sleep, eat shit
	set waitfor = FALSE
	if(!can_hit(AM))
		return
	impact(AM)

/datum/thrownthing/proc/scan_for_impact(turf/T)
	RETURN_TYPE(/atom)
	var/atom/highest
	for(var/atom/thing as anything in T)
		if(!can_hit(thing))
			continue
		if(!highest || highest.layer < thing.layer)
			highest = thing
	return highest

/datum/thrownthing/proc/can_hit(atom/A, bumping)
	if((throw_flags & THROW_AT_OVERHAND) && (A != target) && A.check_pass_flags_self(ATOM_PASS_OVERHEAD_THROW))
		return FALSE
	if(A == thrownthing)
		return FALSE
	if(A == thrower)
		return FALSE
	if(impacted[A])
		return FALSE
	if(!bumping && thrownthing.CanPass(A, get_turf(thrownthing)))
		return FALSE
	return TRUE

/**
 * quickstart - immediately tick the first tick
 */
/datum/thrownthing/proc/quickstart()
	if(throw_flags & THROW_AT_QUICKSTARTED)
		return
	throw_flags |= THROW_AT_QUICKSTARTED
	tick(1)

/**
 * start - register to subsystem
 */
/datum/thrownthing/proc/start()
	if(started)
		CRASH("double start")
	start_time = world.time
	started = TRUE

	SSthrowing.processing[thrownthing] = src
	if(SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[thrownthing] = src

	if(!(throw_flags & THROW_AT_NO_AUTO_QUICKSTART))
		quickstart()

/**
 * handle impacting an atom
 * return TRUE if we should end the throw, FALSE to pierce
 */
/datum/thrownthing/proc/impact(atom/A, in_land)
	impacted[A] = TRUE

	var/op_return = thrownthing._throw_do_hit(A, src)
	if(op_return & COMPONENT_THROW_HIT_TERMINATE)
		terminate()
		return

	on_hit?.InvokeAsync(A, src)

	if(!(op_return & COMPONENT_THROW_HIT_PIERCE) && !in_land)
		land(get_turf(thrownthing))
		return

	// we are piercing. move again.
	tick(1)

/**
 * land on something and terminate the throw
 */
/datum/thrownthing/proc/land(atom/A = get_turf(thrownthing))
	// nothing to land on
	if(!A)
		terminate()
		return

	// hit our target if we haven't already
	if(!impacted[target] && (target in get_turf(A)))
		impact(target, TRUE)

	// land
	thrownthing._throw_finalize(A, src)
	on_land?.InvokeAsync(A, src)

	// halt
	terminate()

/**
 * terminate the throw.
 * when called, immediately erases the throw from the atom and stops it.
 */
/datum/thrownthing/proc/terminate(in_qdel)
	finished = TRUE
	thrownthing.throwing = null
	if(!QDELETED(thrownthing))
		// move
		addtimer(CALLBACK(thrownthing, /atom/movable/proc/newtonian_move, init_dir), 1)
		addtimer(CALLBACK(thrownthing, /atom/movable/proc/fall), 1)
	if(in_qdel)
		return
	qdel(src)


/**
 * should we skip damage entirely?
 */
/datum/thrownthing/proc/is_pacifistic()
	return throw_flags & THROW_AT_IS_GENTLE

/**
 * get damage scaling - default handling
 */
/datum/thrownthing/proc/get_damage_multiplier()
	if(!resist)
		return MAX_THROWING_DAMAGE_MULTIPLIER
	. = damage_multiplier
	if(thrownthing.movable_flags & MOVABLE_NO_THROW_DAMAGE_SCALING)
		return
	if(throw_flags & THROW_AT_NO_SCALE_DAMAGE)
		return
	// multiplier = force > resist? (force / resist) ** (p * 0.1) : 1 / (force / resist) ** (p * 0.1)
	if(isnull(force))
		. *= speed > resist? (speed / resist) ** (thrownthing.throw_damage_scaling_exponential * 0.1) : 1 / (speed / resist) ** (thrownthing.throw_damage_scaling_exponential * 0.1)
	. *= force > resist? (force / resist) ** (thrownthing.throw_damage_scaling_exponential * 0.1) : 1 / (force / resist) ** (thrownthing.throw_damage_scaling_exponential * 0.1)

/**
 * simulated thrownthing datums
 * doesn't register to subsystem
 * immediately hits and deletes on start
 */
/datum/thrownthing/emulated

/datum/thrownthing/emulated/start()
	return		// you must manually quickstart

/datum/thrownthing/emulated/quickstart()
	if(throw_flags & THROW_AT_QUICKSTARTED)
		return
	throw_flags |= THROW_AT_QUICKSTARTED
	process_hit()

/datum/thrownthing/emulated/proc/process_hit()
	// hit without landing
	impact(target, TRUE)
	// gtfo
	terminate()
