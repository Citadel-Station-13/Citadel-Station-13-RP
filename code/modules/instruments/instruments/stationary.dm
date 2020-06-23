/obj/structure/musician
	name = "Not A Piano"
	desc = "Something broke, contact coderbus."
	//interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT | INTERACT_ATOM_REQUIRES_DEXTERITY
	var/can_play_unanchored = FALSE
	var/list/allowed_instrument_ids
	var/datum/song/song

/obj/structure/musician/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids)
	allowed_instrument_ids = null

/obj/structure/musician/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/structure/musician/proc/should_stop_playing(mob/user)
	if(!(anchored || can_play_unanchored))
		return TRUE
	if(!user)
		return FALSE
	return (usr.default_can_use_topic(src) < STATUS_UPDATE)		//can play with TK and while resting because fun.

/// CITRP EDIT UNTIL INTERACTION REFACTOR PORT!
/obj/structure/musician/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!anchored)
		return
	ui_interact(user)

/obj/structure/musician/ui_interact(mob/user)
	. = ..()
	song.ui_interact(user)

/obj/structure/musician/attackby(obj/item/I, mob/living/user)
	if(I.is_wrench())
		playsound(src, I.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You begin to [anchored? "loosen" : "tighten"] [src]'s casters...</span>")
		if(do_after(user, 40 * I.toolspeed))
			user.visible_message("<span class='notice'>[user] [anchored? "loosens" : "tightens"] [src]'s casters.</span>")
			anchored = !anchored
	else
		return ..()

/*
/obj/structure/musician/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 40)
	return TRUE
*/

/obj/structure/musician/piano
	name = "space minimoog"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE

/obj/structure/musician/piano/unanchored
	anchored = FALSE

/obj/structure/musician/piano/Initialize(mapload)
	. = ..()
	if(prob(50) && icon_state == initial(icon_state))
		name = "space minimoog"
		desc = "This is a minimoog, like a space piano, but more spacey!"
		icon_state = "minimoog"
	else
		name = "space piano"
		desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
		icon_state = "piano"
