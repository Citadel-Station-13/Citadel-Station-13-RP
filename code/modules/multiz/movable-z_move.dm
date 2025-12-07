//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Used for maintenance checks. Shouldn't have side effects.
 * @return TRUE if we can currently overcome gravity.
 */
/atom/movable/proc/can_overcome_gravity(mob/emit_feedback_to)

/**
 * This should run the do_after needed to overcome gravity and go above.
 * * Used when flying up / something.
 * @return TRUE if successful
 */
/atom/movable/proc/process_overcome_gravity(time_required, mob/emit_feedback_to)

/**
 * * Undefined behavior if 'dir' is not UP or DOWN (not both)
 */
/atom/movable/proc/z_move(dir, mob/emit_feedback_to)
	if(!can_z_propel(dir, emit_feedback_to))
		return FALSE
	#warn impl

/**
 * * Undefined behavior if 'dir' is not UP or DOWN (not both)
 */
/atom/movable/proc/can_z_propel(dir, mob/emit_feedback_to)
	if(has_gravity())
		if(dir == UP)
			. = can_overcome_gravity(emit_feedback_to)
			if(!.)
				if(emit_feedback_to)
					emit_feedback_to.selfmove_feedback(SPAN_WARNING("You lack means of overcoming gravity."))
		else
			. = TRUE
	else
		. = process_spacemove(null, dir, TRUE)
		if(!.)
			if(emit_feedback_to)
				emit_feedback_to.selfmove_feedback(SPAN_WARNING("You lack means of propelling yourself in that direction."))

/**
 * * Undefined behavior if 'dir' is not UP or DOWN (not both)
 * @return TRUE if should move, FALSE if failed, null to **override** standard travel but count as a technical 'did something'.
 */
/atom/movable/proc/process_z_propel(dir, mob/emit_feedback_to)
	if(has_gravity())
		if(dir == DOWN)
			return TRUE
		else
			// TODO: more than 0 seconds maybe?? lol
			return process_overcome_gravity(0, emit_feedback_to)
	else
		return process_spacemove(null, dir)
