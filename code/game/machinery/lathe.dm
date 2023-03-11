/obj/item/circuitboard/machine/lathe
	#warn impl

/obj/machinery/lathe
	abstract_type = /obj/machinery/lathe
	name = "lathe"
	#warn sprite including base_icon_state
	atom_flags = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	#warn component parts & upgrade handling

	/// print speed - multiplier. affects power cost.
	var/speed_multiplier = 1
	/// power efficiency - multiplier. affects power cost.
	var/power_multiplier = 1
	/// material efficiency - multiplier.
	var/efficiency_multiplier = 1

	/// what kind of lathe is this
	var/lathe_type = NONE

	/// material container datum
	var/datum/material_container/materials
	/// material container capacity - list with ids for specific, null for infinite, just a number for combined.
	var/materials_max = SHEET_MATERIAL_AMOUNT * 100

	/// queued of /datum/lathe_queued's.
	var/list/queue
	/// currently printing design
	var/datum/design/printing
	/// processing queue?
	var/printing = FALSE
	/// progress in deciseconds on current design
	var/progress

	/// designs held - set to instance to instantiate.
	var/datum/design_holder/design_holder = /datum/design_holder

	/// allow controlling from self
	var/has_interface = FALSE
	/// our lathe control instance, lazy init'd
	var/datum/tgui_module/lathe_control/ui_controller

	#warn recycling

/obj/machinery/lathe/Initialize(mapload)
	. = ..()
	create_storages()

/obj/machinery/lathe/Destroy()
	delete_storages()
	if(design_holder?.owner == src)
		QDEL_NULL(design_holder)
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

/**
 * holder datum for queue data
 */
/datum/lathe_queued
	/// design id
	var/design_id
	/// amount
	var/amount = 1
	/// material parts to use, key to id
	var/list/material_parts
