/datum/action/mecha
	check_mobility_flags = MOBILITY_CAN_USE
	button_icon = 'icons/screen/actions/mecha.dmi'
	target_type = /obj/vehicle/sealed/mecha

#warn update all of these

/datum/action/mecha/mech_toggle_internals
	name = "Toggle Internal Airtank Usage"
	button_icon_state = "mech_internals_off"

/datum/action/mecha/mech_toggle_internals/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	button_icon_state = "mech_internals_[chassis.use_internal_tank ? "on" : "off"]"
	update_buttons()
	chassis.internal_tank()

/datum/action/mecha/mech_zoom
	name = "Toggle Mech Zoom"
	button_icon_state = "mech_zoom_off"

/datum/action/mecha/mech_zoom/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.zoom()
	button_icon_state = "mech_zoom_[chassis.zoom ? "on" : "off"]"
	update_buttons()

/datum/action/mecha/mech_toggle_phasing
	name = "Toggle Mech phasing"
	button_icon_state = "mech_phasing_off"

/datum/action/mecha/mech_toggle_phasing/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	button_icon_state = "mech_phasing_[chassis.phasing ? "on" : "off"]"
	update_buttons()
	chassis.phasing()
