//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()
	if(fire_stacks)
		LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.is] soaking wet."))
	if(on_fire)
		LAZYADD(output.visible_descriptors, SPAN_DANGER("[gender_datum_visible.He] [gender_datum_visible.is] on fire!."))
	if(is_jittery)
		var/effective_jitteriness = get_effective_impairment_power_jitter()
		if(effective_jitteriness >= 300)
			LAZYADD(output.visible_descriptors, "[gender_datum_visible.He] [gender_datum_visible.is] convulsing violently")
		else if(effective_jitteriness >= 200)
			LAZYADD(output.visible_descriptors, "[gender_datum_visible.He] [gender_datum_visible.is] extremely jittery.")
		else if(effective_jitteriness >= 100)
			LAZYADD(output.visible_descriptors, "[gender_datum_visible.He] [gender_datum_visible.is] twitching ever so slightly.")

	//! vorestation start
	if(isliving(examine.examiner))
		var/mob/living/vr_casted_living = examine.examiner
		if(vr_casted_living.get_effective_size() - get_effective_size() >= 0.5)
			LAZYADD(examine.noticed_descriptors, SPAN_NOTICE("They are small enough that you could easily pick them up!"))
		if(vr_casted_living.get_effective_size() - get_effective_size() >= 0.75)
			LAZYADD(examine.noticed_descriptors, SPAN_WARNING("They are small enough that you could easily trample them!"))
	if(nif?.examine_msg)
		LAZYADD(examine.worn_descriptors, SPAN_NOTICE("[nif.examine_msg]"))
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		if(stat == DEAD)
			LAZYADD(examine.visible_descriptors, SPAN_WARNING("[gender_datum_visible.His] body is twitching subtly."))
		else
			LAZYADD(examine.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] appears to be in some sort of torpor."))
	if(feral)
		LAZYADD(examine.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] has a crazed, wild look in [gender_datum_visible.his] eyes."))
	if(bitten)
		LAZYADD(examine.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible ? "appear" : "appears"] to have two fresh puncture marks on [gender_datum_visible.his] neck."))
	//! end

	return output
