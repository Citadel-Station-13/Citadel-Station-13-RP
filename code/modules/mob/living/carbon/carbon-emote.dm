//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/get_usable_emote_require()
	. = ..()
	var/obj/item/organ/internal/maybe_voicebox = organs_by_name[O_VOICE]
	if(maybe_voicebox?.robotic >= ORGAN_ROBOT)
		. |= EMOTE_REQUIRE_SYNTHETIC_SPEAKER
