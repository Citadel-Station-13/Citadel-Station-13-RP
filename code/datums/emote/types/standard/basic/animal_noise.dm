//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/animal_noise
	abstract_type = /datum/emote/standard/basic/animal_noise
	emote_require = EMOTE_REQUIRE_VOCALIZATION

/datum/emote/standard/basic/animal_noise/awoo
	name = "Awoo"
	desc = "Let out an awoo."
	bindings = "awoo"
	feedback_special_miming = "<b>%%USER%%</b> acts out an awoo."
	feedback_default = "<b>%%USER%%</b> awoos!"
	feedback_default_audible = "You hear an awoo."
	sfx = 'sound/voice/awoo.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/meow
	name = "Meow"
	desc = "Let out a meow."
	bindings = "meow"
	feedback_special_miming = "<b>%%USER%%</b> acts out a soft mrowl."
	feedback_default = "<b>%%USER%%</b> mrowls!"
	feedback_default_audible = "You hear a mrowl."
	sfx = 'sound/voice/meow1.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/nya
	name = "Nya"
	desc = "Let out a nya."
	bindings = "nya"
	feedback_special_miming = "<b>%%USER%%</b> acts out a cartoony cat noise, whatever that means."
	feedback_default = "<b>%%USER%%</b> lets out a nya!"
	feedback_default_audible = "You hear an unrealistically cartoony cat noise."
	sfx = 'sound/voice/nya.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/squeak_mouse
	name = "Squeak (Mouse)"
	desc = "Squeak like a mouse."
	bindings = list(
		"squeak",
		"squeak-mouse",
	)
	feedback_special_miming = "<b>%%USER%%</b> acts out a soft squeak."
	feedback_default = "<b>%%USER%%</b> squeaks!"
	feedback_default_audible = "You hear a squeak."
	sfx = 'sound/effects/mouse_squeak.ogg'
	sfx_volume = 50
