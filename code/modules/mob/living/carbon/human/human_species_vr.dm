/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/Initialize(mapload)
	. = ..(mapload, "Sergal")
	h_style = "Sergal Plain"

/mob/living/carbon/human/akula/Initialize(mapload)
	. = ..(mapload, "Akula")

/mob/living/carbon/human/nevrean/Initialize(mapload)
	. = ..(mapload, "Nevrean")

/mob/living/carbon/human/xenochimera/Initialize(mapload)
	. = ..(mapload, "Xenochimera")

/mob/living/carbon/human/xenohybrid/Initialize(mapload)
	. = ..(mapload, "Xenomorph Hybrid")

/mob/living/carbon/human/spider/Initialize(mapload)
	. = ..(mapload, "Vasilissan")

/mob/living/carbon/human/vulpkanin/Initialize(mapload)
	. = ..(mapload, "Vulpkanin")

/mob/living/carbon/human/protean/Initialize(mapload)
	. = ..(mapload, "Protean")


/mob/living/carbon/human/alraune/Initialize(mapload)
	. = ..(mapload, "Alraune")
