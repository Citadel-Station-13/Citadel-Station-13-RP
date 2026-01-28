//
// Simple nom proc for if you get ckey'd into a simple_mob mob! Avoids grabs.
//
/mob/living/simple_mob/proc/animal_nom(var/mob/living/T in living_mobs(1))
	set name = "Animal Nom"
	set category = VERB_CATEGORY_IC
	set desc = "Since you can't grab, you get a verb!"

	if (stat != CONSCIOUS)
		return
	if (istype(src,/mob/living/simple_mob/animal/passive/mouse) && T.ckey == null)
		return
	if(!T.devourable)
		to_chat(src, SPAN_WARNING("[T] is not edible."))
		return
	if (client && IsAdvancedToolUser())
		to_chat(src,"<span class='warning'>Put your hands to good use instead!</span>")
		return
	feed_grabbed_to_self(src,T)
	update_icon()
