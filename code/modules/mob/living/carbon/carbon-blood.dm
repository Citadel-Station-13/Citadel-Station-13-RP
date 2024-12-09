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
 * * do_not_purge - do not purge all traces like antibodies and viruses.
 */
/mob/living/carbon/proc/reset_blood_to_species(do_not_regenerate, do_not_purge)
	if(!blood_holder)
		return

	if(!do_not_purge)
		blood_holder.legacy_trace_chem = null
		blood_holder.legacy_virus2 = null
		blood_holder.legacy_antibodies = list()

	if(!do_not_regenerate)
		blood_holder.set_host_volume(species.blood_volume)

	blood_holder.set_host_fragment_to(create_natural_blood_fragment())

/**
 * Takes a blood mixture from ourselves.
 *
 * @params
 * * amount - amount to take
 * * infinite - allow taking any amount, don't actually remove any
 *
 * @return mixture or null
 */
/mob/living/carbon/proc/take_blood_mixture(amount, infinite) as /datum/blood_mixture
	return blood_holder?.take_blood_mixture(amount, infinite)

/**
 * Puts a blood mixture into ourselves.
 *
 * @params
 * * mixture - mixture descriptor
 * * amount - the amount. defaults to the mixture's `ctx_return_amount`.
 */
/mob/living/carbon/proc/give_blood_mixture(datum/blood_mixture/mixture, amount)
	if(isnull(amount))
		amount = mixture.ctx_return_amount
	#warn impl

/**
 * Makes a blood fragment of our natural blood
 */
/mob/living/carbon/proc/create_natural_blood_fragment()
	var/datum/blood_fragment/creating = new
	creating.legacy_blood_dna = dna.unique_enzymes
	creating.legacy_blood_type = dna.b_type
	creating.legacy_donor = src
	creating.legacy_species = isSynthetic() ? "synthetic" : species.name
	#warn how to deal with name / color?
	creating.legacy_name = species.get_blood_name(src)
	creating.color = species.get_blood_colour(src)
	return creating
