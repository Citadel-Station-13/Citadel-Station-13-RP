//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/synth_cell_charging_supported()
	return !!isSynthetic()

/mob/living/carbon/synth_cell_charging_max_power_flow()
	return isSynthetic() ? 2000 : 0

/mob/living/carbon/synth_cell_charging_give_power(joules)
	if(!isSynthetic())
		return 0
	// static nutrition efficiency
	// for now, a medium cell can charge a synth twice
	var/joules_per_nutrition = \
	(STATIC_CELL_UNITS_TO_J(POWER_CELL_CAPACITY_MEDIUM) / /datum/species::max_nutrition) \
	* (1 / 2)

	var/missing_nutrition = species.max_nutrition - nutrition
	if(missing_nutrition < 0)
		return
	var/restore_nutrition = min(missing_nutrition, joules / joules_per_nutrition)
	adjust_nutrition(restore_nutrition)
	. = restore_nutrition * joules_per_nutrition
