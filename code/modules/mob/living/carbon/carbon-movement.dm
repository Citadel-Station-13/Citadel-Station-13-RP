//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Sets our base movespeed from a config lookup.
 */
/mob/living/carbon/get_movespeed_base()
	// running full speed should alert people to the lack of species quickly.
	return species ? species.movement_base_speed : 20

/mob/living/carbon/get_movespeed_config_tags()
	. = ..()
	. += "human"
	. += "human-species-id-[species.uid]"

/mob/living/carbon/can_overcome_gravity()
	if(flying)
		return TRUE
	return ..()

/mob/living/carbon/process_overcome_gravity(time_required, mob/emit_feedback_to)
	if(flying)
		return standard_process_overcome_gravity(time_required, emit_feedback_to)
	return ..()

/mob/living/carbon/process_spacemove(drifting, movement_dir, just_checking)
	if(flying)
		return TRUE
	return ..()
