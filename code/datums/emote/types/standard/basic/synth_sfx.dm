//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/synth_sfx
	abstract_type = /datum/emote/standard/basic/synth_sfx

	binding_prefix = "synth"

	emote_require = EMOTE_REQUIRE_SYNTHETIC_SPEAKER
	required_mobility_flags = MOBILITY_IS_CONSCIOUS

/datum/emote/standard/basic/synth_sfx/honk
	bindings = "honk"
	feedback_1_direct_append = "honks."
	sfx = 'sound/items/bikehorn.ogg'

/datum/emote/standard/basic/synth_sfx/gameover
	bindings = "gameover"
	feedback_1_direct_append = "crumples, their chassis colder and more lifeless than usual."
	sfx = 'sound/machines/synth_gameoverp.ogg'

/datum/emote/standard/basic/synth_sfx/xp_startup
	bindings = "startup-xp"
	feedback_1_direct_append = "chimes to life."
	sfx = 'sound/machines/synth_startup.ogg'

/datum/emote/standard/basic/synth_sfx/xp_shutdown
	bindings = "shutdown-xp"
	feedback_1_direct_append = "emits a nostalgic tone as they fall silent."
	sfx = 'sound/machines/synth_shutdown.ogg'

/datum/emote/standard/basic/synth_sfx/xp_error
	bindings = "error-xp"
	feedback_1_direct_append = "experiences a system error."
	sfx = 'sound/machines/synth_error.ogg'
