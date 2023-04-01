/obj/item/circuitboard/machine/lathe
	abstract_type = /obj/item/circuitboard/machine/lathe
	name = T_BOARD("lathe")
	build_path = /obj/machinery/lathe
	// todo: beakers / bins optional but needed for storage.
	req_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 3,
	)

/obj/machinery/lathe
	abstract_type = /obj/machinery/lathe
	name = "lathe"
	#warn sprite including base_icon_state
	atom_flags = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = POWER_USAGE_LATHE_IDLE
	active_power_usage = POWER_USAGE_LATHE_ACTIVE_SCALE(1)
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/machine/lathe

	/// icon state when printing, if any
	var/active_icon_state
	/// icon state to flick when inserting sheets, if any
	var/insert_icon_state
	/// icon state to flick when recycling, if any
	var/recycle_icon_state

	/// print speed - multiplier. affects power cost.
	var/speed_multiplier = 1
	/// power efficiency - multiplier. affects power cost.
	var/power_multiplier = 1
	/// material efficiency - multiplier.
	var/efficiency_multiplier = 1
	/// material storage - multiplier
	var/storage_multiplier

	/// what kind of lathe is this
	var/lathe_type = NONE

	/// material container datum
	var/datum/material_container/stored_materials
	/// material container capacity - list with ids for specific, null for infinite, just a number for combined.
	var/materials_max = SHEET_MATERIAL_AMOUNT * 100
	/// reagents storage datum
	var/datum/reagents/stored_reagents
	/// has reagents? if above 0, we make reagents datum.
	var/reagents_max = 0
	/// stored items
	var/list/obj/item/stored_items
	/// max stored items - 0 for off
	var/items_max = 0

	/// max queue length in items
	var/queue_max = 20
	/// maximum items we can print per tick - for stacks this is the item itself, not the stack amount.
	var/max_items_per_tick = 4
	/// queued of /datum/lathe_queue_entry's.
	var/list/datum/lathe_queue_entry/queue
	/// currently printing design
	var/datum/design/printing
	/// processing queue?
	var/queue_active = FALSE
	/// progress in deciseconds on current design
	var/progress

	/// can recycle
	var/recycle = TRUE
	/// recycle efficiency
	var/recycle_efficiency = 0.8

	/// designs held - set to instance to instantiate.
	var/datum/design_holder/design_holder = /datum/design_holder

	/// allow controlling from self
	var/has_interface = FALSE
	/// our lathe control instance, lazy init'd
	var/datum/tgui_module/lathe_control/ui_controller

/obj/machinery/lathe/Initialize(mapload)
	. = ..()
	create_storages()

/obj/machinery/lathe/Destroy()
	delete_storages()
	if(design_holder?.owner == src)
		QDEL_NULL(design_holder)
	return ..()

/obj/machinery/lathe/drop_products(method)
	. = ..()
	dump_storages()

/obj/machinery/lathe/update_icon_state()
	if(active_icon_state && queue_active)
		icon_state = active_icon_state
	else
		// todo: unified machinery base icon state
		icon_state = base_icon_state
	return ..()

/obj/machinery/lathe/RefreshParts()
	. = ..()
	var/speed_factor = 1
	var/efficiency_factor = 1
	var/storage_factor = 1
	var/manips_total = 0
	var/manips_rating = 0
	var/bins_total = 0
	var/bins_rating = 0
	for(var/obj/item/stock_parts/manipulator/manip as anything in component_parts)
		manips_rating += manip.rating
		manips_total++
	for(var/obj/item/stock_parts/matter_bin/bin as anything in component_parts)
		bins_rating += bin.rating
		bins_total++
	manips_rating /= manips_total
	bins_rating /= bins_total
	speed_factor = manips_rating * 0.5 + 0.5
	efficiency_factor = MATERIAL_EFFICIENCY_LATHE_SCALE(manips_rating)
	storage_factor = bins_rating * 0.5 + 0.5
	speed_multiplier = speed_factor
	power_multiplier = 1
	storage_multiplier = storage_factor
	efficiency_multiplier = efficiency_factor
	update_active_power_usage(POWER_USAGE_LATHE_ACTIVE_SCALE(speed_factor))
	stored_materials.set_multiplied_capacity(materials_max, storage_factor)

