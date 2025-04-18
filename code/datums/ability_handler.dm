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
	ab.owner.client.mouse_pointer_icon = file("icons/screen/mouse_pointers/reticle/standard1.dmi")

///Is called by a click if there's an ability in 'current'
/datum/ability_handler/proc/process_click(mob/user, atom/A)
	if(current)
		if(target_type && !istype(A, target_type))
			return FALSE
		if(A.atom_flags & ATOM_ABSTRACT)
			return FALSE
		if(current.target_check(user, A))
			current = null
			user.client?.mouse_pointer_icon = initial(user.client.mouse_pointer_icon)
			return TRUE
	return FALSE
