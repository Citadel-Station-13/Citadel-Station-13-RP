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
			LAZYADD(output.noticed_descriptors, SPAN_NOTICE("They are small enough that you could easily pick them up!"))
		if(vr_casted_living.get_effective_size() - get_effective_size() >= 0.75)
			LAZYADD(output.noticed_descriptors, SPAN_WARNING("They are small enough that you could easily trample them!"))
	if(nif?.examine_msg)
		LAZYADD(output.worn_descriptors, SPAN_NOTICE("[nif.examine_msg]"))
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		if(stat == DEAD)
			LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.His] body is twitching subtly."))
		else
			LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] appears to be in some sort of torpor."))
	if(feral)
		LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] has a crazed, wild look in [gender_datum_visible.his] eyes."))
	if(bitten)
		LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible ? "appear" : "appears"] to have two fresh puncture marks on [gender_datum_visible.his] neck."))
	if(show_pudge())
		for(var/obj/belly/belly in vore_organs)
			var/maybe_belly_text = belly.get_examine_msg()
			if(maybe_belly_text)
				LAZYADD(output.visible_descriptors, maybe_belly_text)
	//! end

	if(client && (client.is_afk() > 10 MINUTES))
		LAZYADD(output.ooc_descriptors, SPAN_INFO("\[Inactive for [round(client.inactivity / (1 MINUTES), 1)] minutes.\]"))
	else if(ssd_visible && !client && stat != DEAD)
		// todo: this logic is meh
		var/maybe_ssd_message = species.get_ssd(src)
		if(maybe_ssd_message)
			LAZYADD(output.ooc_descriptors, SPAN_DEADSAY("[gender_datum_visible.He] [gender_datum_visible.is] [maybe_ssd_message]. [ckey ? "" : "It doesn't look like [gender_datum_visible.he] [gender_datum_visible.is] waking up anytime soon."]"))
		if(ckey && disconnect_time)
			LAZYADD(output.ooc_descriptors, SPAN_INFO("\[Disconnected/ghosted [round((REALTIMEOFDAY - disconnect_time) / (1 MINUTES), 1)] minutes ago. \]"))


	return output
