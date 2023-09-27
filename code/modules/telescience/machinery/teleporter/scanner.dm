//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * used by telescience to discover targets
 *
 * extremely energy intensive
 *
 * diminishing returns based on distance to each other.
 */
/obj/machinery/teleporter/bluespace_scanner
	name = "bluespace lensing suite"
	desc = "A prototype bluespace scanning and analysis suite. Uses massive amounts of power to detect nearby locator signals, whether active or passive. Additional power is required to lock onto passive sources."
	#warn sprite
	#warn circuit

	/// current draw
	var/power_setting = 0
	/// max draw
	var/power_max = 1000

/obj/machinery/teleporter/bluespace_scanner/Initialize(mapload)
	SStelesci.register_bluespace_scanner(src)
	return ..()

/obj/machinery/teleporter/bluespace_scanner/Destroy()
	SStelesci.unregister_bluespace_scanner(src)
	return ..()

/obj/machinery/teleporter/bluespace_scanner/process(delta_time)
	#warn impl

/obj/machinery/teleporter/bluespace_scanner/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["powerSetting"] = power_setting

/obj/machinery/teleporter/bluespace_scanner/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["powerMax"] = power_max
