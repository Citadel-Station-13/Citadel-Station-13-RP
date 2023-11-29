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

	/// all paired jaunters. This is a **shared list**.
	var/list/obj/item/bluespace_jaunter/paired
	/// our pairing id
	//  todo: this should be cross-round stable
	var/id

	/// the signal we're locked onto
	var/datum/bluespace_signal/locked_signal
	/// the atom the last signal we're locked onto was projected from
	/// this allows re-establishing locks even after something turns off and is delayed in turning back on
	var/datum/weakref/projector_weakref
	/// the signal's security / encryption hash; we only re-lock onto the projector if this doesn't change when it comes back.
	var/locked_hash

	/// are we primed?
	var/active = FALSE

	/// manual activation delay
	var/manual_activation_time = 20 SECONDS
	/// automatic activation delay
	var/auto_activation_time = 30 SECONDS

/obj/item/bluespace_jaunter/Initialize(mapload)
	. = ..()
	#warn ??

/obj/item/bluespace_jaunter/Destroy()
	unpair()
	#warn ??
	return ..()

/obj/item/bluespace_jaunter/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("You can use this on another jaunter to pair them together. ")

#warn impl all

/obj/item/bluespace_jaunter/proc/pair(obj/item/bluespace_jaunter/other)

/obj/item/bluespace_jaunter/proc/unpair()

/obj/item/bluespace_jaunter/on_changed_z_level(old_z, new_z)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(verify_pairing_closure)), 2 SECONDS, TIMER_UNIQUE)


/obj/item/bluespace_jaunter/proc/verify_pairing_closure()
