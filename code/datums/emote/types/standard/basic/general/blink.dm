//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: check has eyes
/datum/emote/standard/basic/general/blink
	name = "Blink"
	desc = "Blink your eyes."
	bindings = "blink"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> blinks."

// todo: check has eyes
/datum/emote/standard/basic/general/blink_fast
	name = "Blink Rapidly"
	desc = "Rapidly blink your eyes."
	bindings = list(
		"blink_r",
		"blink-fast",
	)
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> blinks rapidly."
