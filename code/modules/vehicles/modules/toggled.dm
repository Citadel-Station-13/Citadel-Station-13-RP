//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * supertype of simple toggled modules
 */
/obj/item/vehicle_module/toggled
	ui_component = "Toggled"
	var/active = FALSE
	var/ui_text_active = "Enabled"
	var/ui_text_inactive = "Disabled"
	var/ui_require_confirm = FALSE

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

/obj/item/vehicle_module/toggled/proc/activate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/deactivate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/on_activate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/on_deactivate(datum/event_args/actor/actor, silent)


#warn impl
