//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/modular_gun_part
	/// attached system
	var/datum/modular_gun_system/system
	/// requires ticking
	var/requires_ticking = FALSE

/obj/item/modular_gun_part/proc/on_tick(dt)
	return

/obj/item/modular_gun_part/proc/on_attached(datum/modular_gun_system/system)
	return

/obj/item/modular_gun_part/proc/on_detached(datum/modular_gun_system/system)
	return

/obj/item/modular_gun_part/proc/get_examine_text()
	return "[src]"

#warn impl
