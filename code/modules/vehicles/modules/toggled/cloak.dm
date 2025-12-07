//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/toggled/cloak
	name = "cloaking device"
	desc = "Integrated cloaking system. High power usage, but does render you invisible to the naked eye. Doesn't prevent noise, however."
	icon_state = "tesla"
	module_slot = VEHICLE_MODULE_SLOT_SPECIAL

	// 50 kilowatt drain while active
	// * stop whining this is already a third of the old value
	var/active_power = 50000

	sfx_togggle = 'sound/effects/EMPulse.ogg'
	sfx_togggle_vary = TRUE
	sfx_togggle_external = TRUE
	sfx_togggle_vol = 100

/obj/item/vehicle_module/toggled/cloak/process(delta_time)
	if(!vehicle.draw_module_power_oneoff(src, active_power * delta_time))
		deactivate()

/obj/item/vehicle_module/toggled/cloak/proc/on_activate(datum/event_args/actor/actor, silent)
	..()
	vehicle?.cloak()
	START_PROCESSING(SSobj, src)

/obj/item/vehicle_module/toggled/cloak/proc/on_deactivate(datum/event_args/actor/actor, silent)
	..()
	vehicle?.uncloak()
	STOP_PROCESSING(SSobj, src)
