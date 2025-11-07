//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/twitch
	name = "Twitch"
	desc = "Twitch."
	bindings = "twitch"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> twitches."
	feedback_saycode_type = SAYCODE_TYPE_VISIBLE

/datum/emote/standard/basic/general/twitch/strong
	name = "Twitch Violently"
	desc = "Violently twitch."
	bindings = list(
		"twitch_v",
		"twitch-violently",
	)
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> twitches violently."
	feedback_saycode_type = SAYCODE_TYPE_VISIBLE
