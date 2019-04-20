/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/Initialize(mapload)
	h_style = "Sergal Plain"
	return ..(mapload, "Sergal")

/mob/living/carbon/human/akula/Initialize(mapload)
	return ..(mapload, "Akula")

/mob/living/carbon/human/nevrean/Initialize(mapload)
	return ..(mapload, "Nevrean")

/mob/living/carbon/human/xenochimera/Initialize(mapload)
	return ..(mapload, "Xenochimera")

/mob/living/carbon/human/xenohybrid/Initialize(mapload)
	return ..(mapload, "Xenomorph Hybrid")

/mob/living/carbon/human/spider/Initialize(mapload)
	return ..(mapload, "Vasilissan")

/mob/living/carbon/human/vulpkanin/Initialize(mapload)
	return ..(mapload, "Vulpkanin")

/mob/living/carbon/human/protean/Initialize(mapload)
	return ..(mapload, "Protean")


/mob/living/carbon/human/alraune/Initialize(mapload)
	return ..(mapload, "Alraune")
