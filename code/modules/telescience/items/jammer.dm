//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_jammer
	name = "bluespace disruption flare"
	desc = "A high throughput device used to disrupt nearby teleportation systems."
	#warn sprite

	/// jamming power
	var/jamming_power = 10
	/// jamming power, max
	var/jamming_max = 100
	/// jamming power to watts used, conversion rate
	var/jamming_cost = 10
	/// jamming power adjustable
	var/jamming_adjust = FALSE
	/// jamming boost power
	var/jamming_boost_power = 0
	/// jamming boost power max
	var/jamming_boost_max = 0
	/// jamming boost power to watts used, conversion rate
	var/jamming_boost_cost = 10
	/// jamming boost adjustable
	var/jamming_boost_adjust = FALSE
	#warn more tuning params?

	/// jamming datum path - this determiens falloff
	var/jamming_type = /datum/bluespace_jamming/exponential

	/// starting cell type
	var/cell_type = /obj/item/cell/device/weapon

#warn impl all

/obj/item/bluespace_jammer/Initialize(mapload)
	. = ..()
	init_cell_slot_easy_tool(cell_type, TRUE, FALSE)

/obj/item/bluespace_jammer/trap
	name = "modified disruption flare"
	desc = "A reprogrammed bluespace disruptor flare. Instead of jamming teleportation from an accurate lock-on, this gadget redirects any unfortunate objects in transit towards its area of effect."
