/mob/living/silicon/robot/update_stat(forced, update_mobility)
	if(!has_power || is_stunned() || is_paralyzed())
		forced = UNCONSCIOUS
	return ..()
