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

	//* Economy *//
	
	/// Raw intrinsic worth of this reagent
	var/worth = 0
	/// economic category of the reagent
	var/economic_category_reagent = ECONOMIC_CATEGORY_REAGENT_DEFAULT

	//* Effects

	/// path = number, converted to instance on init. number multiplied by amount removed.
	///
	/// only applied while in bloodstream
	var/list/datum/reagent_effect/effects
	/// path = number, converted to instance on init. number multiplied by amount removed.
	///
	/// only applied while in bloodstream
	var/list/datum/reagent_effect/effects_overdose
	
	//* Guidebook

	/// guidebook flags
	var/reagent_guidebook_flags = NONE
	/// guidebook category
	var/reagent_guidebook_category = "Unsorted"

	//* Identity

	/// our name - visible from guidebooks and to admins
	var/name = "Reagent"
	/// our description - visible from guidebooks and to admins
	var/description = "A non-descript chemical of some kind."
	/// player-facing name - visible via scan tools
	/// defaults to [name]
	/// overrides name in guidebook
	var/display_name
	/// player-facing desc - visible via scan tools
	/// defaults to [desc]
	/// overrides desc in guidebook
	var/display_description

	//* Metabolism
	
	/// multiplier to units metabolized, base.
	var/metabolism_multiplier = 1

	/// amount at which overdose begins; null for none.
	/// 
	/// only applies to bloodstream
	var/overdose_threshold
	/// multiplier to units while overdosing; compounded with base
	/// 
	/// only applies to bloodstream
	var/overdose_metabolism_multiplier = 1
	/// tox damage per unit metabolised when overdosing
	/// this is on top of any reagent effects, as this is the standard toxins damage
	/// this will be replaced someday.
	/// 
	/// only applies to bloodstream
	var/overdose_toxin_scaling = 2

	//* Properties

	/// specific heat in J*K/u (so joules needed to change 1 degree Kelvin per unit)
	var/specific_heat = 1.5

	//* Ticking
	
	#warn handle this
	/// Ticks in non-biological biologies
	var/tick_non_biological = FALSE
	/// Needs to on_dead_tick()
	var/tick_while_dead = FALSE

	//? legacy / unsorted
	var/taste_description = "bitterness"
	/// How this taste compares to others. Higher values means it is more noticable
	var/taste_mult = 1
	var/reagent_state = REAGENT_SOLID
	/// Used for vampric-Digestion
	var/blood_content = 0
	/// Organs that will slow the processing of this chemical.
	var/list/filtered_organs = list()
	///If the reagent should always process at the same speed, regardless of species, make this TRUE
	var/mrate_static = FALSE
	/// Does this chem process inside a corpse?
	var/affects_dead = 0
	/// Does this chem process inside a Synth?
	var/affects_robots = 0
	var/cup_icon_state = null
	var/cup_name = null
	var/cup_desc = null
	var/cup_center_of_mass = null

	var/color = "#000000"
	var/color_weight = 1

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	//? wiki markup generation additional
	//  todo: combine with guidebook 
	/// override "name"
	var/wiki_name
	/// override "desc"
	var/wiki_desc
	/// wiki category - determines what table to put it into
	var/wiki_category = "Miscellaneous"
	/// forced sort ordering in its category - falls back to name otherwise.
	var/wiki_sort = 0

