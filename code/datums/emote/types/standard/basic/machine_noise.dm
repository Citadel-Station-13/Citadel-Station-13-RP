//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/machine_noise
	abstract_type = /datum/emote/standard/basic/machine_noise
	emote_require = EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	target_allowed = TRUE
	// TODO: parameter to enable this / set frequency
	sfx_vary = FALSE

/datum/emote/standard/basic/machine_noise/beep
	name = "Machine - Beep"
	desc = "Emit a beep."
	bindings = list(
		"beep",
		"synth-beep",
	)
	feedback_default = "<b>%%USER%%</b> beeps."
	feedback_default_targeted = "<b>%%USER%%</b> beeps at %%TARGET%%."
	sfx = 'sound/machines/twobeep.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/buzz
	bindings = list(
		"buzz",
		"synth-buzz",
	)
	feedback_default = "<b>%%USER%%</b> buzzes."
	sfx = 'sound/machines/buzz-sigh.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/buzz2
	bindings = list(
		"buzz2",
		"synth-buzz2",
	)
	feedback_default = "<b>%%USER%%</b> buzzes twice."
	sfx = 'sound/machines/buzz-two.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/chime
	bindings = list(
		"chime",
		"synth-chime",
	)
	feedback_default = "<b>%%USER%%</b> chimes."
	sfx = 'sound/machines/chime.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/dwoop
	bindings = list(
		"dwoop",
		"synth-dwoop",
	)
	feedback_default = "<b>%%USER%%</b> chirps happily."
	sfx = 'sound/machines/dwoop.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/warn
	bindings = list(
		"warn",
		"synth-warn",
	)
	feedback_default = "<b>%%USER%%</b> blares an alarm."
	sfx = 'sound/machines/warning-buzzer.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/ping
	bindings = list(
		"ping",
		"synth-ping",
	)
	feedback_default = "<b>%%USER%%</b> pings."
	sfx = 'sound/machines/ping.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/yes
	bindings = list(
		"yes",
		"synth-yes",
	)
	feedback_default = "<b>%%USER%%</b> emits an affirmative blip."
	sfx = 'sound/machines/synth_yes.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/no
	bindings = list(
		"no",
		"synth-no",
	)
	feedback_default = "<b>%%USER%%</b> emits a negative blip."
	sfx = 'sound/machines/synth_no.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/scary
	bindings = list(
		"scary",
		"synth-scary",
	)
	feedback_default = "<b>%%USER%%</b> emits a disconcerting tone."
	sfx = 'sound/machines/synth_scary.ogg'

// todo: name, targeted
/datum/emote/standard/basic/machine_noise/steam
	bindings = list(
		"steam",
		"synth-steam",
	)
	feedback_default = "<b>%%USER%%</b> lets off some steam."
	sfx = 'sound/machines/clockcult/steam_whoosh.ogg'
	sfx_volume = 30
