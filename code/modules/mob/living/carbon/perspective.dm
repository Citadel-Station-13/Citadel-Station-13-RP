//? Darksight

/mob/living/carbon/innate_darksight()
	if(isnull(species))
		return GLOB.default_darksight
	species.assert_innate_darksight()
	return vision_override || species.vision_innate
