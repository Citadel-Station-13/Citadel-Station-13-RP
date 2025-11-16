//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/general/cough
	emote_class = EMOTE_CLASS_IS_HUMANOID
	name = "Cough"
	desc = "Cough."
	bindings = "cough"
	emote_require = EMOTE_REQUIRE_VOCALIZATION
	feedback_default = "<b>%%USER%%</b> coughs."
	feedback_default_audible = "You hear a cough."
	feedback_special_miming = "<b>%%USER%%</b> appears to cough."
	feedback_special_muzzled = "<b>%%USER%%</b> makes a strong noise."
	feedback_special_muzzled_audible = "You hear a strong noise."

/datum/emote/standard/basic/general/cough/get_sfx(datum/event_args/actor/actor, list/arbitrary)
	var/robotic = FALSE
	var/mob/casted_mob = actor.performer
	if(iscarbon(casted_mob))
		var/mob/living/carbon/casted_carbon = casted_mob
		var/obj/item/organ/internal/maybe_lungs = casted_carbon.organs_by_name[O_LUNGS]
		if(maybe_lungs.robotic >= ORGAN_ROBOT)
			robotic = TRUE
	else
		if(casted_mob.isSynthetic())
			robotic = TRUE
	// yes another check because this will be modularized out later to a gender/robotic lookup,
	// then a sound lookup.
	if(iscarbon(casted_mob))
		var/mob/living/carbon/casted_carbon = casted_mob
		if(robotic)
			if(casted_carbon.get_gender() == FEMALE)
				return 'sound/effects/mob_effects/m_machine_cougha.ogg'
			else
				return 'sound/effects/mob_effects/f_machine_cougha.ogg'
		else
			if(casted_carbon.get_gender() == FEMALE)
				return casted_carbon.species?.female_cough_sounds
			else
				return casted_carbon.species?.male_cough_sounds
