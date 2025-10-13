//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/machine_noise
	abstract_type = /datum/emote/standard/basic/machine_noise

	binding_prefix = "synth"

	emote_require = EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	target_allowed = TRUE

/datum/emote/standard/basic/machine_noise/beep
	name = "Machine - Beep"
	desc = "Emit a beep."
	bindings = "beep"
	feedback_default = "%%USER%% beeps."
	feedback_default_targeted = "%%USER%% beeps at %%TARGET%%."
	sfx = 'sound/machines/twobeep.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/buzz
	bindings = "buzz"
	feedback_default = "%%USER%% buzzes."
	sfx = 'sound/machines/buzz-sigh.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/buzz2
	bindings = "buzz2"
	feedback_default = "%%USER%% buzzes twice."
	sfx = 'sound/machines/buzz-two.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/chime
	bindings = "chime"
	feedback_default = "%%USER%% chimes."
	sfx = 'sound/machines/chime.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/dwoop
	bindings = "dwoop"
	feedback_default = "%%USER%% chirps happily."
	sfx = 'sound/machines/dwoop.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/warn
	bindings = "warn"
	feedback_default = "%%USER%% blares an alarm."
	sfx = 'sound/machines/warning-buzzer.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/ping
	bindings = "ping"
	feedback_default = "%%USER%% pings."
	sfx = 'sound/machines/ping.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/yes
	bindings = "yes"
	feedback_default = "%%USER%% emits an affirmative blip."
	sfx = 'sound/machines/synth_yes.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/no
	bindings = "no"
	feedback_default = "%%USER%% emits a negative blip."
	sfx = 'sound/machines/synth_no.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/scary
	bindings = "scary"
	feedback_default = "%%USER%% emits a disconcerting tone."
	sfx = 'sound/machines/synth_scary.ogg'
