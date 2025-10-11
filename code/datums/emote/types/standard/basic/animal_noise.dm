//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/animal_noise
	abstract_type = /datum/emote/standard/basic/animal_noise

/datum/emote/standard/basic/animal_noise/awoo
	bindings = "awoo"
	feedback_special_miming = "%USER% acts out an awoo."
	feedback_default = "%USER% awoos!"
	feedback_default_audible = "You hear an awoo."
	sfx = 'sound/voice/awoo.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/meow
	bindings = "meow"
	feedback_special_miming = "%USER% acts out a soft mrowl."
	feedback_default = "%USER% mrowls!"
	feedback_default_audible = "You hear a mrowl."
	sfx = 'sound/voice/meow1.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/nya
	bindings = "nya"
	feedback_special_miming = "%USER% acts out a cartoony cat noise, whatever that means."
	feedback_default = "%USER% lets out a nya!"
	feedback_default_audible = "You hear an unrealistically cartoony cat noise."
	sfx = 'sound/voice/nya.ogg'
	sfx_volume = 50

/datum/emote/standard/basic/animal_noise/squeak_mouse
	bindings = "squeak-mouse"
	feedback_special_miming = "%USER% acts out a soft squeak."
	feedback_default = "%USER% squeaks!"
	feedback_default_audible = "You hear a squeak."
	sfx = 'sound/effects/mouse_squeak.ogg'
	sfx_volume = 50
