//Parent type for effects that happen when
/obj/effect/step_trigger
	var/affect_ghosts = FALSE
	var/stop_throw = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE

/obj/effect/step_trigger/proc/trigger(atom/movable/AM)
	return

/obj/effect/step_trigger/Crossed(atom/movable/AM)
	. = ..()
	if(isobserver(AM) && !affect_ghosts)
		return
	trigger(AM)
