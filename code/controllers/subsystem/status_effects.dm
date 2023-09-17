SUBSYSTEM_DEF(status_effects)
	wait = 0.5
	subsystem_flags = NONE
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

/datum/controller/subsystem/status_effects/proc/register(datum/status_effect/effect)
	ticking += effect

/datum/controller/subsystem/status_effects/proc/unregister(datum/status_effect/effect)
	ticking -= effect
	currentrun -= effect

/datum/controller/subsystem/status_effects/fire(resumed)
	if(!resumed)
		currentrun = ticking.Copy()
	if(!length(currentrun))
		return
	var/i
	var/datum/status_effect/effect
	for(i in 1 to length(currentrun))
		effect = currentrun[i]
		if(effect.tick_next > world.time)
			continue
		effect.tick(effect.tick_interval)
		effect.tick_next = world.time + effect.tick_interval
		if(MC_TICK_CHECK_USAGE) // effect.tick() is SHOULD NOT SLEEP.
			return
	currentrun.Cut(1, i + 1)
