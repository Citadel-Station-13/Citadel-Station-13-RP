//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/observer/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// yeaaah let's not remote control a ghost, yea?
	// in the future this should probably only be for 'dead' because technically we can have
	// other observers, but for now, this holds true
	ASSERT(clickchain.initiator == src)
	clickchain.target.attack_ghost(src)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
