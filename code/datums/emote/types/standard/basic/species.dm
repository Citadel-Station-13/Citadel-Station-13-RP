//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/species
	abstract_type = /datum/emote/standard/basic/species
	emote_class = EMOTE_CLASS_IS_HUMANOID
	/// required species id or list of ids
	///
	/// * these are ids, not uids.
	var/required_species_id

/datum/emote/standard/basic/species/can_potentially_use(datum/event_args/actor/actor, use_emote_class)
	if(!check_species(actor.performer))
		return FALSE
	return ..()

/datum/emote/standard/basic/species/can_use_special(datum/event_args/actor/actor, list/arbitrary, list/out_reasons_fail)
	if(!required_species_id)
		return ..()
	if(!actor?.performer)
		return ..()
	if(!check_species(actor.performer))
		out_reasons_fail?.Add("incorrect species")
		return FALSE
	return ..()

/datum/emote/standard/basic/species/proc/check_species(mob/actor)
	var/mob/living/carbon/human/human = actor
	if(!istype(human))
		return FALSE
	if(islist(required_species_id))
		if(!(human.species.id in required_species_id))
			return FALSE
	else
		if(!(human.species.id == required_species_id))
			return FALSE
	return TRUE
