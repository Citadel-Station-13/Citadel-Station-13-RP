//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/synth_sfx
	abstract_type = /datum/emote/standard/basic/synth_sfx

	binding_prefix = "synth"

	emote_require = EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	required_mobility_flags = MOBILITY_IS_CONSCIOUS

/datum/emote/standard/basic/synth_sfx/honk
	name = "Machine - Bike Horn"
	desc = "Emit a bike horn's honk."
	bindings = "honk"
	feedback_default = "<b>%%USER%%</b> honks."
	feedback_default_targeted = "<b>%%USER%%</b> honks at %%TARGET%%."
	sfx = 'sound/items/bikehorn.ogg'
	target_allowed = TRUE

// todo; name
/datum/emote/standard/basic/synth_sfx/gameover
	bindings = "gameover"
	feedback_default = "<b>%%USER%%</b> crumples, their chassis colder and more lifeless than usual."
	sfx = 'sound/machines/synth_gameoverp.ogg'

// todo; name
/datum/emote/standard/basic/synth_sfx/xp_startup
	bindings = "startup-xp"
	feedback_default = "<b>%%USER%%</b> chimes to life."
	sfx = 'sound/machines/synth_startup.ogg'

// todo; name
/datum/emote/standard/basic/synth_sfx/xp_shutdown
	bindings = "shutdown-xp"
	feedback_default = "<b>%%USER%%</b> emits a nostalgic tone as they fall silent."
	sfx = 'sound/machines/synth_shutdown.ogg'

// todo; name, targeting
/datum/emote/standard/basic/synth_sfx/xp_error
	bindings = "error-xp"
	feedback_default = "<b>%%USER%%</b> experiences a system error."
	sfx = 'sound/machines/synth_error.ogg'
