//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/animal_noise
	abstract_type = /datum/emote/standard/basic/animal_noise
	emote_require = EMOTE_REQUIRE_VOCALIZATION
	// TODO: parameter to enable this / set frequency
	sfx_vary = FALSE

/datum/emote/standard/basic/animal_noise/awoo
	name = "Awoo"
	desc = "Let out an awoo."
	bindings = "awoo"
	feedback_special_miming = "<b>%%USER%%</b> acts out an awoo."
	feedback_default = "<b>%%USER%%</b> awoos!"
	feedback_default_audible = "You hear an awoo."
	sfx = 'sound/voice/awoo.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/bird_beep
	name = "Bird Peep"
	desc = "Peep like a bird."
	bindings = list(
		"peep",
		"bird-peep",
	)
	feedback_special_miming = "<b>%%USER%%</b> bobs as if they're peeping like a bird."
	feedback_default = "<b>%%USER%%</b> peeps like a bird!"
	feedback_default_audible = "You hear a peep."
	sfx = 'sound/voice/peep.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/clak
	name = "Clak"
	desc = "... Clak. What?."
	bindings = "clak"
	feedback_default = "<b>%%USER%%</b> <font color='grey' size='2'>CLAKS!</font>!"
	feedback_default_audible = "You hear a <font color='grey' size='2'>CLAK</font>."
	sfx = 'sound/spooky/boneclak.ogg'
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
		"mouse-squeak",
	)
	feedback_special_miming = "<b>%%USER%%</b> acts out a soft squeak."
	feedback_default = "<b>%%USER%%</b> squeaks!"
	feedback_default_audible = "You hear a squeak."
	sfx = 'sound/effects/mouse_squeak.ogg'
	sfx_volume = 50
