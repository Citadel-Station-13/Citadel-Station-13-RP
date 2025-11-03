//AEIOU
//
//THIS FILE CONTAINS THE CODE TO ADD THE HUD BUTTONS AND THE MECH ACTIONS THEMSELVES.
//
//
// I better get some free food for this..



//
/// Adding the buttons things to the player. The interactive, top left things, at least at time of writing.
/// If you want it to be only for a special mech, you have to go and make an override like in the durand mech.
//

/obj/vehicle/sealed/mecha/proc/GrantActions(mob/living/user, human_occupant = 0)
	for(var/datum/action/action in list(
		internals_action,
		cycle_action,
		lights_action,
		stats_action,
		strafing_action,
		overload_possible && overload_action,
		zoom_possible && zoom_action,
		phasing_possible && phasing_action,
		switch_dmg_type_possible && switch_damtype_action,
	))
		action.grant(user.actions_controlled)

/obj/vehicle/sealed/mecha/proc/RemoveActions(mob/living/user, human_occupant = 0)
	for(var/datum/action/action in list(
		internals_action,
		cycle_action,
		lights_action,
		stats_action,
		strafing_action,
		zoom_action,
		phasing_action,
		switch_damtype_action,
		overload_action,
	))
		action.revoke(user.actions_controlled)

/datum/action/mecha
	check_mobility_flags = MOBILITY_CAN_USE
	button_icon = 'icons/screen/actions/mecha.dmi'
	target_type = /obj/vehicle/sealed/mecha

/datum/action/mecha/mech_toggle_lights
	name = "Toggle Lights"
	button_icon_state = "mech_lights_off"

/datum/action/mecha/mech_toggle_lights/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.user_set_floodlights(actor, !chassis.floodlight_active)
	button_icon_state = "mech_lights_[chassis.floodlight_active ? "on" : "off"]"
	update_buttons()

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

/datum/action/mecha/mech_view_stats
	name = "View stats"
	button_icon_state = "mech_view_stats"

/datum/action/mecha/mech_view_stats/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.view_stats()

/datum/action/mecha/strafe
	name = "Toggle Mech Strafing"
	button_icon_state = "mech_strafe_off"

/datum/action/mecha/strafe/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.strafing()
	button_icon_state = "mech_strafe_[chassis.strafing ? "on" : "off"]"
	update_buttons()

/datum/action/mecha/mech_overload_mode
	name = "Toggle Mech Leg Overload"
	button_icon_state = "mech_overload_off"

/datum/action/mecha/mech_overload_mode/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.overload()
	button_icon_state = "mech_overload_[chassis.overload ? "on" : "off"]"
	update_buttons()

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

#warn oh my god make this a base fucking vehicle thing and refactor this lol
/datum/action/mecha/mech_cycle_equip
	name = "Cycle Equipment"
	button_icon_state = "mech_cycle_equip_off"

/datum/action/mecha/mech_cycle_equip/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/obj/item/vehicle_module/maybe_switched_to = target.cycle_active_click_modules()
	if(maybe_switched_to == FALSE)
		actor?.chat_feedback(
			SPAN_WARNING("No equipment available."),
			target = target,
			button_icon_state = "mech_cycle_equip_off"
		)
		return
	actor?.chat_feedback(
		SPAN_NOTICE("You [maybe_switched_to ? "select [maybe_switched_to]" : "deselect the active module"]."),
		target = target,
	)
	button_icon_state = maybe_switched_to ? "mech_cycle_equip_on" : "mech_cycle_equip_off"
	update_buttons()

/datum/action/mecha/mech_switch_damtype
	name = "Reconfigure arm microtool arrays"
	button_icon_state = "mech_damtype_brute"

/datum/action/mecha/mech_switch_damtype/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/obj/vehicle/sealed/mecha/chassis = target
	button_icon_state = "mech_damtype_[chassis.damtype]"
	playsound(src, 'sound/mecha/mechmove01.ogg', 50, 1)
	update_buttons()
	chassis.query_damtype()

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

/obj/vehicle/sealed/mecha/proc/overload()
	if(usr.stat == 1)//No manipulating things while unconcious.
		return
	if(usr!=src.occupant_legacy)
		return
	if(integrity < initial(integrity) - initial(integrity)/3)//Same formula as in movement, just beforehand.
		src.occupant_message("<font color='red'>Leg actuators damage critical, unable to engage overload.</font>")
		overload = 0	//Just to be sure
		return
	if(overload)
		overload = 0
		step_energy_drain = initial(step_energy_drain)
		src.occupant_message("<font color='blue'>You disable leg actuators overload.</font>")
	else
		overload = 1
		step_energy_drain = step_energy_drain*overload_coeff
		src.occupant_message("<font color='red'>You enable leg actuators overload.</font>")
	playsound(src, 'sound/mecha/mechanical_toggle.ogg', 50, 1)

/obj/vehicle/sealed/mecha/proc/zoom()//This could use improvements but maybe later.
	if(usr!=src.occupant_legacy)
		return
	if(src.occupant_legacy.client)
		var/client/myclient = src.occupant_legacy.client
		src.zoom = !src.zoom
		src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
		if(zoom)
			myclient.set_temporary_view(GLOB.max_client_view_x + 5, GLOB.max_client_view_y + 5)
			src.occupant_legacy << sound('sound/mecha/imag_enh.ogg',volume=50)
		else
			myclient.reset_temporary_view()

/obj/vehicle/sealed/mecha/proc/query_damtype()
	if(usr!=src.occupant_legacy)
		return
	var/new_damtype = alert(src.occupant_legacy,"Melee Damage Type",null,"Brute","Fire","Toxic")
	switch(new_damtype)
		if("Brute")
			damtype = "brute"
			src.occupant_message("Your exosuit's hands form into fists.")
		if("Fire")
			damtype = "fire"
			src.occupant_message("A torch tip extends from your exosuit's hand, glowing red.")
		if("Toxic")
			damtype = "tox"
			src.occupant_message("A bone-chillingly thick plasteel needle protracts from the exosuit's palm.")
	src.occupant_message("Melee damage type switched to [new_damtype]")

/obj/vehicle/sealed/mecha/proc/phasing()
	if(usr!=src.occupant_legacy)
		return
	phasing = !phasing
	src.occupant_message("<font color=\"[phasing?"#00f\">En":"#f00\">Dis"]abled phasing.</font>")
