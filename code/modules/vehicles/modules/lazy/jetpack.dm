//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/lazy/jetpack
	icon_state = "mecha_jetpack"
	disallow_duplicates_match_type = /obj/item/vehicle_module/lazy/jetpack

	// TODO: jetpacks at some point should simulate their own encumbrance
	//       support

	/// Whether or not this jetpack is active.
	var/active = FALSE

/obj/item/vehicle_module/lazy/jetpack/render_ui()
	..()
	l_ui_select("toggle", "Enabled", list("Enable", "Disable"), active ? "Enable" : "Disable")

/obj/item/vehicle_module/lazy/jetpack/on_l_ui_select(datum/event_args/actor/actor, key, name)
	. = ..()
	if(.)
		return
	switch(key)
		if("toggle")
			switch(name)
				if("Enable")
				if("Disable")

/obj/item/vehicle_module/lazy/jetpack/proc/set_active(new_state)
	#warn impl

/obj/item/vehicle_module/lazy/jetpack/proc/on_activate()
	return

/obj/item/vehicle_module/lazy/jetpack/proc/on_deactivate()
	return

/obj/item/vehicle_module/lazy/jetpack/proc/handle_process_spacemove(drifting, movement_dir, just_checking)
	#warn impl

// TODO: IOU /obj/item/vehicle_module/lazy/jetpack/gas
// TODO: IOU /obj/item/vehicle_module/lazy/jetpack/gas/ion

/**
 * Power-consuming only jetpacks.
 *
 * This will eventually be replaced with gas and hybrid-gas ion jetpacks, but for now,
 * I'll allow it to continue.
 */
/obj/item/vehicle_module/lazy/jetpack/electric
	name = /obj/item/vehicle_module::name + " (electric jetpack)"
	desc = "Allows controlled spaceflight. Very slow, and energy consuming compared to proper ion-gas jetpacks."
	disallow_duplicates_match_type = /obj/item/vehicle_module/lazy/jetpack

	/// our ion trail follow effect
	var/datum/effect_system/ion_trail_follow/ion_trail
	/// in joules
	var/cost_per_tile = 5000

/obj/item/vehicle_module/lazy/jetpack/electric/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	if(!ion_trail)
		ion_trail = new
		ion_trail.set_up(vehicle)

/obj/item/vehicle_module/lazy/jetpack/electric/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	if(ion_trail)
		QDEL_NULL(ion_trail)

/obj/item/vehicle_module/lazy/jetpack/electric/on_activate()
	..()
	ion_trail.start()

/obj/item/vehicle_module/lazy/jetpack/electric/on_deactivate()
	..()
	ion_trail.stop()

/obj/item/vehicle_module/lazy/jetpack/electric/handle_process_spacemove(drifting, movement_dir, just_checking)
	if(!vehicle.draw_module_power_oneoff(src, cost_per_tile))
		return FALSE
	return TRUE
