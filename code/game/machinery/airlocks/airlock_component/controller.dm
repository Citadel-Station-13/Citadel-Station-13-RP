//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(airlock_controller_lookup)

/obj/item/airlock_component/controller
	name = /obj/machinery/airlock_component/controller::name + " (detached)"
	desc = /obj/machinery/airlock_component/controller::desc
	machine_type = /obj/machinery/airlock_component/controller
	icon = /obj/machinery/airlock_component/controller::icon
	icon_state = /obj/machinery/airlock_component/controller::icon_state
	base_icon_state = /obj/machinery/airlock_component/controller::base_icon_state

	var/datum/airlock_program/program
	var/program_path

/obj/item/airlock_component/controller/Initialize(mapload, set_dir, obj/machinery/airlock_component/controller/from_machine)
	. = ..()
	if(from_machine)
		program = from_machine.program
		program_path = from_machine.program_path
		// only one may own the reference at any given time
		from_machine.program = null

/obj/item/airlock_component/controller/Destroy()
	QDEL_NULL(program)
	return ..()

/**
 * Airlock controllers
 *
 * * Uses a state-reconcile pattern where we attempt to change the chamber to match the wanted state.
 */
/obj/machinery/airlock_component/controller
	name = "airlock controller"
	desc = "A self-contained controller for an airlock."
	icon = 'icons/machinery/airlocks/airlock_controller.dmi'
	icon_state = "controller"
	base_icon_state = "controller"

	detached_item_type = /obj/item/airlock_component/controller

	/// Airlock ID
	/// * Controller is the wireless AP, effectively, so only controller has an ID;
	///   the rest of the gasnet doesn't.
	var/airlock_id

	//* Access *//
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Airlock *//

	/// Our airlock system
	var/datum/airlock_system/system
	/// our airlock program
	var/datum/airlock_program/program
	/// Starting program typepath
	var/program_path
	/// connected peripherals
	var/list/obj/machinery/airlock_peripheral/peripherals

/obj/machinery/airlock_component/controller/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, context.mangling_id)

/obj/machinery/airlock_component/controller/Initialize(mapload, set_dir, obj/item/airlock_component/controller/from_item)
	..()
	// todo: we need proper tick bracket machine support & fastmos
	set_controller_id(src.airlock_id)
	if(from_item)
		program = from_item.program
		program_path = from_item.program_path
		// only one may own the reference at any given time
		from_item.program = null
	if(!src.program && src.program_path)
		src.program = new src.program_path

/obj/machinery/airlock_component/controller/Destroy()
	QDEL_NULL(program)
	set_controller_id(null)
	QDEL_NULL(system)
	for(var/obj/machinery/airlock_peripheral/peri as anything in peripherals)
		remove_peripheral(peri)
	return ..()

/obj/machinery/airlock_component/controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	// TODO: clickchain support?
	if(!system)
		to_chat(user, SPAN_WARNING("[src] is not initialized."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/airlock/AirlockSystem")
		ui.open()

/obj/machinery/airlock_component/controller/ui_data(mob/user, datum/tgui/ui)
	return system ? system.ui_data(arglist(args)) : list()

/obj/machinery/airlock_component/controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(FALSE)
	return system ? system.ui_act(arglist(args)) : TRUE

/obj/machinery/airlock_component/controller/ui_status(mob/user, datum/ui_state/state)
	if(!system)
		return UI_CLOSE
	return ..()

/obj/machinery/airlock_component/controller/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.controller)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.controller = src

/obj/machinery/airlock_component/controller/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.controller == src)
		network.controller = null
		network.queue_recheck()

/obj/machinery/airlock_component/controller/proc/on_cycle_begin()
	update_icon()

/obj/machinery/airlock_component/controller/proc/on_cycle_end()
	update_icon()

/obj/machinery/airlock_component/controller/update_icon(updates)
	cut_overlays()
	. = ..()
	if(system?.cycling)
		add_overlay("[base_icon_state]-op-green")

/obj/machinery/airlock_component/controller/proc/add_peripheral(obj/machinery/airlock_peripheral/peripheral)
	if(peripheral.controller == src)
		return TRUE
	if(peripheral.controller)
		peripheral.disconnect_from_controller()
	peripheral.controller = src
	LAZYADD(peripherals, peripheral)
	peripheral.on_controller_join(src)
	return TRUE

/obj/machinery/airlock_component/controller/proc/remove_peripheral(obj/machinery/airlock_peripheral/peripheral)
	if(peripheral.controller != src)
		return FALSE
	peripheral.controller = null
	LAZYREMOVE(peripherals, peripheral)
	peripheral.on_controller_leave()
	return TRUE

/**
 * @return TRUE success, FALSE failure
 */
/obj/machinery/airlock_component/controller/proc/set_controller_id(to_id)
	if(GLOB.airlock_controller_lookup[to_id])
		return FALSE
	if(!isnull(src.airlock_id))
		GLOB.airlock_controller_lookup -= src.airlock_id
	src.airlock_id = to_id
	if(!isnull(src.airlock_id))
		GLOB.airlock_controller_lookup[src.airlock_id] = src

/obj/machinery/airlock_component/controller/proc/on_sensor_cycle_request(obj/machinery/airlock_peripheral/sensor/sensor, datum/event_args/actor/actor)
	if(!system)
		return
	program?.on_sensor_cycle_request(system, sensor, actor)

/obj/machinery/airlock_component/controller/process(delta_time)
	system?.process(delta_time)
	program?.process(delta_time)

/obj/machinery/airlock_component/controller/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

/obj/machinery/airlock_component/controller/vacuum_cycle
	program_path = /datum/airlock_program/vacuum_cycle

/obj/machinery/airlock_component/controller/vacuum_cycle/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
