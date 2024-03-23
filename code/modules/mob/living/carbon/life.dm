//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/living/carbon/forced_metabolism(seconds)
	. = ..()

	bloodstr?.metabolize(seconds, TRUE)
	ingested?.metabolize(seconds, TRUE)
	touching?.metabolize(seconds, TRUE)
