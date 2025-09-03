//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
* New players shouldn't click on anything at all.
*/
/mob/new_player/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return CLICKCHAIN_DO_NOT_PROPAGATE
