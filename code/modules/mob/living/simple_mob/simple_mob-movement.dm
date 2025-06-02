/mob/living/simple_mob/get_movespeed_base()
	return movement_base_speed

/mob/living/simple_mob/get_movespeed_config_tags()
	. = ..()
	. += "simple"
