//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/carbon/on_life_tick(seconds, notch, tick_types)
	. = ..()
	#warn biology

/mob/living/carbon/forced_metabolism(seconds)
	. = ..()

	bloodstr?.metabolize(seconds, TRUE)
	ingested?.metabolize(seconds, TRUE)
	touching?.metabolize(seconds, TRUE)
