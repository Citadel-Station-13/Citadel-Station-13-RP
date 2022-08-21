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

	var/target_zone
	/// initial byond get_dir from thrown thing to target
	var/init_dir

	var/maxrange

	var/speed
	/// what threw us
	var/atom/thrower
	/// world.time we started
	var/start_time
	/// tiles we travelled
	var/dist_travelled = 0
	var/dist_x
	var/dist_y
	var/dx
	var/dy
	var/diagonal_error
	var/pure_diagonal
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

/datum/thrownthing/New(atom/movable/AM, atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land)
	src.thrownthing = AM
	src.target = target
	var/turf/T = get_turf(target)
	if(!T)
		qdel(src)
		CRASH("tried to throw something at something that wasn't in the game world.")
	src.target_turf = T
	T = get_turf(AM)
	if(!T)
		qdel(src)
		CRASH("tried to throw something that wasn't in the game world at something")
	src.initial_turf = T
	// todo: multiz throws
	src.maxrange = range
	src.speed = speed
	src.throw_flags = flags
	src.thrower = thrower
	src.on_hit = on_hit
	src.on_land = on_land
	src.init_dir = get_dir(thrownthing, target)

	#warn finish

/datum/thrownthing/New
	src.init_dir = get_dir(thrownthing, target)
	if(!QDELETED(thrower) && ismob(thrower))
		src.target_zone = thrower.zone_sel ? thrower.zone_sel.selecting : null

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
	SSthrowing.processing -= thrownthing
	thrownthing.throwing = null
	thrownthing = null
	target = null
	thrower = null
	callback = null
	return ..()

/datum/thrownthing/proc/tick()
	var/atom/movable/AM = thrownthing
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
			finalize()
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

/datum/thrownthing/proc/finalize(hit = FALSE, t_target=null)
	set waitfor = FALSE
	//done throwing, either because it hit something or it finished moving
	if(QDELETED(thrownthing))
		return
	thrownthing.throwing = null
	if (!hit)
		for (var/thing in get_turf(thrownthing)) //looking for our target on the turf we land on.
			var/atom/A = thing
			if (A == target)
				hit = TRUE
				thrownthing.throw_impact(A, speed)
				break
		if (!hit)
			thrownthing.throw_impact(get_turf(thrownthing), speed)  // we haven't hit something yet and we still must, let's hit the ground.

	if(ismob(thrownthing))
		var/mob/M = thrownthing
		M.inertia_dir = init_dir

	if(t_target && !QDELETED(thrownthing))
		thrownthing.throw_impact(t_target, speed)

	if (callback)
		callback.Invoke()

	if (!QDELETED(thrownthing))
		thrownthing.fall()

	qdel(src)

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

/**
 * handle impacting an atom
 * return TRUE if we should end the throw, FALSE to pierce
 */
/datum/thrownthing/proc/impact(atom/movable/AM)

/**
 * land on something and terminate the throw
 */
/datum/thrownthing/proc/land(atom/A)

/**
 * terminate the throw.
 * when called, immediately erases the throw from the atom and stops it.
 */
/datum/thrownthing/proc/terminate()
