SUBSYSTEM_DEF(status_effects)
	wait = 0.5
	subsystem_flags = SS_NO_INIT
	name = "Status Effects"

	/// ticking effects
	var/list/datum/status_effect/ticking = list()
	/// currentrun
	var/list/datum/status_effect/currentrun = list()

/datum/controller/subsystem/status_effects/Recover()
	if(islist(SSstatus_effects.ticking))
		src.ticking = list()
		for(var/datum/status_effect/eff in SSstatus_effects.ticking)
			src.ticking += eff
	return ..()

/datum/controller/subsystem/status_effects/fire(resumed)
	if(!resumed)
		currentrun = ticking.Copy()
	// cache for speed
	var/list/datum/status_effect/to_tick = currentrun
	if(!length(to_tick))
		return
	var/i
	var/datum/status_effect/effect
	// todo: this is mildly inefficient when there's a lot of slow-ticking status effects
	for(i in 1 to length(to_tick))
		effect = to_tick[i]
		if(effect.tick_next > world.time)
			continue
		effect.tick(effect.tick_interval * 0.1)
		effect.tick_next = world.time + effect.tick_interval
		if(MC_TICK_CHECK_USAGE) // effect.tick() is SHOULD NOT SLEEP.
			return
	to_tick.Cut(1, i + 1)
