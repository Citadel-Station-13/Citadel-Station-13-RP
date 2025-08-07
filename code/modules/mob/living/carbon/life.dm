//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/forced_metabolism(seconds)
	. = ..()

	bloodstr?.metabolize(seconds, TRUE)
	ingested?.metabolize(seconds, TRUE)
	touching?.metabolize(seconds, TRUE)
