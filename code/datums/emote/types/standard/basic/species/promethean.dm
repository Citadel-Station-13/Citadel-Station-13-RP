//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species/promethean
	abstract_type = /datum/emote/standard/basic/species/promethean
	binding_prefix = "slime"
	required_species_id = /datum/species/shapeshifter/promethean::id

/datum/emote/standard/basic/species/promethean/check_species(mob/actor)
	if(istype(actor, /mob/living/simple_mob/slime))
		return TRUE
	return ..()

/datum/emote/standard/basic/species/promethean/squish
	bindings = "squish"
	feedback_saycode_type = SAYCODE_TYPE_VISIBLE
	feedback_default = "%%USER%% squishes."
	sfx = 'sound/effects/slime_squish.ogg'
	sfx_volume = 50
