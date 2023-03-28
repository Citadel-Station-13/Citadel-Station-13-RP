/atom/movable/proc/can_be_injected_by(atom/injector)
	if(!Adjacent(get_turf(injector)))
		return FALSE
	if(!reagents)
		return FALSE
	if(!reagents.available_volume())
		return FALSE
	return TRUE

/obj/can_be_injected_by(atom/injector)
	return is_open_container() && ..()

/mob/living/can_be_injected_by(atom/injector)
	return ..() && (can_inject(null, 0, BP_TORSO) || can_inject(null, 0, BP_GROIN))
