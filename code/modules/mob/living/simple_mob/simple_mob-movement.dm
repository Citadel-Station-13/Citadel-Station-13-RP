/mob/living/simple_mob/get_movespeed_base()
	return movement_base_speed

/mob/living/simple_mob/get_movespeed_config_tags()
	. = ..()
	. += "simple"

/mob/living/simple_mob/process_spacemove(drifting, movement_dir, just_checking)
	if(movement_works_in_space)
		return TRUE
	return ..()
