//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * supertype of simple toggled modules
 */
/obj/item/vehicle_module/toggled
	ui_component = "Toggled"

	var/active = FALSE

	var/toggle_delay = 1 SECONDS

	var/ui_text_active = "Enabled"
	var/ui_text_inactive = "Disabled"
	var/ui_require_confirm = FALSE

	var/sfx_toggle
	var/sfx_toggle_vol = 75
	var/sfx_toggle_external = TRUE
	var/sfx_toggle_vary = TRUE

	var/sfx_togggle_on
	var/sfx_togggle_on_vol
	var/sfx_togggle_on_external
	var/sfx_togggle_on_vary

	var/sfx_togggle_off
	var/sfx_togggle_off_vol
	var/sfx_togggle_off_external
	var/sfx_togggle_off_vary

/obj/item/vehicle_module/toggled/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	deactivate()

/obj/item/vehicle_module/toggled/vehicle_ui_module_act(action, list/params, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("setActive")
			var/desired = !!params["toValue"]
			if(desired == active)
				vehicle_ui_module_push(data = list("active" = active))
				return TRUE
			active = desired
			#warn LOG THIS
			vehicle_ui_module_push(data = list("active" = active))
			return TRUE

/obj/item/vehicle_module/toggled/vehicle_ui_module_data()
	. = ..()
	.["activeText"] = ui_text_active
	.["inactiveText"] = ui_text_inactive
	.["confirmRequired"] = ui_require_confirm
	.["active"] = active
	.["toggleDelay"] = toggle_delay

/obj/item/vehicle_module/toggled/proc/activate(datum/event_args/actor/actor, silent)
	#warn log

/obj/item/vehicle_module/toggled/proc/deactivate(datum/event_args/actor/actor, silent)
	#warn log

/obj/item/vehicle_module/toggled/proc/on_activate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/on_deactivate(datum/event_args/actor/actor, silent)


#warn impl
