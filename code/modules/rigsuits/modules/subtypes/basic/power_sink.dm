//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/basic/power_sink
	name = /obj/item/rig_module/basic::name + " (power sink)"
	desc = /obj/item/rig_module/basic::desc + " This one allows an operator to drain power from \
	devices to recharge the suit's internal batteries."

	display_name = "power sink"
	display_desc = "Allows draining power from various electrical devices. This can damage the thing \
	being siphoned from if it cannot handle the current, and will likely trip overdraw sensors."

	impl_click = TRUE

	/// drain rate in kilowatts
	var/drain_power = 500
	/// emit sparks while draining?
	var/emit_sparks = TRUE

#warn impl

/obj/item/rig_module/basic/power_sink/lazy_on_click(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	. = ..()

/obj/item/rig_module/basic/power_sink/proc/siphon_power(atom/target, datum/event_args/actor/actor)

/**
 * @params
 * * amount - amount in kj
 *
 * @return TRUE to continue, FALSE to stop
 */
/obj/item/rig_module/basic/power_sink/proc/handle_siphoned_power(amount)

