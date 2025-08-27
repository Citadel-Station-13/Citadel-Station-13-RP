//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/should_client_shift_click_examine(atom/entity)
	return ismob(entity) && ..()