/datum/reagent/New()
	#warn init effects

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
	var/removed = metabolism
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
				if(H.species.has_organ[O_HEART] && (active_metab.metabolism_class == REAGENT_APPLY_INJECT))
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

				if(H.species.has_organ[O_STOMACH] && (active_metab.metabolism_class == REAGENT_APPLY_INGEST))
					var/obj/item/organ/internal/stomach/Chamber = H.internal_organs_by_name[O_STOMACH]
					if(Chamber)
						ingest_rem_mult *= max(0.1, 1 - (Chamber.damage / Chamber.max_damage))
					else
						ingest_rem_mult = 0.1

				if(H.species.has_organ[O_INTESTINE] && (active_metab.metabolism_class == REAGENT_APPLY_INGEST))
					var/obj/item/organ/internal/intestine/Tube = H.internal_organs_by_name[O_INTESTINE]
					if(Tube)
						ingest_abs_mult *= max(0.1, 1 - (Tube.damage / Tube.max_damage))
					else
						ingest_abs_mult = 0.1

			else
				var/obj/item/organ/internal/heart/machine/Pump = H.internal_organs_by_name[O_PUMP]
				var/obj/item/organ/internal/stomach/machine/Cycler = H.internal_organs_by_name[O_CYCLER]

				if(active_metab.metabolism_class == REAGENT_APPLY_INJECT)
					if(Pump)
						removed *= 1.1 - Pump.damage / Pump.max_damage
					else
						removed *= 0.1

				else if(active_metab.metabolism_class == REAGENT_APPLY_INGEST) // If the pump is damaged, we waste chems from the tank.
					if(Pump)
						ingest_abs_mult *= max(0.25, 1 - Pump.damage / Pump.max_damage)

					else
						ingest_abs_mult *= 0.2

					if(Cycler) // If we're damaged, we empty our tank slower.
						ingest_rem_mult = max(0.1, 1 - (Cycler.damage / Cycler.max_damage))

					else
						ingest_rem_mult = 0.1

				else if(active_metab.metabolism_class == REAGENT_APPLY_TOUCH) // Machines don't exactly absorb chemicals.
					removed *= 0.5

			if(filtered_organs && filtered_organs.len && !mechanical_circulation)
				for(var/organ_tag in filtered_organs)
					var/obj/item/organ/internal/O = H.internal_organs_by_name[organ_tag]
					if(O && !O.is_broken() && prob(max(0, O.max_damage - O.damage)))
						removed *= 0.8
						if(active_metab.metabolism_class == REAGENT_APPLY_INGEST)
							ingest_rem_mult *= 0.8

	if(ingest_met && (active_metab.metabolism_class == REAGENT_APPLY_INGEST))
		removed = ingest_met * ingest_rem_mult
	if(touch_met && (active_metab.metabolism_class == REAGENT_APPLY_TOUCH))
		removed = touch_met
	removed = min(removed, volume)
	max_dose = max(volume, max_dose)
	dose = min(dose + removed, max_dose)
	if(removed >= (metabolism * 0.1) || removed >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(active_metab.metabolism_class)
			if(REAGENT_APPLY_INJECT)
				affect_blood(M, alien, removed)
			if(REAGENT_APPLY_INGEST)
				affect_ingest(M, alien, removed * ingest_abs_mult)
			if(REAGENT_APPLY_TOUCH)
				affect_touch(M, alien, removed)
	if(overdose && (volume > overdose) && (active_metab.metabolism_class != REAGENT_APPLY_TOUCH && !can_overdose_touch))
		overdose(M, alien, removed)
	remove_self(removed)
	return


// todo: fourth apply method of REAGENT_APPLY_VAPOR implementation?

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

//* Application *//

/**
 * called on splash, foam, vapor, etc
 * 
 * @params
 * * target - what we were splashed into
 * * volume - amount
 * * data - data list
 * * vapor - vapor application?
 * 
 * @return amount consumed
 */
/datum/reagent/proc/contact_expose_turf(turf/target, volume, list/data, vapor)
	return 0

/**
 * called on splash, foam, vapor, etc
 * 
 * @params
 * * target - what we were splashed into
 * * volume - amount
 * * data - data list
 * * vapor - vapor application?
 * 
 * @return amount consumed
 */
/datum/reagent/proc/contact_expose_obj(obj/target, volume, list/data, vapor)
	return 0

/**
 * called on splash or foam; for foam, this is called repeatedly.
 * 
 * @params
 * * target - what we were splashed into
 * * volume - amount
 * * data - data list
 * * organ_tag - the string tag of what organ this is localized on, if any; used for target splashing. if null, we can assume global.
 * 
 * @return amount consumed
 */
/datum/reagent/proc/touch_expose_mob(mob/target, volume, list/data, organ_tag)
	return 0

/**
 * called per tick while we're being inhaled or a mob is being exposed to us in a gas cloud
 * 
 * * WARNING * - this proc is called regardless of actual coverage. if you are doing skin burn effects,
 * make absolute sure you manually check for exposed areas!
 * 
 * @params
 * * target - what we were splashed into
 * * volume - amount
 * * data - data list
 * * inhaled - are we being inhaled? someone in a smoke cloud is exposed even if not inhaled, but inhales it if they're not on internals.
 * 
 * @return amount consumed
 */
/datum/reagent/proc/vapor_expose_mob(mob/target, volume, list/data, inhaled)
	return

/**
 * Called when something is trying to inject / add us into a metabolized holder
 * 
 * @params
 * * entity - the victim
 * * application - the REAGENT_APPLY_* flags
 * * organ_tag - the string tag of what organ this is localized in, if any; mostly used for touch/skin/surface.
 * * volume - amount to add
 * * data - data list
 * 
 * @return units to add into the holder normally.
 */
/datum/reagent/proc/applying_to_metabolism(mob/living/carbon/entity, application, organ_tag, volume, list/data)
	return volume 

//* Data *//

/**
 * Called when we're being added to something for the first time
 *
 * @params
 * * holder - (optional) the holder we're going in, if any.
 * * amount - our amount
 */
/datum/reagent/proc/init_data(datum/reagent_holder/holder, amount)
	return list()

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

//* Metabolism *//

/**
 * Called when we start metabolizing in a mob. (first add)
 * 
 * @params
 * * entity - the victim
 * * application - the REAGENT_APPLY_* flags
 * * metabolism - the /datum/reagent_metabolism data; the overdose_cycles will be incremented automatically.
 * * organ_tag - the string tag of what organ this is localized in, if any; mostly used for touch/skin/surface.
 * * data - data list
 */
/datum/reagent/proc/on_metabolize_add(mob/living/carbon/entity, application, datum/reagent_metabolism/metabolism, organ_tag, list/data)
	return
	#warn hook

/**
 * Called when we stop metabolizing in a mob. (on remove)
 * 
 * @params
 * * entity - the victim
 * * application - the REAGENT_APPLY_* flags
 * * metabolism - the /datum/reagent_metabolism data; the overdose_cycles will be incremented automatically.
 * * organ_tag - the string tag of what organ this is localized in, if any; mostly used for touch/skin/surface.
 * * data - data list
 */
/datum/reagent/proc/on_metabolize_remove(mob/living/carbon/entity, application, datum/reagent_metabolism/metabolism, organ_tag, list/data)
	return
	#warn hook

/**
 * Called on life ticks during mob metabolism.
 * 
 * @params
 * * entity - the victim
 * * metabolism - the /datum/reagent_metabolism data; the overdose_cycles will be incremented automatically.
 * * removed - amount of volume being processed
 * * data - data list
 * 
 * @return amount actually used
 */
/datum/reagent/proc/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)	
	if(metabolism.overdosing)
		// default overdose effects
		if(overdose_toxin_scaling)
			entity.adjustToxLoss(removed * overdose_toxin_scaling)
	#warn rework above
	#warn hook

