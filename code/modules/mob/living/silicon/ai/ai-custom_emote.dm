//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/silicon/ai/emit_custom_emote(emote_text)
	if(holopad)
		holopad_emote(emote_text)
	else
		..()
