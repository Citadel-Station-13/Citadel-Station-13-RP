//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/effect/eldritch_effect/reality_fracture
	name = "gash in the fabric of reality"
	desc = "You don't know what this is, but it looks, feels, and <i>is</i> wrong."

/obj/effect/eldritch_effect/reality_fracture/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocess_5fps, src)

/obj/effect/eldritch_effect/reality_fracture/Destroy()
	STOP_PROCESSING(SSprocess_5fps, src)
	return ..()

/obj/effect/eldritch_effect/reality_fracture/process(delta_time)

#warn impl partial
