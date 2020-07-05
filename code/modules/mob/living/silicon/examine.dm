/mob/living/silicon/examine(mob/user) //Displays a silicon's laws to ghosts
	. = ..()
	if(laws && isobserver(user))
		. += "<b>[src] has the following laws:</b>"
		//for(var/law in laws.get_law_list(include_zeroth = TRUE))
		//	. += law
		laws.show_laws(user)

/mob/proc/showLaws(mob/living/silicon/S)
	return

/mob/observer/dead/showLaws(mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
