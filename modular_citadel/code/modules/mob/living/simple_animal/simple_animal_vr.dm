/mob/living/simple_mob/will_eat(var/mob/living/M)
	. = ..()
	if(.)	//insanely negligible performance buff
		if(istype(M) && hostile && !M.incapacitated(INCAPACITATION_ALL))
			ai_log("vr/wont eat [M] because i lust for blood", 3)
			return FALSE
	return
