//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general
	abstract_type = /datum/emote/standard/basic/general

/datum/emote/standard/basic/general/bow
	name = "Bow"
	desc = "Bow, or bow to someone."
	bindings = "bow"
	required_mobility_flags = MOBILITY_CAN_STAND
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> bows."
	feedback_default_targeted = "<b>%%USER%%</b> bows to %%TARGET%%."
	target_allowed = TRUE

// todo: you need a face to do this
/datum/emote/standard/basic/general/blush
	name = "Blush"
	desc = "Blush, or blush at someone."
	bindings = "blush"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> blushes."
	feedback_default_targeted = "<b>%%USER%%</b> blushes at %%TARGET%%."
	target_allowed = TRUE

// todo: you need a face to do this
/datum/emote/standard/basic/general/frown
	name = "Frown"
	desc = "Frown, or frown at someone."
	bindings = "frown"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> frowns."
	feedback_default_targeted = "<b>%%USER%%</b> frowns at %%TARGET%%."
	target_allowed = TRUE

// todo: you need a head to do this
/datum/emote/standard/basic/general/nod
	name = "Nod"
	desc = "Nod, or nod at someone."
	bindings = "nod"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> nods."
	feedback_default_targeted = "<b>%%USER%%</b> nods at %%TARGET%%."
	target_allowed = TRUE

/datum/emote/standard/basic/general/raise_hand
	name = "Raise Hand"
	desc = "Raise your hand."
	bindings = "raise"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> raises a hand."
	emote_require = EMOTE_REQUIRE_FREE_HAND

/datum/emote/standard/basic/general/shiver
	name = "Shiver"
	desc = "Shiver."
	bindings = "shiver"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> shivers."

/datum/emote/standard/basic/general/shrug
	name = "Shrug"
	desc = "Shrug, or shrug at someone."
	bindings = "shrug"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> shrugs."
	feedback_default_targeted = "<b>%%USER%%</b> shrugs at %%TARGET%%."
	target_allowed = TRUE

// todo: check has mouth
/datum/emote/standard/basic/general/smile
	name = "Smile"
	desc = "Smile, or smile at someone."
	bindings = "smile"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> smiles."
	feedback_default_targeted = "<b>%%USER%%</b> smiles at %%TARGET%%."
	target_allowed = TRUE

// todo: check has mouth
/datum/emote/standard/basic/general/smooch
	name = "Smooch"
	desc = "Smooch someone standing next to you."
	bindings = "smooch"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	target_allowed = TRUE
	target_required = TRUE
	target_range = 1
	feedback_default_targeted = "<b>%%USER%%</b> smooches %%TARGET%%."

/datum/emote/standard/basic/general/wave
	name = "Wave"
	desc = "Wave, or wave at someone."
	bindings = "wave"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> waves."
	feedback_default_targeted = "<b>%%USER%%</b> waves at %%TARGET%%."
	target_allowed = TRUE
	emote_require = EMOTE_REQUIRE_FREE_HAND

// todo: check has eyes
/datum/emote/standard/basic/general/wink
	name = "Wink"
	desc = "Wink at someone."
	bindings = "wink"
	emote_class = EMOTE_CLASS_IS_HUMANOID
	feedback_default = "<b>%%USER%%</b> winks."
	feedback_default_targeted = "<b>%%USER%%</b> winks at %TARGET."
	target_allowed = TRUE
