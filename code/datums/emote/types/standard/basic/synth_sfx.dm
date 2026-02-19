//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/synth_sfx
	abstract_type = /datum/emote/standard/basic/synth_sfx

	emote_require = EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	required_mobility_flags = MOBILITY_IS_CONSCIOUS
	// TODO: parameter to enable this / set frequency
	sfx_vary = FALSE

/datum/emote/standard/basic/synth_sfx/honk
	name = "Machine - Bike Horn"
	desc = "Emit a bike horn's honk."
	bindings = list(
		"honk",
		"synth-honk",
	)
	feedback_default = "<b>%%USER%%</b> honks."
	feedback_default_targeted = "<b>%%USER%%</b> honks at %%TARGET%%."
	sfx = 'sound/items/bikehorn.ogg'
	target_allowed = TRUE

// todo; name
/datum/emote/standard/basic/synth_sfx/gameover
	name = "Machine - Game Over"
	bindings = list(
		"gameover",
		"synth-gameover",
	)
	feedback_default = "<b>%%USER%%</b> crumples, their chassis colder and more lifeless than usual."
	sfx = 'sound/machines/synth_gameover.ogg'

// todo; name
/datum/emote/standard/basic/synth_sfx/xp_startup
	name = "Machine - Startup (XP)"
	bindings = list(
		"startup",
		"synth-startup",
	)
	feedback_default = "<b>%%USER%%</b> chimes to life."
	sfx = 'sound/machines/synth_startup.ogg'

// todo; name
/datum/emote/standard/basic/synth_sfx/xp_shutdown
	name = "Machine - Shutdown (XP)"
	bindings = list(
		"shutdown",
		"synth-shutdown",
	)
	feedback_default = "<b>%%USER%%</b> emits a nostalgic tone as they fall silent."
	sfx = 'sound/machines/synth_shutdown.ogg'

// todo; name, targeting
/datum/emote/standard/basic/synth_sfx/xp_error
	name = "Machine - Error (XP)"
	bindings = list(
		"error",
		"synth-error",
	)
	feedback_default = "<b>%%USER%%</b> experiences a system error."
	sfx = 'sound/machines/synth_error.ogg'
