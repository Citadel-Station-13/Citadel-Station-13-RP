//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general

#warn impl

// todo: check has eyes
/datum/emote/standard/basic/general/blink
	name = "Blink"
	desc = "Blink your eyes."
	bindings = "blink"
	feedback_default = "%USER% blinks."

// todo: check has eyes
/datum/emote/standard/basic/general/blink_fast
	name = "Blink Rapidly"
	desc = "Rapidly blink your eyes."
	bindings = "blink-fast"
	feedback_default = "%USER% blinks rapidly."

/datum/emote/standard/basic/general/bow
	name = "Bow"
	desc = "Bow, or bow to someone."
	bindings = "bow"
	required_mobility_flags = MOBILITY_CAN_STAND
	feedback_default_targeted = "%USER% bows to %TARGET%."
	feedback_default = "%USER% bows."

// todo: check has mouth
/datum/emote/standard/basic/general/smooch
	name = "Smooch"
	desc = "Smooch someone standing next to you."
	target_allowed = TRUE
	target_required = TRUE
	target_range = 1
	feedback_default_targeted = "%USER% smooches %TARGET%."

// todo: check has eyes
/datum/emote/standard/basic/general/wink
	name = "Wink"
	desc = "Wink at someone."
	bindings = "wink"
	feedback_default = "%USER% winks."
	feedback_default_targeted = "%USER% winks at %TARGET."
	target_allowed = TRUE
