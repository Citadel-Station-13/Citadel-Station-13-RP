//Status effects are used to apply temporary or permanent effects to mobs. Mobs are aware of their status effects at all times.
//This file contains their code, plus code for applying and removing them.
//When making a new status effect, add a define to status_effects.dm in __DEFINES for ease of use!

/datum/status_effect
	/// unique identifier
	var/identifier = "effect"
	/// duration in deciseconds - 0 for permanent.
	var/duration
	#warn hook
	/// expiration timerid
	var/expire_timer
	#warn hook
	/// start time - when refreshing we just bump this to world.time or something.
	var/started
	#warn hook
	/// deciseconds per tick. null for no ticking.
	var/tick_interval
	#warn hook
	/// next world.time we should tick.
	var/tick_next
	/// screen alert thrown
	var/alert_type = /atom/movable/screen/alert/status_effect
	/// screen alert instance if it exists
	var/atom/movable/screen/alert/status_effect/alert_linked
	/// mob we're affecting
	var/mob/owner

	var/examine_text //If defined, this text will appear when the mob is examined - to use he, she etc. use "SUBJECTPRONOUN" and replace it in the examines themselves
	/// How many of the effect can be on one mob, and what happens when you try to add another
	var/status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/New(list/arguments, duration)
	if(!isnull(duration))
		src.duration = duration
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, ...)
	if(new_owner)
		owner = new_owner
	if(owner)
		LAZYADD(owner.status_effects, src)
	if(!owner || !on_apply())
		qdel(src)
		return
	if(duration != -1)
		duration = world.time + duration
	next_tick = world.time + tick_interval
	// if(alert_type)
		// var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(identifier, alert_type)
		// A.attached_effect = src //so the alert can reference us, if it needs to
		// linked_alert = A //so we can reference the alert, if we need to
	START_PROCESSING(SSstatus_effects, src)
	return TRUE

/datum/status_effect/Destroy()
	STOP_PROCESSING(SSstatus_effects, src)
	if(owner)
		// owner.clear_alert(identifier)
		LAZYREMOVE(owner.status_effects, src)
		on_remove()
		owner = null
	return ..()

/datum/status_effect/process()
	if(!owner)
		qdel(src)
		return
	if(next_tick < world.time)
		tick()
		next_tick = world.time + tick_interval
	if(duration != -1 && duration < world.time)
		qdel(src)

/datum/status_effect/proc/on_apply() //Called whenever the buff is applied; returning FALSE will cause it to autoremove itself.
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

/datum/status_effect/proc/tick()
	SHOULD_NOT_SLEEP(TRUE)

/datum/status_effect/proc/before_remove() //! Called before being removed; returning FALSE will cancel removal
	return TRUE

/**
 * called on full removal
 */
/datum/status_effect/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)
	return

/**
 * called after add
 */
/datum/status_effect/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)
	return

/datum/status_effect/proc/be_replaced() //Called instead of on_remove when a status effect is replaced by itself or when a status effect with on_remove_on_mob_delete = FALSE has its mob deleted
	// owner.clear_alert(identifier)
	LAZYREMOVE(owner.status_effects, src)
	owner = null
	qdel(src)

/datum/status_effect/proc/refresh()
	#warn impl

/datum/status_effect/proc/time_left()
	#warn impl

////////////////
// ALERT HOOK //
////////////////

//? Mob procs

/**
 * applies a status effect to this mob
 *
 * @params
 * * path - path to effect
 * * duration - (optional) duration of effect; defaults to what the effect specifies.
 * * ... - all further args passed to effect.
 *
 * @return effect datum created / refreshed / whatever, null on failure
 */
/mob/proc/apply_status_effect(datum/status_effect/path, duration, ...)
	if(isnull(status_effects))
		status_effects = list()
	var/id = initial(path.identifier)
	if(status_effects[id])
		var/datum/status_effect/existing = status_effects[id]
		#warn impl
	else
		#warn impl

/mob/living/proc/apply_status_effect(effect, ...) //applies a given status effect to this mob, returning the effect if it was successful
	. = FALSE
	var/datum/status_effect/S1 = effect
	LAZYINITLIST(status_effects)
	for(var/datum/status_effect/S in status_effects)
		if(S.identifier == initial(S1.identifier) && S.status_type)
			if(S.status_type == STATUS_EFFECT_REPLACE)
				S.be_replaced()
			else if(S.status_type == STATUS_EFFECT_REFRESH)
				S.refresh()
				return
			else
				return
	var/list/arguments = args.Copy()
	arguments[1] = src
	S1 = new effect(arguments)
	. = S1

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
	#warn impl

/mob/living/proc/remove_status_effect(effect, ...) //removes all of a given status effect from this mob, returning TRUE if at least one was removed
	. = FALSE
	var/list/arguments = args.Copy(2)
	if(status_effects)
		var/datum/status_effect/S1 = effect
		for(var/datum/status_effect/S in status_effects)
			if(initial(S1.identifier) == S.identifier && S.before_remove(arguments))
				qdel(S)
				. = TRUE

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
