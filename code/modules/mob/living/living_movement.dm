/mob/living/movement_delay()
	. = ..()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			if(drowsyness > 0)
				. += 6
			. += config.run_speed
		if(MOVE_INTENT_WALK)
			. += config.walk_speed
