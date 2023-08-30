//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_movement/living
	agent_type = /mob/living

/datum/ai_movement/living/move_in_dir(mob/living/agent, dir)
	#warn impl
	movement_delay = agent.cached_multiplicative_movespeed
