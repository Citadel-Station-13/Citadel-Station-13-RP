//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species
	abstract_type = /datum/emote/standard/basic/species
	/// required species id or list of ids
	///
	/// * these are ids, not uids.
	var/required_species_id

/datum/emote/standard/basic/species/can_use_special(datum/event_args/actor/actor, arbitrary)
	if(!required_species_id)
		return ..()
	var/mob/living/carbon/human/human = actor?.performer
	if(!human)
		return ..()
	if(islist(required_species_id))
		if(!(human.species.id in required_species_id))
			return FALSE
	else
		if(!(human.species.id == required_species_id))
			return FALSE
	return ..()


