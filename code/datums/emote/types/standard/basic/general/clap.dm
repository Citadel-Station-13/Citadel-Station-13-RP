//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/clap
	name = "Clap"
	desc = "Clap."
	bindings = "clap"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	sfx = list(
		'sound/misc/clapping.ogg',
		'sound/voice/clap2.ogg',
		'sound/voice/clap3.ogg',
		'sound/voice/clap4.ogg',
	)
	sfx_volume = 75
	feedback_default = "<b>%%USER%%</b> claps."
	feedback_default_targeted = "<b>%%USER%%</b> claps for %%TARGET%%."
	feedback_default_audible = "You hear clapping."
	target_allowed = TRUE

/datum/emote/standard/basic/general/golfclap
	name = "Clap Slowly"
	desc = "Clap slowly, perhaps sarcastically."
	bindings = list(
		"golfclap",
		"clap-slow",
	)
	emote_class = EMOTE_CLASS_IS_HUMANOID
	sfx = 'sound/voice/golfclap.ogg'
	sfx_volume = 75
	feedback_default = "<b>%%USER%%</b> slowly claps."
	feedback_default_targeted = "<b>%%USER%%</b> slowly claps for %%TARGET%%."
	feedback_default_audible = "You hear sarcastic clapping."
	target_allowed = TRUE
