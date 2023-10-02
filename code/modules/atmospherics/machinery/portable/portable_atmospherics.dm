/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = USE_POWER_OFF
	layer = OBJ_LAYER // These are mobile, best not be under everything.
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OFFLINE

	/// allow multitool "hijacking" even if this is controlled by something else
	/// set to non-null for delay.
	//  todo: implement multitool access
	var/default_multitool_hijack = null
	/// allow access normally
	var/default_access_interface = TRUE
	/// tgui interface
	var/tgui_interface
	/// ui flags
	var/atmos_portable_ui_flags = NONE

	/// on right now
	var/on = FALSE
	/// current flow, liters
	var/flow_current = 0
	/// flow maximum
	var/flow_maximum = 1000
	/// flow setting
	var/flow_setting


	var/datum/gas_mixture/air_contents = new

	var/obj/machinery/atmospherics/portables_connector/connected_port
	// todo: tweak this; not all portables can / should necessarily be able to hold tanks.
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/start_pressure = ONE_ATMOSPHERE
	///Maximum pressure allowed on initialize inside the canister, multiplied by the filled var
	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/Initialize(mapload)
	. = ..()
	if(isnull(flow_setting))
		flow_setting = flow_maximum
	air_contents.volume = volume
	air_contents.temperature = T20C

/obj/machinery/portable_atmospherics/Destroy()
	QDEL_NULL(air_contents)
	QDEL_NULL(holding)
	. = ..()

/obj/machinery/portable_atmospherics/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/LateInitialize()
	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		connect(port)
		update_icon()
	return ..()

/obj/machinery/portable_atmospherics/process(delta_time)
	flow_current = 0

	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/interact(mob/user)
	if(!default_access_interface)
		user.action_feedback(SPAN_WARNING("You can't directly interact with [src]. Use an area atmospherics control computer, if there is one."), src)
		return FALSE
	ui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!tgui_interface)
		return ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, tgui_interface)
		ui.open()

/obj/machinery/portable_atmospherics/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["controlFlags"] = atmos_portable_ui_flags
	.["useCharge"] = FALSE
	.["flowMax"] = flow_maximum

/obj/machinery/portable_atmospherics/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["flow"] = flow_current
	.["flowSetting"] = flow_setting
	.["on"] = on
	.["tank"] = holding?.tgui_tank_data()
	.["pressure"] = air_contents.return_pressure()
	.["temperature"] = air_contents.temperature
	.["portConnected"] = !!connected_port

/obj/machinery/portable_atmospherics/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("togglePower")
			if(!(atmos_portable_ui_flags & ATMOS_PORTABLE_UI_TOGGLE_POWER))
				return TRUE
			set_on(!on)
			return TRUE
		if("setFlow")
			var/amt = params["value"]
			if(!isnum(amt))
				return TRUE
			if(!(atmos_portable_ui_flags & ATMOS_PORTABLE_UI_SET_FLOW))
				return TRUE
			set_flow(amt)
			return TRUE
		if("eject")
			if(isnull(holding))
				return TRUE
			on_eject(holding, usr)
			usr.action_feedback(SPAN_NOTICE("You remove [holding] from [src]."), src)
			usr.grab_item_from_interacted_with(holding, src)
			holding = null
			return TRUE

/**
 * Called on tank ejection
 */
/obj/machinery/portable_atmospherics/proc/on_eject(obj/item/tank/tank, mob/user)
	return TRUE

/obj/machinery/portable_atmospherics/proc/set_on(enabled)
	on = enabled
	update_icon()

/obj/machinery/portable_atmospherics/proc/set_flow(liters)
	flow_setting = clamp(liters, 0, flow_maximum)

/obj/machinery/portable_atmospherics/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/blob_act()
	qdel(src)

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		GAS_ID_OXYGEN = O2STANDARD * MolesForPressure(),
		GAS_ID_NITROGEN = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = 1 //Activate port updates

	anchored = 1 //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = 1

	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	anchored = 0

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if ((istype(I, /obj/item/tank) && !( src.destroyed )))
		if (holding && (user.a_intent != INTENT_GRAB))
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		var/obj/item/tank/T = I
		if(holding)
			user.grab_item_from_interacted_with(holding, src)
			to_chat(user, SPAN_NOTICE("You quickly swap the tanks with the quick release valve."))
		holding = T
		update_icon()
		return

	else if (I.is_wrench())
		if(connected_port)
			disconnect()
			to_chat(user, "<span class='notice'>You disconnect \the [src] from the port.</span>")
			update_icon()
			playsound(src, I.tool_sound, 50, 1)
			return
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, "<span class='notice'>You connect \the [src] to the port.</span>")
					update_icon()
					playsound(src, I.tool_sound, 50, 1)
					return
				else
					to_chat(user, "<span class='notice'>\The [src] failed to connect to the port.</span>")
					return
			else
				to_chat(user, "<span class='notice'>Nothing happens.</span>")
				return

	else if ((istype(I, /obj/item/atmos_analyzer)) && Adjacent(user))
		var/obj/item/atmos_analyzer/A = I
		A.analyze_gases(src, user)

/obj/machinery/portable_atmospherics/MouseDroppedOnLegacy(mob/living/carbon/O, mob/user as mob)
	if(!istype(O))
		return 0 //not a mob
	if(user.incapacitated())
		return 0 //user shouldn't be doing things
	if(O.anchored)
		return 0 //mob is anchored???
	if(get_dist(user, src) > 1 || get_dist(user, O) > 1)
		return 0 //doesn't use adjacent() to allow for non-GLOB.cardinal (fuck my life)
	if(!ishuman(user) && !isrobot(user))
		return 0 //not a borg or human

	if(O.has_buckled_mobs())
		to_chat(user, SPAN_WARNING( "\The [O] has other entities attached to it. Remove them first."))
		return

	if(O == user)
		usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	else
		visible_message("[user] puts [O] onto \the [src].")


	if(do_after(O, 3 SECOND, src))
		O.forceMove(src.loc)

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")

/obj/machinery/portable_atmospherics/proc/log_open()
	if(air_contents.gas.len == 0)
		return

	var/gases = ""
	for(var/gas in air_contents.gas)
		if(gases)
			gases += ", [gas]"
		else
			gases = gas
	log_admin("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
	message_admins("[usr] ([usr.ckey]) opened '[src.name]' containing [gases].")
