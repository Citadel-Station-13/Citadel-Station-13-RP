//? Darksight

/mob/living/carbon/innate_darksight()
	if(isnull(species))
		return GLOB.default_darksight
	species.assert_innate_darksight()
	return darksight_override || species.darksight_innate
