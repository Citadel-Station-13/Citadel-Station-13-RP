/**
 * * Data: list of raw antibodies as per definition in virus system
 * * Data: basically, i don't know what it is and i don't care, and neither does the reagent
 */
/datum/reagent/antibodies
	holds_data = TRUE
	name = "Antibodies"
	taste_description = "slime"
	id = "antibodies"
	reagent_state = REAGENT_LIQUID
	color = "#0050F0"
	mrate_static = TRUE

/datum/reagent/antibodies/make_copy_data_initializer(data)
	return data

/datum/reagent/antibodies/preprocess_data(data_initializer)
	return data_initializer

/datum/reagent/antibodies/mix_data(list/old_data, old_volume, list/new_data, new_volume, datum/reagent_holder/holder)
	if(old_data)
		if(new_data)
			return old_data | new_data
		return old_data
	else if(new_data)
		// new data is not mutable, so copy it for an owned reference
		return new_data.Copy()
	else
		return list()

/datum/reagent/antibodies/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(metabolism.legacy_data)
		M.antibodies |= metabolism.legacy_data
	..()

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	taste_description = "gross metal"
	reagent_state = REAGENT_LIQUID
	color = "#660000"

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/touch_turf(turf/T, amount)
	new /obj/effect/debris/cleanable/liquid_fuel(T, amount, FALSE)
	remove_self(amount)
	return

/datum/reagent/fuel/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(issmall(M)) removed *= 2
	M.adjustToxLoss(4 * removed)

/datum/reagent/fuel/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
