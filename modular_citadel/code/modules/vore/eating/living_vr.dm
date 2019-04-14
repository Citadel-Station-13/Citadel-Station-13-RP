/mob/living/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/obj/belly/belly, var/delay)
	if(istype(prey) && istype(user))
		if(!prey.allowmobvore)
			if(user == pred)
				to_chat(user, "<span class='warning'>[prey] doesn't look very appetizing.</span>")
			else
				to_chat(user, "<span class='warning'>It doesn't seem like you're able to fit [prey] into [pred].</span>")
			return FALSE
	. = ..()
