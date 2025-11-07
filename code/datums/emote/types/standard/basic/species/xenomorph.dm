//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species/xenomorph
	abstract_type = /datum/emote/standard/basic/species/xenomorph
	required_species_id = list(
		/datum/species/xenos::id,
		/datum/species/xenohybrid::id,
	)

/datum/emote/standard/basic/species/promethean/check_species(mob/actor)
	if(istype(actor, /mob/living/simple_mob/animal/space/xenomorph))
		return TRUE
	return ..()

/datum/emote/standard/basic/species/xenomorph/xhiss
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/alien_hiss3.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss",
		"xeno-hiss",
	)

/datum/emote/standard/basic/species/xenomorph/xroar
	feedback_default = "<b>%%USER%%</b> roars!"
	sfx = 'sound/voice/xenos/alien_roar1.ogg'
	sfx_volume = 50
	bindings = list(
		"xroar",
		"xeno-roar",
	)

/datum/emote/standard/basic/species/xenomorph/xhiss2
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xhiss2.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss2",
		"xeno-hiss2",
	)

/datum/emote/standard/basic/species/xenomorph/xhiss3
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xhiss3.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss3",
		"xeno-hiss3",
	)

/datum/emote/standard/basic/species/xenomorph/xhiss4
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xhiss4.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss4",
		"xeno-hiss4",
	)

/datum/emote/standard/basic/species/xenomorph/xhiss5
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xhiss5.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss5",
		"xeno-hiss5",
	)

/datum/emote/standard/basic/species/xenomorph/xhiss6
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xhiss6.ogg'
	sfx_volume = 50
	bindings = list(
		"xhiss6",
		"xeno-hiss6",
	)

/datum/emote/standard/basic/species/xenomorph/xroar1
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xroar1.ogg'
	sfx_volume = 50
	bindings = list(
		"xroar1",
		"xeno-roar1",
	)

/datum/emote/standard/basic/species/xenomorph/xroar2
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xroar2.ogg'
	sfx_volume = 50
	bindings = list(
		"xroar2",
		"xeno-roar2",
	)

/datum/emote/standard/basic/species/xenomorph/xroar3
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xroar3.ogg'
	sfx_volume = 50
	bindings = list(
		"xroar3",
		"xeno-roar3",
	)

/datum/emote/standard/basic/species/xenomorph/xtalk1
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xtalk1.ogg'
	sfx_volume = 50
	bindings = list(
		"xtalk1",
		"xeno-talk1",
	)

/datum/emote/standard/basic/species/xenomorph/xtalk2
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xtalk2.ogg'
	sfx_volume = 50
	bindings = list(
		"xtalk2",
		"xeno-talk2",
	)

/datum/emote/standard/basic/species/xenomorph/xtalk3
	feedback_default = "<b>%%USER%%</b> hisses!"
	sfx = 'sound/voice/xenos/xtalk3.ogg'
	sfx_volume = 50
	bindings = list(
		"xtalk3",
		"xeno-talk3",
	)

/datum/emote/standard/basic/species/xenomorph/xroar
	feedback_default = "<b>%%USER%%</b> roars!"
	sfx = 'sound/voice/xenos/alien_roar1.ogg'
	sfx_volume = 50
	bindings = list(
		"xroar",
		"xeno-roar",
	)

/datum/emote/standard/basic/species/xenomorph/xgrowl
	feedback_default = "<b>%%USER%%</b> growls!"
	sfx = 'sound/voice/xenos/alien_growl1.ogg'
	sfx_volume = 50
	bindings = list(
		"xgrowl",
		"xeno-growl",
	)
