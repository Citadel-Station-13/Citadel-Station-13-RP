//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Gets movement delay.
 * Kept just in case we need to, for whatever reason, override this later.
 * For the time being, overriding this is not allowed. Use movespeed modifiers.
 */
/mob/proc/movement_delay()
	SHOULD_CALL_PARENT(TRUE)
	return movespeed_hyperbolic

/mob/proc/toggle_move_intent()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			set_move_intent(MOVE_INTENT_WALK)
		else
			set_move_intent(MOVE_INTENT_RUN)

/mob/proc/set_move_intent(new_intent)
	switch(new_intent)
		if(MOVE_INTENT_RUN)
		if(MOVE_INTENT_WALK)
		else
			CRASH("unknown move_intent '[new_intent]")
	m_intent = new_intent
	update_movespeed_intent()

	//- legacy: set hud -
	hud_used?.move_intent?.icon_state = (m_intent == MOVE_INTENT_RUN)? "running" : "walking"
	//- end -

/mob/proc/update_movespeed_intent()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			remove_movespeed_modifier(/datum/movespeed_modifier/mob_move_intent)
		if(MOVE_INTENT_WALK)
			update_movespeed_modifier(/datum/movespeed_modifier/mob_move_intent, list(
				MOVESPEED_PARAM_MOD_MULTIPLY_SPEED = 0.01,
				MOVESPEED_PARAM_LIMIT_TPS_MIN = Configuration.get_entry(/datum/toml_config_entry/game/movement/walk_speed),
			))