/obj/machinery/lathe/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(I, /obj/item/stack/material))
		#warn insert
	else if(istype(I, /obj/item/reagent_containers))
		#warn insert
	return ..()

/obj/machinery/lathe/proc/create_storages()
	if(isnull(stored_materials))
		stored_materials = new(materials_max)
	else
		stored_materials.set_multiplied_capacity(materials_max, storage_multiplier)
	if(isnull(stored_reagents))
		stored_reagents = new(reagents_max, src)
	else
		stored_reagents.maximum_volume = reagents_max

/obj/machinery/lathe/proc/dump_storages()
	var/atom/dump_location = drop_location()
	stored_materials.dump_everything(dump_location)
	for(var/obj/item/I as anything in stored_items)
		I.forceMove(dump_location)
	stored_items = null

/obj/machinery/lathe/proc/delete_storages()
	if(stored_materials)
		QDEL_NULL(stored_materials)
	if(stored_reagents)
		QDEL_NULL(stored_reagents)
	if(stored_items)
		QDEL_LIST_NULL(stored_items)

/obj/machinery/lathe/proc/has_design(datum/design/id_or_instance)
	return design_holder.has_id(istext(id_or_instance)? id_or_instance : id_or_instance.identifier)

/obj/machinery/lathe/proc/has_capabilities_for(datum/design/instance)
	return lathe_type & instance.lathe_type

/obj/machinery/lathe/proc/has_resources_for(datum/design/instance, list/material_parts)
	if(!stored_materials.has(instance.materials))
		return FALES
	#warn variable material parts
	#warn reagents
	#warn items
	return TRUE

/obj/machinery/lathe/proc/can_print(datum/design/instance, list/material_parts)
	return has_design(instance) && has_capabilities_for(instance) && has_resources_for(instance, material_parts)

/obj/machinery/lathe/proc/do_print(datum/design/instance, list/material_parts)
	return instance.lathe_print(drop_location(), material_parts, src)

/obj/machinery/lathe/process(delta_time)

/obj/machinery/lathe/proc/progress_queue(time)
	#warn impl

/obj/machinery/lathe/proc/reconsider_queue()
	#warn impl

/**
 * enqueues an instance with given material_parts
 *
 * amount variable is reserved but unused at this given time.
 */
/obj/machinery/lathe/proc/enqueue(datum/design/instance, amount = 1, list/material_parts)
	#warn amount inject check
	if(length(queue) >= queue_max)
		return FALSE
	var/datum/lathe_queue_entry/inserting = new
	inserting.design_id = instance.identifier
	inserting.material_parts = material_parts
	inserting.amount = 1
	LAZYINITLIST(queue)
	queue += inserting
	reconsider_queue()
	return TRUE

/**
 * dequeues the instance with the given position
 */
/obj/machinery/lathe/proc/dequeue(position, amount)
	if(position > 0 && position < length(queue))
		#warn amount / extract check
		queue.Cut(position, position + 1)
	else
		return FALSE
	reconsider_queue()
	return TRUE

/obj/machinery/lathe/proc/clear_queue()
	if(!length(queue))
		return FALSE
	queue = null
	reconsider_queue()
	return TRUE

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

/obj/machinery/lathe/proc/tgui_controller()
	RETURN_TYPE(/datum/tgui_module)
	return ui_controller || (ui_controller = new(src))

/obj/machinery/lathe/proc/available_design_ids()
	return design_holder.available_ids()

/obj/machinery/lathe/proc/available_designs()
	return design_holder.available_designs()

/obj/machinery/lathe/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!has_interface)
		return
	tgui_controller().ui_interact(user, ui, parent_ui)

/obj/machinery/lathe/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	#warn impl
	return ..()

#warn recycling / clickdrag

/**
 * holder datum for queue data
 */
/datum/lathe_queue_entry
	/// design id
	var/design_id
	/// amount
	var/amount = 1
	/// material parts to use, key to id
	var/list/material_parts
