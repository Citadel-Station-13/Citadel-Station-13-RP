#define MAX_THROWING_DIST 1280 // 5 z-levels on default width
#define MAX_TICKS_TO_MAKE_UP 3 //how many missed ticks will we attempt to make up for this run.

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
	/// are we started?
	var/started = FALSE
	/// are we finished? this should be true if we're qdeling in general
	/// things we impacted already. associative list for speed.
	var/list/impacted = list()
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
	/// world.time we started
	var/start_time
	/// tiles we travelled
	var/dist_travelled = 0
	/// callback to call when we hit something. called with (hit atom, thrownthing datum)
	var/datum/callback/on_hit
	/// callback to call when we land. will not be called if we do not land on anything. called with (landed atom, thrownthing datum)
	var/datum/callback/on_land
	/// paused?
	var/paused = FALSE
	/// how long we've been paused for
	var/delayed_time = 0
	/// last world.time we moved
	var/last_move = 0

	var/dist_x
	var/dist_y
	var/dx
	var/dy
	var/diagonal_error
	var/pure_diagonal

	//! fluff shit players use to kill each other
	var/target_zone

/datum/thrownthing/New(atom/movable/AM, atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land)
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




	#warn finish

/datum/thrownthing/proc/target_atom(atom/target)
	src.target = target
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("tried to throw something at something that wasn't in the game world.")
	target_turf = T
	T = get_turf(AM)
	if(!T)
		CRASH("tried to throw something that wasn't in the game world at something")
	if(!initial_turf)
		initial_turf = T
	init_dir = get_dir(thrownthing, target)
	return TRUE

/datum/thrownthing/New()
	dist_x = abs(target.x - thrownthing.x)
	dist_y = abs(target.y - thrownthing.y)
	dx = (target.x > thrownthing.x) ? EAST : WEST
	dy = (target.y > thrownthing.y) ? NORTH : SOUTH//same up to here

	if (dist_x == dist_y)
		pure_diagonal = TRUE

	else if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx

	diagonal_error = dist_x/2 - dist_y

	start_time = world.time

/datum/thrownthing/Destroy()
	if(!finished)
		terminate(TRUE)
	SSthrowing.processing -= thrownthing
	thrownthing.throwing = null
	thrownthing = null
	target = null
	thrower = null
	callback = null
	return ..()

/datum/thrownthing/proc/tick()
	SHOULD_NOT_SLEEP(TRUE)
	var/atom/movable/AM = thrownthing
	// if throwing got cancelled maybe like, don't
	if(!isturf(AM.loc) || !AM.throwing)
		terminate()
		return

#warn impl

	if (!isturf(AM.loc) || !AM.throwing)
		finalize()
		return

	if(paused)
		delayed_time += world.time - last_move
		return

	if (dist_travelled && hitcheck(get_turf(thrownthing))) //to catch sneaky things moving on our tile while we slept
		finalize()
		return

	var/area/A = get_area(AM.loc)
	var/atom/step

	last_move = world.time

	//calculate how many tiles to move, making up for any missed ticks.
	var/tilestomove = CEILING(min(((((world.time+world.tick_lag) - start_time + delayed_time) * speed) - (dist_travelled ? dist_travelled : -1)), speed*MAX_TICKS_TO_MAKE_UP) * (world.tick_lag * SSthrowing.wait), 1)
	while (tilestomove-- > 0)
		if ((dist_travelled >= maxrange || AM.loc == target_turf) && (A && A.has_gravity()))
			finalize()
			return

		if (dist_travelled <= max(dist_x, dist_y)) //if we haven't reached the target yet we home in on it, otherwise we use the initial direction
			step = get_step(AM, get_dir(AM, target_turf))
		else
			step = get_step(AM, init_dir)

		if (!pure_diagonal) // not a purely diagonal trajectory and we don't want all diagonal moves to be done first
			if (diagonal_error >= 0 && max(dist_x,dist_y) - dist_travelled != 1) //we do a step forward unless we're right before the target
				step = get_step(AM, dx)
			diagonal_error += (diagonal_error < 0) ? dist_x/2 : -dist_y

		if (!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			var/turf/T = loc

			return

		if (hitcheck(step))
			finalize()
			return

		AM.Move(step, get_dir(AM, step))

		if (!AM)		// Us moving somehow destroyed us?
			return

		if (!AM.throwing) // we hit something during our move
			finalize(hit = TRUE)
			return

		dist_travelled++

		if (dist_travelled > MAX_THROWING_DIST)
			finalize()
			return

		A = get_area(AM.loc)


/datum/thrownthing/proc/hit_atom(atom/A)
	finalize(hit=TRUE, t_target=A)

/datum/thrownthing/proc/hitcheck(var/turf/T)
	var/atom/movable/hit_thing
	for (var/thing in T)
		var/atom/movable/AM = thing
		if (AM == thrownthing || (AM == thrower && !ismob(thrownthing)))
			continue
		if (!AM.density || AM.throwpass)//check if ATOM_FLAG_CHECKS_BORDER as an atom_flag is needed
			continue
		if (!hit_thing || AM.layer > hit_thing.layer)
			hit_thing = AM

	if(hit_thing)
		finalize(hit=TRUE, t_target=hit_thing)
		return TRUE

/datum/thrownthing/proc/bump_into(atom/A)
	if(!can_hit(A, TRUE))
		return
	impact(A)

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
	if(A == thrownthing)
		return FALSE
	if(A == thrower)
		return FALSE
	if(impacted[A])
		return FALSE
	if(!bumping && A.CanPass(src, get_turf(A)))
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
	impacted[AM] = TRUE

	var/op_return = throwntihng._throw_do_hit(A)
	if(op_return & COMPONENT_THROW_HIT_TERMINATE)
		terminate()
		return

	on_hit?.Invoke(A, src)

	if(!(op_return & COMPONENT_THROW_HIT_PIERCE) && !in_land)
		land(get_turf(thrownthing))
		return

	// we are piercing. move again.
	tick(1)

/**
 * land on something and terminate the throw
 */
/datum/thrownthing/proc/land(atom/A)
	// hit our target if we haven't already
	if(!impacted[target] && (target in get_turf(A)))
		impact(target, TRUE)

	// land
	thrownthing._throw_finalize(A, src)
	on_land?.Invoke(A, src)

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
	if(thrownthing.movable_flags & MOVABLE_NO_THROW_DAMAGE_SCALING)
		return 1
	return (speed / thrownthing.throw_speed) ** thrownthing.throw_damage_scaling_exponent

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
	hit(target, TRUE)
	// gtfo
	terminate()
