//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/mob/living/carbon/forced_metabolism(seconds)
	. = ..()

	bloodstr?.metabolize(seconds, TRUE)
	ingested?.metabolize(seconds, TRUE)
	touching?.metabolize(seconds, TRUE)
