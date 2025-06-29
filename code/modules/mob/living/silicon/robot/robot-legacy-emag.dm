//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/proc/set_emag_state(state)
	emagged = state
	#warn impl

/mob/living/silicon/robot/proc/get_emag_state()
	return emagged

/mob/living/silicon/robot/proc/set_emag_item_state(state)
	emag_items = state
	#warn impl

/mob/living/silicon/robot/proc/get_emag_item_state()
	return emag_items
