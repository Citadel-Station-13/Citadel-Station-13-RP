//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/salute
	name = "Salute"
	desc = "Salute at someone."
	bindings = "salute"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	sfx = 'sound/misc/salute.ogg'
	sfx_volume = 60
	target_allowed = TRUE
	feedback_default = "<b>%%USER%%</b> salutes."
	feedback_default_targeted = "<b>%%USER%%</b> salutes to %%TARGET%%."
