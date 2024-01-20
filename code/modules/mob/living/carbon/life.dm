
/mob/living/carbon/BiologicalLife(seconds, times_fired)
	next_reagent_cycle()

	if((. = ..()))
		return

	handle_viruses()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++
