//! file contains mob helpers and whatnot
/**
 * checks if we have a characteristic talent
 *
 * @params
 * - typepath_or_id - typepath or id; prefer typepath during compile time
 *
 * @return TRUE/FALSE
 */
/mob/proc/has_characteristic_talent(datum/characteristic_talent/typepath_or_id)
	#warn impl

/**
 * checks the value of one of our characteristic stats
 *
 * @params
 * - typepath_or_id - typepath or id; prefer typepath during compile time
 *
 * @return TRUE/FALSE
 */
/mob/proc/get_characteristic_stat(datum/characteristic_stat/typepath_or_id)
	#warn impl

//! our old stuff below
// We don't actually have a skills system, so return max skill for everything.
/mob/proc/get_skill_value(skill_path)
	return SKILL_EXPERT

// A generic way of modifying success probabilities via skill values. Higher factor means skills have more effect. fail_chance is the chance at SKILL_NONE.
/mob/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_EXPERT, factor = 1)
	var/points = get_skill_value(skill_path)
	if(points >= no_more_fail)
		return 0
	else
		return fail_chance * 2 ** (factor*(SKILL_BASIC - points))


//! bay stuff below
/*
/mob/proc/skill_check(skill_path, needed)
    var/points = get_skill_value(skill_path)
    return points >= needed

/mob/proc/skill_check_multiple(skill_reqs)
    for(var/skill in skill_reqs)
        . = skill_check(skill, skill_reqs[skill])
        if(!.)
            return

/mob/proc/get_skill_difference(skill_path, mob/opponent)
    return get_skill_value(skill_path) - opponent.get_skill_value(skill_path)

/mob/proc/skill_delay_mult(skill_path, factor = 0.3)
    var/points = get_skill_value(skill_path)
    switch(points)
        if(SKILL_BASIC)
            return max(0, 1 + 3*factor)
        if(SKILL_UNTRAINED)
            return max(0, 1 + 6*factor)
        else
            return max(0, 1 + (SKILL_DEFAULT - points) * factor)

/mob/proc/do_skilled(base_delay, skill_path , atom/target = null, factor = 0.3, do_flags = DO_DEFAULT)
    return do_after(src, base_delay * skill_delay_mult(skill_path, factor), target, do_flags)

/mob/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1)
    var/points = get_skill_value(skill_path)
    if(points >= no_more_fail)
        return 0
    else
        return fail_chance * 2 ** (factor*(SKILL_MIN - points))

/mob/proc/skill_fail_prob(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1)
    return prob(skill_fail_chance(skill_path, fail_chance, no_more_fail, factor ))
	*/
