/mob/living/silicon/examine(mob/user, dist) //Displays a silicon's laws to ghosts
	. = ..()
	if(laws && isobserver(user))
		user.showLaws(src)
