#define MAX_STAGGER_STACKS 30
#define STACKS_TO_SLOWDOWN(amt) (amt * (1 / 3.5))

/datum/status_effect/stacking/staggered
	identifier = "staggered"
	duration = 1 SECONDS
	max_stacks = MAX_STAGGER_STACKS


/datum/status_effect/stacking/staggered/on_stacks(old_stacks, new_stacks, decayed)
	. = ..()
	if(!new_stacks)
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/mob_staggered)
	else
		owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/mob_staggered, multiplicative_slowdown = STACKS_TO_SLOWDOWN(new_stacks))

#undef STACKS_TO_SLOWDOWN
#undef MAX_STAGGER_STACKS
