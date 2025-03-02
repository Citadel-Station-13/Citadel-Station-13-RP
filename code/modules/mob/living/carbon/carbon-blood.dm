//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Creates our blood.
 */
/mob/living/carbon/proc/create_blood()
	if(!blood_holder)
		blood_holder = new
	reset_blood_to_species()

/**
 * Hard resets our data to our 'natural' blood.
 *
 * @params
 * * do_not_regenerate - if set, do not reset to species.blood_volume, instead use current
 */
/mob/living/carbon/proc/reset_blood_to_species(do_not_regenerate)
	if(!blood_holder)
		return

	blood_holder.set_host_fragment_to(create_natural_blood_fragment())
	blood_holder.do_assimilate_all()
	if(!do_not_regenerate)
		blood_holder.set_host_volume(species.blood_volume)


/**
 * Imprint ourselves on an outgoing blood mixture.
 *
 * * Accepts null, for ease of use.
 *
 * @return the imprinted mixture
 */
/mob/living/carbon/proc/imprint_blood_mixture(datum/blood_mixture/mixture)
	if(!mixture)
		return null
	mixture.legacy_trace_chem = list2params(bloodstr.reagent_volumes)
	mixture.legacy_virus2 = virus_copylist(virus2)
	mixture.legacy_antibodies = antibodies?.Copy()
	return mixture

/**
 * Gets our blood mixture.
 *
 * todo: get_blood
 *
 * @return /datum/blood_mixture or null
 */
/mob/living/carbon/proc/get_blood_mixture() as /datum/blood_mixture
	var/datum/blood_mixture/mixture = blood_holder?.draw(0)
	if(!mixture)
		return
	imprint_blood_mixture(mixture)
	return mixture

/**
 * Regenerates our blood by a certain amount / volume.
 *
 * @return amount regenerated
 */
/mob/living/carbon/proc/regen_blood(amount)
	return blood_holder.adjust_host_volume(amount)

/**
 * [take_checked_blood_mixture] but fast,
 *
 * * This returns just a number, not the mixture.
 *
 * @return amount erased
 */
/mob/living/carbon/proc/erase_checked_blood(amount) as num
	return blood_holder.checked_erase(amount)

/**
 * [take_mixture] but fast,
 *
 * * This returns just a number, not the mixture.
 *
 * @return amount erased
 */
/mob/living/carbon/proc/erase_blood(amount) as num
	return blood_holder.erase(amount)


/**
 * Takes a blood mixture from ourselves.
 *
 * * Expensive
 * * Fails if we don't have enough.
 *
 * todo: take_checked_blood
 *
 * @params
 * * amount - amount to take
 * * infinite - allow taking any amount, don't actually remove any
 *
 * @return mixture or null
 */
/mob/living/carbon/proc/take_checked_blood_mixture(amount) as /datum/blood_mixture
	return imprint_blood_mixture(blood_holder?.checked_draw(amount))

/**
 * Takes a blood mixture from ourselves.
 *
 * * Expensive
 *
 * todo: take_blood
 *
 * @params
 * * amount - amount to take
 * * infinite - allow taking any amount, don't actually remove any
 *
 * @return mixture or null
 */
/mob/living/carbon/proc/take_blood_mixture(amount, infinite) as /datum/blood_mixture
	return imprint_blood_mixture(blood_holder?.draw(amount, infinite))

/**
 * Puts a blood mixture into ourselves.
 *
 * todo: give_blood
 *
 * @params
 * * mixture - mixture descriptor
 * * amount - the amount. defaults to the mixture's `ctx_return_amount`.
 *
 * @return amount given
 */
/mob/living/carbon/proc/give_blood_mixture(datum/blood_mixture/mixture, amount)
	if(!blood_holder)
		return 0
	if(isnull(amount))
		amount = mixture.ctx_return_amount

	// give them the blood
	blood_holder.inject_mixture(mixture, amount)
	// give them the sniffles
	var/list/i_hate_old_virology = virus_copylist(mixture.legacy_virus2)
	for(var/id in i_hate_old_virology)
		var/datum/disease2/the_coof = i_hate_old_virology[id]
		infect_virus2(src, the_coof, TRUE)
	// give them the anti-sniffles but only sometimes
	// yes this does mean IV drips are very good for this. too bad!
	// i don't care to deal with this dumb shit.
	if(length(mixture.legacy_antibodies) && prob(5))
		antibodies |= mixture.legacy_antibodies
	// this is very questionable but this does mean that you can cross-contaminate chemicals via blood
	// this dumb part is the chemicals aren't actually in the extracted reagent holder,
	// so this only .. does anything to humans.
	// oh well. here, let's fix this with this one simple trick:
	// todo: taking blood should generally draw out a bit of the reagents in someone's bloodstream,
	//       without using the trace chem system!
	var/list/decoded_trace_chem = params2list(mixture.legacy_trace_chem)
	for(var/id in decoded_trace_chem)
		var/volume_str = decoded_trace_chem[id]
		// the math here is weird; this means that this scales to blood volume and not bloodstream volume of
		// where it came from. oh well, we'll fix it later. it's called legacy_trace_chem for a reason.
		bloodstr.add_reagent(id, (text2num(volume_str) / species.blood_volume) * amount)

	return amount

/**
 * Makes a blood fragment of our natural blood
 */
/mob/living/carbon/proc/create_natural_blood_fragment()
	var/datum/blood_fragment/creating = new
	creating.legacy_blood_dna = dna.unique_enzymes
	creating.legacy_blood_type = dna.b_type
	creating.legacy_donor = src
	creating.legacy_species = isSynthetic() ? "synthetic" : species.name
	creating.legacy_name = species.get_blood_name(src)
	creating.color = species.get_blood_colour(src)
	return creating
