//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Device, that, once armed, will automatically jaunt the user to safety if
 * a fatal condition is detected.
 */
/obj/item/bluespace_jaunter
	name = "bluespace excursion jaunter"
	desc = "A prototype jaunter that maintains an active lock on a nearby beacon. Will automatically activate upon detecting the user entering a critical condition."
	#warn sprite

	#warn impl all

/obj/item/bluespace_jaunter/Initialize(mapload)
	. = ..()
	#warn ??

/obj/item/bluespace_jaunter/Destroy()
	#warn ??
	return ..()

/obj/item/bluespace_jaunter/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("You can use this on another jaunter to pair them together. ")

#warn impl all
