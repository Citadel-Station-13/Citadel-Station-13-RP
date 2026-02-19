//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/get_usable_emote_require()
	. = NONE
	if(silent || is_muzzled())
	else
		. |= EMOTE_REQUIRE_COHERENT_SPEECH | EMOTE_REQUIRE_VOCALIZATION
	if(isSynthetic())
		. |= EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	if(inventory.get_empty_hand_indices())
		. |= EMOTE_REQUIRE_FREE_HAND
