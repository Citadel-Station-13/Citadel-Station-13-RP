/mob/living/carbon/human/skrell/Initialize(mapload)
	h_style = "Skrell Short Tentacles"
	return ..(mapload, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/Initialize(mapload)
	h_style = "Tajaran Ears"
	return ..(new_loc, SPECIES_TAJ)

/mob/living/carbon/human/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	return ..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/Initialize(mapload)
	h_style = "Short Vox Quills"
	return ..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/Initialize(mapload)
	return ..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/teshari/Initialize(mapload)
	h_style = "Teshari Default"
	return ..(new_loc, SPECIES_TESHARI)

/mob/living/carbon/human/promethean/Initialize(mapload)
	return ..(new_loc, SPECIES_PROMETHEAN)

/mob/living/carbon/human/machine/Initialize(mapload)
	h_style = "blue IPC screen"
	..(new_loc, "Machine")

/mob/living/carbon/human/monkey/Initialize(mapload)
	return ..(new_loc, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/Initialize(mapload)
	return ..(new_loc, SPECIES_MONKEY_TAJ)

/mob/living/carbon/human/neaera/Initialize(mapload)
	return ..(new_loc, SPECIES_MONKEY_SKRELL)

/mob/living/carbon/human/stok/Initialize(mapload)
	return ..(new_loc, SPECIES_MONKEY_UNATHI)

/mob/living/carbon/human/event1/Initialize(mapload)
	return ..(new_loc, SPECIES_EVENT1)
