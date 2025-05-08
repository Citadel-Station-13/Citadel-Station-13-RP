/**
 * Special. Uses `mod_hyperbolic_slowdown`, sets the current hyperbolic slowdown to that.
 */
/datum/movespeed_modifier/base_movement_speed
	id = "base-movement_speed"
	variable = TRUE
	priority = MOVESPEED_PRIORITY_BASE_MOVE_SPEED

/datum/movespeed_modifier/base_movement_speed/apply_hyperbolic(existing, mob/target)
	return 10 / max(mod_tiles_per_second, MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND)
