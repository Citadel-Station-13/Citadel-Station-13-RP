//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species/adherent
	abstract_type = /datum/emote/standard/basic/species/adherent
	required_species_id = /datum/species/adherent::id

/datum/emote/standard/basic/species/adherent/chime
	bindings = list(
		"achime",
		"adherent-chime",
	)
	sfx = 'sound/machines/achime.ogg'
	sfx_volume = 50
	feedback_default = "<b>%%USER%%</b> chimes!"
