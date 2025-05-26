/datum/status_effect/grouped/staggered
	identifier = "staggered"
	duration = 1 SECONDS
	var/applied_highest = 0

/datum/status_effect/grouped/staggered/on_change(source, old_value, new_value)
	. = ..()
	var/highest = 0
	for(var/a_source in sources)
		highest = max(highest, sources[a_source])
	if(!highest)
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/mob_staggered)
		applied_highest = 0
		return
	if(applied_highest == highest)
		return
	applied_highest = highest
	owner.update_movespeed_modifier(/datum/movespeed_modifier/mob_staggered, params = list(
		MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = highest,
	))

/datum/status_effect/grouped/staggered/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/mob_staggered)
