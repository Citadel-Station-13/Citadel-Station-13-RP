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
		smoke_possible && smoke_action,
		zoom_possible && zoom_action,
		thrusters_possible && thrusters_action,
		phasing_possible && phasing_action,
		switch_dmg_type_possible && switch_damtype_action,
		cloak_possible && cloak_action,
	))
		action.grant(user.actions_controlled)

/obj/vehicle/sealed/mecha/proc/RemoveActions(mob/living/user, human_occupant = 0)
	for(var/datum/action/action in list(
		internals_action,
		cycle_action,
		lights_action,
		stats_action,
		strafing_action,
		defence_action,
		smoke_action,
		zoom_action,
		thrusters_action,
		phasing_action,
		switch_damtype_action,
		overload_action,
		cloak_action,
	))
		action.revoke(user.actions_controlled)


//
////BUTTONS STUFF
//

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
	chassis.lights()
	button_icon_state = "mech_lights_[chassis.lights ? "on" : "off"]"
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

/datum/action/mecha/mech_smoke
	name = "Toggle Mech Smoke"
	button_icon_state = "mech_smoke_off"

/datum/action/mecha/mech_smoke/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.smoke()

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

/datum/action/mecha/mech_toggle_thrusters
	name = "Toggle Mech thrusters"
	button_icon_state = "mech_thrusters_off"

/datum/action/mecha/mech_toggle_thrusters/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	chassis.thrusters()
	button_icon_state = "mech_thrusters_[chassis.thrusters ? "on" : "off"]"
	update_buttons()

/datum/action/mecha/mech_cycle_equip	//I'll be honest, i don't understand this part, buuuuuut it works!
	name = "Cycle Equipment"
	button_icon_state = "mech_cycle_equip_off"

/datum/action/mecha/mech_cycle_equip/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/obj/vehicle/sealed/mecha/chassis = target

	var/list/available_equipment = list()
	available_equipment = chassis.equipment

	if(chassis.weapons_only_cycle)
		available_equipment = chassis.weapon_equipment

	if(available_equipment.len == 0)
		chassis.occupant_message("No equipment available.")
		return
	if(!chassis.selected)
		chassis.selected = available_equipment[1]
		chassis.occupant_message("You select [chassis.selected]")
		send_byjax(chassis.occupant_legacy,"exosuit.browser","eq_list",chassis.get_equipment_list())
		button_icon_state = "mech_cycle_equip_on"
		update_buttons()
		return
	var/number = 0
	for(var/A in available_equipment)
		number++
		if(A == chassis.selected)
			if(available_equipment.len == number)
				chassis.selected = null
				chassis.occupant_message("You switch to no equipment")
				button_icon_state = "mech_cycle_equip_off"
			else
				chassis.selected = available_equipment[number+1]
				chassis.occupant_message("You switch to [chassis.selected]")
				button_icon_state = "mech_cycle_equip_on"
			send_byjax(chassis.occupant_legacy,"exosuit.browser","eq_list",chassis.get_equipment_list())
			update_buttons()
			return



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

/datum/action/mecha/mech_toggle_cloaking
	name = "Toggle Mech phasing"
	button_icon_state = "mech_phasing_off"

/datum/action/mecha/mech_toggle_cloaking/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/vehicle/sealed/mecha/chassis = target
	button_icon_state = "mech_phasing_[chassis.cloaked ? "on" : "off"]"
	update_buttons()
	chassis.toggle_cloaking()

/obj/vehicle/sealed/mecha/verb/toggle_overload()
	set category = "Exosuit Interface"
	set name = "Toggle leg actuators overload"
	set src = usr.loc
	set popup_menu = 0
	overload()

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
	src.log_message("Toggled leg actuators overload.")
	playsound(src, 'sound/mecha/mechanical_toggle.ogg', 50, 1)
	return


