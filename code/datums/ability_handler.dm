/datum/ability_handler
    var/datum/ability/current
    var/target_type

///Is called by the ability
/datum/ability_handler/proc/process_ability(var/datum/ability/ab)
	current = ab
	switch(current?.targeting_type)
		if(ABILITY_TARGET_ALL)
			target_type = /atom
		if(ABILITY_TARGET_MOB)
			target_type = /mob
		if(ABILITY_TARGET_TURF)
			target_type = /turf
		else
			target_type = null
			return

///Is called by a click if there's an ability in 'current'
/datum/ability_handler/proc/process_click(mob/user, atom/A)
	if(current)
		if(istype(A,target_type) && !istype(A,/atom/movable))
			if(current.target_check(user, A))
				current = null
				return TRUE
	return FALSE