/**
 * Called on life ticks during mob metabolism.
 * 
 * This is usually used for ingestion into stomachs
 * 
 * @params
 * * entity - the victim
 * * metabolism - the /datum/reagent_metabolism data; the overdose_cycles will be incremented automatically.
 * * removed - amount of volume being processed
 * * data - data list
 * * container - the internal organ this is inside
 * 
 * @return amount actually used
 */
/datum/reagent/proc/on_metabolize_internal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)	
	if(metabolism.overdosing)
		// default overdose effects
		if(overdose_toxin_scaling)
			entity.adjustToxLoss(removed * overdose_toxin_scaling)
	#warn rework above
	#warn hook

/**
 * Called on life ticks during mob metabolism.
 * 
 * @params
 * * entity - the victim
 * * metabolism - the /datum/reagent_metabolism data; the overdose_cycles will be incremented automatically.
 * * removed - amount of volume being processed
 * * data - data list
 * * bodypart - the external organ this is inside
 * 
 * @return amount actually used
 */
/datum/reagent/proc/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	if(metabolism.overdosing)
		// default overdose effects
		if(overdose_toxin_scaling)
			entity.adjustToxLoss(removed * overdose_toxin_scaling)
	#warn rework above
	#warn hook

//* Mixing *//
 
/**
 * called when a new reagent is being mixed with this one to mix our data lists.
 *
 * this may not be called if the data is the exact same!
 *
 * @params
 * * holder - (optional) the holder we're mixing in, if any.
 * * current_data - our current data. not necessarily a list, only typecasted to one.
 * * current_amount - our current amount
 * * new_data - new inbound data. not necessarily a list, only typedcasted to one.
 * * new_amount - the amount that's coming in, not what we will be at after mixing.
 */
/datum/reagent/proc/mix_data(datum/reagent_holder/holder, list/current_data, current_amount, list/new_data, new_amount)
	return

#warn LINTER FODDER
/datum/reagent/proc/affect_blood()
	SHOULD_NOT_OVERRIDE(TRUE)
/datum/reagent/proc/affect_touch()
	SHOULD_NOT_OVERRIDE(TRUE)
/datum/reagent/proc/affect_ingest()
	SHOULD_NOT_OVERRIDE(TRUE)
/datum/reagent/proc/touch_turf()
	SHOULD_NOT_OVERRIDE(TRUE)
/datum/reagent/proc/touch_obj()
	SHOULD_NOT_OVERRIDE(TRUE)
/datum/reagent/proc/touch_mob()
	SHOULD_NOT_OVERRIDE(TRUE)
