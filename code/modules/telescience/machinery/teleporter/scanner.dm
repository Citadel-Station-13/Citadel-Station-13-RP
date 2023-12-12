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

	/// current draw in kw
	var/power_setting = 0
	/// max draw in kw
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

/obj/machinery/teleporter/bluespace_scanner/on_changed_z_level(old_z, new_z)
	. = ..()
	SStelesci.z_change_bluespace_scanner(src, old_z, new_z)

/**
 * effective power in kw
 */
/obj/machinery/teleporter/bluespace_scanner/proc/effective_power()
	return power_setting

//! WARNING WARNING LEGACY SHITCODE
//! REFACTORING ON POWERNET REFACTOR.

/// amt is in kw, obviously.
/obj/machinery/teleporter/bluespace_scanner/proc/shitcode_consume_kw_immediate(amt)
	for(var/obj/structure/cable/cable in loc)
		if(cable.d1)
			continue
		// cable is a node
		if(isnull(cable.powernet))
			continue
		// cable has a powernet
		return cable.powernet.draw_power(amt)
	return 0
