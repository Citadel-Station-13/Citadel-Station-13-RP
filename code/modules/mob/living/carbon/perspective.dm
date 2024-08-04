//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? Darksight

/mob/living/carbon/innate_vision()
	if(isnull(species))
		return GLOB.default_darksight
	species.assert_innate_vision()
	return vision_override || species.vision_innate