/obj/vehicle/sealed/mecha/verb/toggle_smoke()
	set category = "Exosuit Interface"
	set name = "Activate Smoke"
	set src = usr.loc
	set popup_menu = 0
	smoke()

/obj/vehicle/sealed/mecha/proc/smoke()
	if(usr!=src.occupant_legacy)
		return

	if(smoke_reserve < 1)
		src.occupant_message("<font color='red'>You don't have any smoke left in stock!</font>")
		return

	if(smoke_ready)
		smoke_reserve--	//Remove ammo
		src.occupant_message("<font color='red'>Smoke fired. [smoke_reserve] usages left.</font>")

		var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
		smoke.attach(src)
		smoke.set_up(10, 0, usr.loc)
		smoke.start()
		playsound(src, 'sound/effects/smoke.ogg', 50, 1, -3)

		smoke_ready = 0
		spawn(smoke_cooldown)
			smoke_ready = 1
	return



/obj/vehicle/sealed/mecha/verb/toggle_zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set src = usr.loc
	set popup_menu = 0
	zoom()

/obj/vehicle/sealed/mecha/proc/zoom()//This could use improvements but maybe later.
	if(usr!=src.occupant_legacy)
		return
	if(src.occupant_legacy.client)
		var/client/myclient = src.occupant_legacy.client
		src.zoom = !src.zoom
		src.log_message("Toggled zoom mode.")
		src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
		if(zoom)
			myclient.set_temporary_view(GLOB.max_client_view_x + 5, GLOB.max_client_view_y + 5)
			src.occupant_legacy << sound('sound/mecha/imag_enh.ogg',volume=50)
		else
			myclient.reset_temporary_view()
	return



/obj/vehicle/sealed/mecha/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle thrusters"
	set src = usr.loc
	set popup_menu = 0
	thrusters()

/obj/vehicle/sealed/mecha/proc/thrusters()
	if(usr!=src.occupant_legacy)
		return
	if(src.occupant_legacy)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.</font>")
	return



/obj/vehicle/sealed/mecha/verb/switch_damtype()
	set category = "Exosuit Interface"
	set name = "Change melee damage type"
	set src = usr.loc
	set popup_menu = 0
	query_damtype()

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
	return



/obj/vehicle/sealed/mecha/verb/toggle_phasing()
	set category = "Exosuit Interface"
	set name = "Toggle phasing"
	set src = usr.loc
	set popup_menu = 0
	phasing()

/obj/vehicle/sealed/mecha/proc/phasing()
	if(usr!=src.occupant_legacy)
		return
	phasing = !phasing
	send_byjax(src.occupant_legacy,"exosuit.browser","phasing_command","[phasing?"Dis":"En"]able phasing")
	src.occupant_message("<font color=\"[phasing?"#00f\">En":"#f00\">Dis"]abled phasing.</font>")
	return


/obj/vehicle/sealed/mecha/verb/toggle_cloak()
	set category = "Exosuit Interface"
	set name = "Toggle cloaking"
	set src = usr.loc
	set popup_menu = 0
	toggle_cloaking()

/obj/vehicle/sealed/mecha/proc/toggle_cloaking()
	if(usr!=src.occupant_legacy)
		return

	if(cloaked)
		uncloak()
	else
		cloak()

	src.occupant_message("<font color=\"[cloaked?"#00f\">En":"#f00\">Dis"]abled cloaking.</font>")
	return

/obj/vehicle/sealed/mecha/verb/toggle_weapons_only_cycle()
	set category = "Exosuit Interface"
	set name = "Toggle weapons only cycling"
	set src = usr.loc
	set popup_menu = 0
	set_weapons_only_cycle()

/obj/vehicle/sealed/mecha/proc/set_weapons_only_cycle()
	if(usr!=src.occupant_legacy)
		return
	weapons_only_cycle = !weapons_only_cycle
	src.occupant_message("<font color=\"[weapons_only_cycle?"#00f\">En":"#f00\">Dis"]abled weapons only cycling.</font>")
	return
