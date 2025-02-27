GLOBAL_LIST_INIT(name2reagent, build_name2reagent())

/proc/build_name2reagent()
	. = list()
	for (var/t in subtypesof(/datum/reagent))
		var/datum/reagent/R = t
		if (length(initial(R.name)))
			.[ckey(initial(R.name))] = t


/datum/reagent
	abstract_type = /datum/reagent

	//* Core
	/// id - must be unique and in CamelCase.
	var/id
	/// reagent flags - see [code/__DEFINES/reagents/flags.dm]
	var/reagent_flags = NONE

	//* Color *//
	/// our reagent color
	var/color = "#000000"
	/// multiplier to effective volume when calculating color
	var/color_weight = 1

	//* Data *//
	/// Supports data system.
	/// * If data is supported, the data must be
	///   a primitive (number, string),
	///   a datum implementing clone(), or
	///   a list with the same semantics.
	var/holds_data = FALSE

	//* Economy *//
	/// Raw intrinsic worth of this reagent
	var/worth = 0
	/// economic category of the reagent
	var/economic_category_reagent = ECONOMIC_CATEGORY_REAGENT_DEFAULT

	//* Identity *//
	/// our name - visible from guidebooks and to admins
	var/name = "Reagent"
	/// our description - visible from guidebooks and to admins
	var/description = "A non-descript chemical of some kind."
	/// defaults to [name]
	/// overrides name in guidebook
	var/display_name
	/// player-facing desc - visible via scan tools
	/// defaults to [desc]
	/// overrides desc in guidebook
	var/display_description

	//* Filtering *//
	/// reagent filter flags - dynamic flags used for simulations of filtration/identification/detection
	///
	/// * used for a lot of things
	/// * REAGENT_FILTER_GENERIC is a default because this allows us to have a single 'flags' on filter,
	///   instead of a 'include flags' and 'exclude flags'.
	var/reagent_filter_flags = REAGENT_FILTER_GENERIC

	//* Guidebook
	/// guidebook flags
	var/reagent_guidebook_flags = NONE
	/// guidebook category
	var/reagent_guidebook_category = "Unsorted"

	//? legacy / unsorted
	var/glass_icon_state = null
	var/glass_center_of_mass = null
	var/taste_description = "bitterness"
	/// How this taste compares to others. Higher values means it is more noticable
	var/taste_mult = 1
	var/reagent_state = REAGENT_SOLID
	var/metabolism_rate = REM // This would be 0.2 normally
	/// Used for vampric-Digestion
	var/blood_content = 0
	/// Organs that will slow the processing of this chemical.
	var/list/filtered_organs = list()
	///If the reagent should always process at the same speed, regardless of species, make this TRUE
	var/mrate_static = FALSE
	var/ingest_met = 0
	var/touch_met = 0
	///Amount at which overdose starts
	var/overdose = 0
	///Modifier to overdose damage
	var/overdose_mod = 2
	/// Can the chemical OD when processing on touch?
	var/can_overdose_touch = FALSE
	/// Shows up on health analyzers.
	var/scannable = 0
	/// Does this chem process inside a corpse?
	var/affects_dead = 0
	/// Does this chem process inside a Synth?
	var/affects_robots = 0
	var/cup_icon_state = null
	var/cup_name = null
	var/cup_desc = null
	var/cup_center_of_mass = null

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	//? wiki markup generation additional
	/// override "name"
	var/wiki_name
	/// override "desc"
	var/wiki_desc
	/// wiki category - determines what table to put it into
	var/wiki_category = "Miscellaneous"
	/// forced sort ordering in its category - falls back to name otherwise.
	var/wiki_sort = 0

/// Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/datum/reagent_holder/metabolism/location, speed_mult = 1, force_allow_dead)
	if(!istype(M))
		return
	if(!affects_dead && M.stat == DEAD && !force_allow_dead)
		return
	if(!affects_robots && M.isSynthetic())
		return
	if(!istype(location))
		return

	var/datum/reagent_holder/metabolism/active_metab = location
	var/removed = metabolism_rate
	var/mechanical_circulation = HAS_TRAIT(M, TRAIT_MECHANICAL_CIRCULATION)

	var/ingest_rem_mult = 1
	var/ingest_abs_mult = 1

	if(!mrate_static == TRUE)
		// Modifiers
		for(var/datum/modifier/mod in M.modifiers)
			if(!isnull(mod.metabolism_percent))
				removed *= mod.metabolism_percent
				ingest_rem_mult *= mod.metabolism_percent
		// Species
		removed *= M.species.metabolic_rate
		ingest_rem_mult *= M.species.metabolic_rate
		// Metabolism
		removed *= active_metab.metabolism_speed
		ingest_rem_mult *= active_metab.metabolism_speed
		// hard mult
		removed *= speed_mult
		ingest_rem_mult *= speed_mult

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.isSynthetic())
				if(H.species.has_organ[O_HEART] && (active_metab.metabolism_class == CHEM_INJECT))
					var/obj/item/organ/internal/heart/Pump = H.internal_organs_by_name[O_HEART]
					// todo: completely optimize + refactor metabolism, none of these checks should be in here
					if(mechanical_circulation)
						// no bad heart penalties
					else if(!Pump)
						removed *= 0.1
					else if(Pump.standard_pulse_level == PULSE_NONE) // No pulse normally means chemicals process a little bit slower than normal.
						removed *= 0.8
					else // Otherwise, chemicals process as per percentage of your current pulse, or, if you have no pulse but are alive, by a miniscule amount.
						removed *= max(0.1, H.pulse / Pump.standard_pulse_level)

				if(H.species.has_organ[O_STOMACH] && (active_metab.metabolism_class == CHEM_INGEST))
					var/obj/item/organ/internal/stomach/Chamber = H.internal_organs_by_name[O_STOMACH]
					if(Chamber)
						ingest_rem_mult *= max(0.1, 1 - (Chamber.damage / Chamber.max_damage))
					else
						ingest_rem_mult = 0.1

				if(H.species.has_organ[O_INTESTINE] && (active_metab.metabolism_class == CHEM_INGEST))
					var/obj/item/organ/internal/intestine/Tube = H.internal_organs_by_name[O_INTESTINE]
					if(Tube)
						ingest_abs_mult *= max(0.1, 1 - (Tube.damage / Tube.max_damage))
					else
						ingest_abs_mult = 0.1

			else
				var/obj/item/organ/internal/heart/machine/Pump = H.internal_organs_by_name[O_PUMP]
				var/obj/item/organ/internal/stomach/machine/Cycler = H.internal_organs_by_name[O_CYCLER]

				if(active_metab.metabolism_class == CHEM_INJECT)
					if(Pump)
						removed *= 1.1 - Pump.damage / Pump.max_damage
					else
						removed *= 0.1

				else if(active_metab.metabolism_class == CHEM_INGEST) // If the pump is damaged, we waste chems from the tank.
					if(Pump)
						ingest_abs_mult *= max(0.25, 1 - Pump.damage / Pump.max_damage)

					else
						ingest_abs_mult *= 0.2

					if(Cycler) // If we're damaged, we empty our tank slower.
						ingest_rem_mult = max(0.1, 1 - (Cycler.damage / Cycler.max_damage))

					else
						ingest_rem_mult = 0.1

				else if(active_metab.metabolism_class == CHEM_TOUCH) // Machines don't exactly absorb chemicals.
					removed *= 0.5

			if(filtered_organs && filtered_organs.len && !mechanical_circulation)
				for(var/organ_tag in filtered_organs)
					var/obj/item/organ/internal/O = H.internal_organs_by_name[organ_tag]
					if(O && !O.is_broken() && prob(max(0, O.max_damage - O.damage)))
						removed *= 0.8
						if(active_metab.metabolism_class == CHEM_INGEST)
							ingest_rem_mult *= 0.8

	if(ingest_met && (active_metab.metabolism_class == CHEM_INGEST))
		removed = ingest_met * ingest_rem_mult
	if(touch_met && (active_metab.metabolism_class == CHEM_TOUCH))
		removed = touch_met
	var/volume = location.reagent_volumes[id]
	var/datum/reagent_metabolism/metabolism = location.reagent_metabolisms[id]
	removed = min(removed, volume)
	metabolism.peak_dose = max(volume, metabolism.peak_dose)
	metabolism.total_processed_dose = min(metabolism.peak_dose, metabolism.total_processed_dose + removed)
	metabolism.cycles_so_far++
	metabolism.legacy_volume_remaining = volume
	metabolism.legacy_data = location.reagent_datas?[id]
	metabolism.legacy_current_holder = active_metab
	if(removed >= (metabolism_rate * 0.1) || removed >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(active_metab.metabolism_class)
			if(CHEM_INJECT)
				legacy_affect_blood(M, alien, removed, metabolism)
			if(CHEM_INGEST)
				legacy_affect_ingest(M, alien, removed * ingest_abs_mult, metabolism)
			if(CHEM_TOUCH)
				legacy_affect_touch(M, alien, removed, metabolism)
	if(overdose && (volume > overdose) && (active_metab.metabolism_class != CHEM_TOUCH && !can_overdose_touch))
		metabolism.cycles_overdosing++
		legacy_affect_overdose(M, alien, removed, metabolism)
	else
		metabolism.cycles_overdosing = 0
	metabolism.legacy_current_holder = null
	active_metab.remove_reagent(id, removed)

/datum/reagent/proc/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	return

/datum/reagent/proc/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.bloodstr.add_reagent(id, removed)
	return

/datum/reagent/proc/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	return

/datum/reagent/proc/handle_vampire(var/mob/living/carbon/M, var/alien, var/removed, var/is_vampire)
	if(blood_content > 0 && is_vampire)
		#define blud_warn_timer 3000
		if(blood_content < 4) //Are we drinking real blood or something else?
			if(M.nutrition <= 0.333 * M.species.max_nutrition || M.nutrition > 0.778 * M.species.max_nutrition) //Vampires who are starving or peckish get nothing from fake blood.
				if(M.last_blood_warn + blud_warn_timer < world.time)
					to_chat(M, "<span class='warning'>This isn't enough. You need something stronger.</span>")
					M.last_blood_warn = world.time //If we're drinking fake blood, make sure we're warned appropriately.
				return
		M.nutrition += removed * blood_content //We should always be able to process real blood.

/datum/reagent/proc/legacy_affect_overdose(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		overdose_mod *= H.species.chemOD_mod
	M.adjustToxLoss(removed * overdose_mod)

//* Color *//

/**
 * Only called if holds_data is TRUE.
 */
/datum/reagent/proc/compute_color_with_data(data)
	return color

//* Data *//

/**
 * Get data to feed in as the `data_initializer` during a reagents transfer.
 *
 * * `data` is not considered mutable. You may not edit it in this proc.
 * * Do not modify the returned value. It is not considered mutable.
 *
 * @return an initializer. This initializer is not mutable.
 */
/datum/reagent/proc/make_copy_data_initializer(data)
	return null

/**
 * Preprocess data fed in during add_reagent
 *
 * * `data_initializer` is not considered mutable. You may not edit it in this proc.
 * * Do not modify the returned value. It is not considered mutable.
 *
 * @return data to put into mix_data. This data is immutable.
 */
/datum/reagent/proc/preprocess_data(data_initializer)
	return null

/**
 * Mixes data
 *
 * * in add_reagent, this is called with the preprocessed new data
 * * in transfer procs, this is called with the old data
 * * this is not called if there's no reagents of ourselves in the new container.
 * * `old_data` is considered mutable. `new_data` is not. This is becuase `old_data` belongs to the holder
 *   calling us, but `new_data` can potentially be a shared struct.
 *
 * @params
 * * old_data - existing data; null if not there
 * * old_volume - existing volume; 0 if not there
 * * new_data - adding data; this is from the returns of `preprocess_data()`
 * * new_volume - adding volume
 * * holder - (optional) the holder we're mixing in, if any
 *
 * @return overall data to assign to reagent
 */
/datum/reagent/proc/mix_data(old_data, old_volume, new_data, new_volume, datum/reagent_holder/holder)
	return null

//* Guidebook *//

/**
 * Guidebook Data for TGUIGuidebookReagent
 */
/datum/reagent/proc/tgui_guidebook_data()
	return list(
		"id" = id,
		"name" = display_name || name,
		"desc" = display_description || description,
		"category" = reagent_guidebook_category,
		"flags" = reagent_flags,
		"guidebookFlags" = reagent_guidebook_flags,
		// todo: should this be here?
		"alcoholStrength" = null,
	)

//* Identity *//

/**
 * Get name from data
 * * May be skipped if reagent has no data semantics.
 *
 * @params
 * * data - the data. It can be casted to the expected type as needed.
 */
/datum/reagent/proc/compute_name_with_data(data)
	return name

//* Touch *//

/**
 * Called when we're sprayed / splashed onto an obj
 *
 * @params
 * * target - turf
 * * remaining - how much is being applied / is remaining / is in the container right now
 * * allocated - how much is supposed to be hitting the obj (useful for sprays)
 *               this might be over remaining, due to how call order works. always check remaining.
 * * data - our reagent data, if any
 *
 * todo: add temperature
 *
 * @return amount used, if any
 */
/datum/reagent/proc/on_touch_obj(obj/target, remaining, allocated, data)
	return 0

/**
 * Called when we're sprayed / splashed onto a turf
 *
 * @params
 * * target - turf
 * * remaining - how much is being applied / is remaining / is in the container right now
 * * allocated - how much is supposed to be hitting the turf (useful for sprays)
 *               this might be over remaining, due to how call order works. always check remaining.
 * * data - our reagent data, if any
 *
 * todo: add temperature
 *
 * @return amount used, if any
 */
/datum/reagent/proc/on_touch_turf(turf/target, remaining, allocated, data)
	return 0

/**
 * This should only be called when the reagent reaches the mob's skin / whatever, not before.
 *
 * * Do not manually implement splashing if a limb is specified. The caller does this already.
 *
 * @params
 * * target - the mob
 * * remaining - how much is left in the thing being splashed.
 * * allocated - how much is supposed to be hitting the target limb (useful for sprays).
 *               this might be over remaining, due to how call order works. always check remaining.
 *               it might be useful to subtract from this in overrides before invoking ..() sometimes.
 * * data - our reagent data, if any
 * * zone - (optional) the body zone targeted
 *
 * todo: add temperature
 *
 * @return amount used, if any
 */
/datum/reagent/proc/on_touch_mob(mob/target, remaining, allocated, data, zone)
	return 0
