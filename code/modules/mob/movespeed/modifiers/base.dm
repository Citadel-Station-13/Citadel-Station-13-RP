/**
 * Special. Uses `mod_hyperbolic_slowdown`, sets the current hyperbolic slowdown to that.
 */
/datum/movespeed_modifier/base_movement_speed
	variable = TRUE
	priority = MOVESPEED_PRIORITY_BASE_MOVE_SPEED

/datum/movespeed_modifier/base_movement_speed/apply_hyperbolic(existing, mob/target)
	return mod_hyperbolic_slowdown
