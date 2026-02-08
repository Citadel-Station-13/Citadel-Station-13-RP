//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * supertype of simple toggled modules
 */
/obj/item/vehicle_module/toggled
	ui_component = "Toggled"

	var/active = FALSE

	var/toggle_delay = 1 SECONDS

	/// turn off when vehicle is depowered
	#warn impl
	var/requires_power_to_stay_active = FALSE

	var/ui_text_active = "Enabled"
	var/ui_text_inactive = "Disabled"
	var/ui_require_confirm = FALSE

	var/sfx_toggle
	var/sfx_toggle_vol = 75
	var/sfx_toggle_external = TRUE
	var/sfx_toggle_vary = TRUE

	var/sfx_toggle_on
	var/sfx_toggle_on_vol
	var/sfx_toggle_on_external
	var/sfx_toggle_on_vary

	var/sfx_toggle_off
	var/sfx_toggle_off_vol
	var/sfx_toggle_off_external
	var/sfx_toggle_off_vary

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
			if(desired)
				activate(actor)
			else
				deactivate(actor)
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
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(active)
		return
	active = TRUE
	vehicle_log_for_admins(actor, "toggle-on")
	vehicle_occupant_send_default_chat("Toggled to [ui_text_active]")
	on_activate(actor, silent)

/obj/item/vehicle_module/toggled/proc/deactivate(datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active)
		return
	active = FALSE
	vehicle_log_for_admins(actor, "toggle-off")
	vehicle_occupant_send_default_chat("Toggled to [ui_text_inactive]")
	on_deactivate(actor, silent)

/obj/item/vehicle_module/toggled/proc/on_activate(datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(sfx_toggle || sfx_toggle_on)
		var/external = sfx_toggle_on_external || sfx_toggle_external
		if(external)
			playsound(
				src,
				sfx_toggle_on || sfx_toggle,
				sfx_toggle_on_vol || sfx_toggle_vol,
				sfx_toggle_on_vary || sfx_toggle_vary,
			)
		else
			vehicle?.occupant_playsound(
				sfx_toggle_on || sfx_toggle,
				sfx_toggle_on_vol || sfx_toggle_vol,
				sfx_toggle_on_vary || sfx_toggle_vary,
			)

/obj/item/vehicle_module/toggled/proc/on_deactivate(datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(sfx_toggle || sfx_toggle_off)
		var/external = sfx_toggle_off_external || sfx_toggle_external
		if(external)
			playsound(
				src,
				sfx_toggle_off || sfx_toggle,
				sfx_toggle_off_vol || sfx_toggle_vol,
				sfx_toggle_off_vary || sfx_toggle_vary,
			)
		else
			vehicle?.occupant_playsound(
				sfx_toggle_off || sfx_toggle,
				sfx_toggle_off_vol || sfx_toggle_vol,
				sfx_toggle_off_vary || sfx_toggle_vary,
			)
