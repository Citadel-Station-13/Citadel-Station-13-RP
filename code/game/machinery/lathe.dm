/obj/machinery/lathe
	abstract_type = /obj/machinery/lathe
	name = "lathe"
	#warn sprite including base_icon_state
	atom_flags = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	/// print speed - multiplier. affects power cost.
	var/speed_multiplier = 1
	/// power efficiency - multiplier. affects power cost.
	var/power_multiplier = 1
	/// material efficiency - multiplier.
	var/efficiency_multiplier = 1

	/// material holder datum
	var/datum/material_container/materials
	/// items held inside us, if any
	var/list/obj/item/items

	/// queued design ids
	var/list/queue
	/// processing queue?
	var/printing = FALSE
	/// progress in deciseconds on current design
	var/progress

	/// allow controlling from self
	var/has_interface = FALSE
	/// our lathe control instance, lazy init'd
	var/datum/tgui_module/lathe_control/ui_controller

/obj/machinery/lathe/Initialize(mapload)
	. = ..()
	create_storages()

/obj/machinery/lathe/Destroy()
	delete_storages()
	return ..()

/obj/machinery/lathe/proc/create_storages()
	#warn impl

/obj/machinery/lathe/proc/delete_storages()
	if(materials)
		QDEL_NULL(materials)
	if(reagents)
		QDEL_NULL(reagents)

/obj/machinery/lathe/proc/has_design(datum/design/id_or_instance)

/obj/machinery/lathe/proc/has_capabilities_for(datum/design/instance)

/obj/machinery/lathe/proc/has_resources_for(datum/design/instance)

/obj/machinery/lathe/proc/can_print(datum/design/instance)

/obj/machinery/lathe/proc/do_print(datum/design/instance)

#warn impl

/obj/machinery/lathe/process(delta_time)

/obj/machinery/lathe/proc/progress_queue(time)

/obj/machinery/lathe/proc/enqueue(datum/design/instance, amount = 1)

/obj/machinery/lathe/proc/dequeue(position, amount)

/obj/machinery/lathe/ui_module_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	switch(id)
		if("control")
			return ui_controller?.ui_act(action, params, ui)

/obj/machinery/lathe/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["control"] = ui_controller.data(user)

/obj/machinery/lathe/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["control"] = ui_controller.data(user)

#warn impl

/obj/machinery/lathe/proc/tgui_controller()
	return ui_controller || (ui_controller = new(src))

/obj/machinery/lathe/proc/available_design_ids()
	#warn impl

/obj/machinery/lathe/proc/available_designs()
	#warn impl
