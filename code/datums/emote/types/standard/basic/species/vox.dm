//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species/vox
	abstract_type = /datum/emote/standard/basic/species/vox
	required_species_id = /datum/species/vox::id

/datum/emote/standard/basic/species/vox/shriek_loud
	bindings = list(
		"shriekloud",
		"vox-shriek-loud",
	)
	sfx = 'sound/voice/shrieksneeze.ogg'
	sfx_volume = 50
	feedback_default = "<b>%%USER%%</b> gives a short sharp shriek!"

/datum/emote/standard/basic/species/vox/shriek_quiet
	bindings = list(
		"shrieksoft",
		"vox-shriek-soft",
	)
	sfx = 'sound/voice/shriekcough.ogg'
	sfx_volume = 50
	feedback_default = "<b>%%USER%%</b> gives a short, quieter shriek!"


