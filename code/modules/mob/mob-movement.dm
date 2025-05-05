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
