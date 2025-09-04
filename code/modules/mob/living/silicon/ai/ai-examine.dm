//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/ai/should_client_shift_click_examine(atom/entity)
	if(!ismob(entity) && !(entity in view(usr?.client?.view || world.view, src)))
		return FALSE
	return ..()

/mob/living/silicon/ai/allow_examine(atom/A)
	return snowflake_ai_vision_adjacency(get_turf(A))
