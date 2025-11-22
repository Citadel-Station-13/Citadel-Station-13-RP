//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/carbon/brain/get_usable_emote_require()
	. = ..()
	// if we can use emotes at all we probably can do these.
	. |= EMOTE_REQUIRE_COHERENT_SPEECH | EMOTE_REQUIRE_SYNTHETIC_SPEAKER | EMOTE_REQUIRE_VOCALIZATION
