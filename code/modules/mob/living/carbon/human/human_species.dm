/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/skrell/Initialize(var/new_loc)
	h_style = "Skrell Short Tentacles"
	return ..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/Initialize(var/new_loc)
	h_style = "Tajaran Ears"
	return ..(new_loc, SPECIES_TAJ)

/mob/living/carbon/human/unathi/Initialize(var/new_loc)
	h_style = "Unathi Horns"
	return ..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/Initialize(var/new_loc)
	h_style = "Short Vox Quills"
	return ..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/teshari/Initialize(var/new_loc)
	h_style = "Teshari Default"
	return ..(new_loc, SPECIES_TESHARI)

/mob/living/carbon/human/promethean/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_PROMETHEAN)

/mob/living/carbon/human/zaddat/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_ZADDAT)

/mob/living/carbon/human/monkey/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_TAJ)

/mob/living/carbon/human/neaera/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_SKRELL)

/mob/living/carbon/human/stok/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_UNATHI)

/mob/living/carbon/human/event1/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_EVENT1)

/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/New(var/new_loc)
	h_style = "Sergal Plain"
	..(new_loc, "Sergal")

/mob/living/carbon/human/akula/New(var/new_loc)
	..(new_loc, "Akula")

/mob/living/carbon/human/nevrean/New(var/new_loc)
	..(new_loc, "Nevrean")

/mob/living/carbon/human/xenochimera/New(var/new_loc)
	..(new_loc, "Xenochimera")

/mob/living/carbon/human/xenohybrid/New(var/new_loc)
	..(new_loc, "Xenomorph Hybrid")

/mob/living/carbon/human/spider/New(var/new_loc)
	..(new_loc, "Vasilissan")

/mob/living/carbon/human/vulpkanin/New(var/new_loc)
	..(new_loc, "Vulpkanin")

/mob/living/carbon/human/protean/New(var/new_loc)
	..(new_loc, "Protean")

/mob/living/carbon/human/alraune/New(var/new_loc)
	..(new_loc, "Alraune")

/mob/living/carbon/human/shadekin/New(var/new_loc)
	..(new_loc, SPECIES_SHADEKIN)
