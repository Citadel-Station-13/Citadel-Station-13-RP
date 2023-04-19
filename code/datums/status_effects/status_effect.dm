/**
 * ## Status Effects
 *
 * permanent / temporary tickable effects applied to mobs that are able to track
 * instance data.
 *
 * each effect potentially has its own amount of variable arguments that
 * can be passed into apply_status_effect. they will be detailed per-file.
 */
/datum/status_effect
	abstract_type = /datum/status_effect
	/// unique identifier
	var/identifier = "effect"
	/// duration in deciseconds - 0 for permanent.
	var/duration
	/// expiration timerid
	var/decay_timer
	/// start time - when refreshing we just bump this to world.time or something.
	var/started
	/// deciseconds per tick. null for no ticking.
	var/tick_interval
	/// next world.time we should tick.
	var/tick_next
	/// path of screen alert thrown
	var/alert_type
	/// screen alert instance if it exists
	var/atom/movable/screen/alert/status_effect/alert_linked
	/// mob we're affecting
	var/mob/owner

/datum/status_effect/New(mob/owner, duration, list/arguments)
	src.owner = owner
	if(!isnull(duration))
		src.duration = duration
	started = world.time
	rebuild_decay_timer()
	on_apply(arglist(arguments))

/datum/status_effect/Destroy()
	if(owner)
		owner.status_effects?[identifier] = null
	on_remove()
	owner = null
	if(decay_timer)
		deltimer(decay_timer)
		decay_timer = null
	return ..()

/datum/status_effect/proc/tick(dt)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * decays - this *must* either delete ourselves or automatically reapply the decay timer!
 */
/datum/status_effect/proc/decay()
	qdel(src)

/**
 * called on full removal
 */
/datum/status_effect/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(tick_interval))
		SSstatus_effects.ticking -= src

/**
 * called after add
 *
 * @params
 * * ... - rest of parameters from /mob/apply_status_effect()
 */
/datum/status_effect/proc/on_apply(...)
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(tick_interval))
		SSstatus_effects.ticking += src

/**
 * called on refresh
 *
 * @params
 * * old_timeleft - old time remaining
 * * ... - rest of parameters from /mob/apply_status_effect() or /datum/status_effect/refresh()
 */
/datum/status_effect/proc/on_refreshed(old_timeleft, ...)
	return

/**
 * refreshes our duration
 *
 * if duration is supplied and it isn't necessary to refresh, on_refreshed is not called.
 *
 * @params
 * * duration - if supplied, refreshes us to that long from now (if we weren't already at or above). otherwise, refreshes us to what current duration was from now.
 * * ... - rest of parameters from /mob/apply_status_effect(), passed to on_refreshed.
 *
 * @return were we refreshed?
 */
/datum/status_effect/proc/refresh(duration, ...)
	SHOULD_NOT_SLEEP(TRUE)
	var/left = time_left()
	if(isnull(duration))
		duration = src.duration
	else if(duration < left)
		return FALSE
	set_duration_from_now(duration)
	var/list/built = args.Copy()
	built[1] = left
	on_refreshed(arglist(built))
	return TRUE

/datum/status_effect/proc/time_left()
	return (started + duration) - world.time

/datum/status_effect/proc/set_duration_from_apply(duration)
	src.duration = duration
	rebuild_decay_timer()

/datum/status_effect/proc/set_duration_from_now(duration)
	src.duration = duration
	started = world.time
	rebuild_decay_timer()

/datum/status_effect/proc/adjust_duration(duration)
	src.duration += duration
	rebuild_decay_timer()

/datum/status_effect/proc/set_tick_interval(interval)
	var/was_ticking = !isnull(tick_interval)
	tick_interval = interval
	if(was_ticking && isnull(interval))
		SSstatus_effects.ticking -= src
	else if(!was_ticking && !isnull(interval))
		SSstatus_effects.ticking += src

/datum/status_effect/proc/rebuild_decay_timer()
	if(decay_timer)
		deltimer(decay_timer)
		decay_timer = null
	if(isnull(duration))
		return
	var/time_left = time_left()
	if(time_left <= 0)
		decay()
		return
	decay_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/status_effect, decay)), time_left, TIMER_STOPPABLE)

/datum/status_effect/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(raw_edit)
		return ..()
	switch(var_name)
		if(NAMEOF(src, tick_interval))
			set_tick_interval(var_value)
			. = TRUE
	if(.)
		datum_flags |= DF_VAR_EDITED
		return
	. = ..()
	if(!.)
		return
	switch(var_name)
		if(NAMEOF(src, duration))
			rebuild_decay_timer()

/datum/status_effect/proc/on_examine(list/examine_list)
	return

//? Mob procs

/**
 * applies a status effect to this mob
 *
 * if the status effect is already there, we will refresh it instead.
 *
 * @params
 * * path - path to effect
 * * duration - (optional) duration of effect; defaults to what the effect specifies.
 * * list/additional - all further args passed to effect.
 *
 * @return effect datum created / refreshed / whatever, null on failure
 */
/mob/proc/apply_status_effect(datum/status_effect/path, duration, list/additional)
	if(isnull(status_effects))
		status_effects = list()
	var/id = initial(path.identifier)
	if(status_effects[id])
		var/datum/status_effect/existing = status_effects[id]
		var/list/built = additional?.Copy() || list()
		built.Insert(1, duration)
		existing.refresh(arglist(built))
		return existing
	else
		var/datum/status_effect/making = new path(src, duration, additional)
		status_effects[making.identifier] = making
		return making

/**
 * remove a status effect
 *
 * @params
 * * path - path to effect
 * * stacks - stacks to remove for grouped and stacking, default is all.
 *
 * @return stacks **left**. for single effects this is probably 0.
 */
/mob/proc/remove_status_effect(datum/status_effect/path, stacks = INFINITY, ...)
	var/id = initial(path.identifier)
	var/datum/status_effect/found = status_effects?[id]
	if(isnull(found))
		return 0
	if(istype(found, /datum/status_effect/stacking))
		var/datum/status_effect/stacking/stacking = found
		. = min(stacking.stacks, stacks)
		stacking.adjust_stacks(-stacks, FALSE)
	else
		. = 1
		qdel(found)

/**
 * checks if we have a status effect
 *
 * @params
 * * path - path to effect
 *
 * @return effect datum found or null
 */
/mob/proc/has_status_effect(datum/status_effect/path)
	var/id = initial(path.identifier)
	return LAZYACCESS(status_effects, id)

//? Alert object

/atom/movable/screen/alert/status_effect
	name = "Curse of Mundanity"
	desc = "You don't feel any different..."
	var/datum/status_effect/attached_effect
