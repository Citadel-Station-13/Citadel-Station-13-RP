//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general
	abstract_type = /datum/emote/standard/basic/general
	emote_require = EMOTE_REQUIRE_BODY

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
	feedback_default = "%USER% bows."
	feedback_default_targeted = "%USER% bows to %TARGET%."
	target_allowed = TRUE

// todo: you need a face to do this
/datum/emote/standard/basic/general/blush
	name = "Blush"
	desc = "Blush, or blush at someone."
	bindings = "blush"
	feedback_default = "%USER% blushes."
	feedback_default_targeted = "%USER% blushes at %TARGET%."
	target_allowed = TRUE

// todo: you need a face to do this
/datum/emote/standard/basic/general/frown
	name = "Frown"
	desc = "Frown, or frown at someone."
	bindings = "frown"
	feedback_default = "%USER% frowns."
	feedback_default_targeted = "%USER% frowns at %TARGET%."
	target_allowed = TRUE

// todo: you need a head to do this
/datum/emote/standard/basic/general/nod
	name = "Nod"
	desc = "Nod, or nod at someone."
	bindings = "nod"
	feedback_default = "%USER% nods."
	feedback_default_targeted = "%USER% nods at %TARGET%."
	target_allowed = TRUE

/datum/emote/standard/basic/general/raise_hand
	name = "Raise Hand"
	desc = "Raise your hand."
	bindings = "raise"
	feedback_default = "%USER% raises a hand."
	emote_require = EMOTE_REQUIRE_USABLE_HAND

/datum/emote/standard/basic/general/shiver
	name = "Shiver"
	desc = "Shiver."
	bindings = "shiver"
	feedback_default = "%USER% shivers."

/datum/emote/standard/basic/general/shrug
	name = "Shrug"
	desc = "Shrug, or shrug at someone."
	bindings = "shrug"
	feedback_default = "%USER% shrugs."
	feedback_default_targeted = "%USER% shrugs at %TARGET%."
	target_allowed = TRUE

// todo: check has mouth
/datum/emote/standard/basic/general/smile
	name = "Smile"
	desc = "Smile, or smile at someone."
	bindings = "smile"
	feedback_default = "%USER% smiles."
	feedback_default_targeted = "%USER% smiles at %TARGET%."
	target_allowed = TRUE

// todo: check has mouth
/datum/emote/standard/basic/general/smooch
	name = "Smooch"
	desc = "Smooch someone standing next to you."
	bindings = "smooch"
	target_allowed = TRUE
	target_required = TRUE
	target_range = 1
	feedback_default_targeted = "%USER% smooches %TARGET%."

/datum/emote/standard/basic/general/wave
	name = "Wave"
	desc = "Wave, or wave at someone."
	bindings = "wave"
	feedback_default = "%USER% waves."
	feedback_default_targeted = "%USER% waves at %TARGET%."
	target_allowed = TRUE
	emote_require = EMOTE_REQUIRE_USABLE_HAND

// todo: check has eyes
/datum/emote/standard/basic/general/wink
	name = "Wink"
	desc = "Wink at someone."
	bindings = "wink"
	feedback_default = "%USER% winks."
	feedback_default_targeted = "%USER% winks at %TARGET."
	target_allowed = TRUE
