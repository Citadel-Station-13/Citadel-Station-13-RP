//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
	icon = 'icons/machinery/lathe/autolathe.dmi'
	icon_state = "base"
	base_icon_state = "base"
	panel_icon_state = "panel"
	atom_flags = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = POWER_USAGE_LATHE_IDLE
	active_power_usage = POWER_USAGE_LATHE_ACTIVE_SCALE(1)
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/machine/lathe
	default_deconstruct = 0 SECONDS
	default_panel = 0 SECONDS
	depth_projected = TRUE
	depth_level = 8
	climb_allowed = TRUE

	/// icon state when printing, if any
	var/active_icon_state
	/// icon state when there's stuff in queue but we're not printing, if any; otherwise uses base
	var/paused_icon_state
	/// icon state to flick when finishing a print
	var/print_icon_state
	/// icon state to flick when inserting sheets
	var/insert_icon_state
	/// specific icon states for specific materials
	var/list/insert_icon_state_specific
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
	var/datum/reagent_holder/stored_reagents
	/// has reagents? if above 0, we make reagents datum.
	var/reagents_max = 0
	/// stored items
	var/list/obj/item/stored_items
	/// max stored items - 0 for off
	var/items_max = 0

	/// max queue length in items
	var/queue_max = 20
	/// max amount per queue entry for stacks
	var/queue_max_entry_stack = 200
	/// max amount per queue entry
	var/queue_max_entry = 10
	/// maximum items we can print per tick - for stacks this is the item itself, not the stack amount.
	var/max_items_per_tick = 4
	/// queued of /datum/lathe_queue_entry's. 1 is top of queue.
	var/list/datum/lathe_queue_entry/queue
	/// currently printing design
	var/datum/prototype/design/printing
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
	create_storages()
	if(ispath(design_holder))
		design_holder = new design_holder(src)
	. = ..()
	if(!isnull(insert_icon_state_specific))
		insert_icon_state_specific = typelist(NAMEOF(src, insert_icon_state_specific), insert_icon_state_specific)

/obj/machinery/lathe/Destroy()
	delete_storages()
	if(design_holder?.owner == src)
		QDEL_NULL(design_holder)
	return ..()

/obj/machinery/lathe/examine(mob/user)
	. = ..()
	if(recycle)
		. += SPAN_NOTICE("You can recycle items in this by dragging a deconstructable item to it. Some items can furthermore be deconstructed by just clicking on the lathe while being held inhand.")
	if(!has_interface)
		. += SPAN_NOTICE("This one doesn't seem to have an interface, and is likely controlled elsewhere.")

/obj/machinery/lathe/drop_products(method)
	. = ..()
	dump_storages()

/obj/machinery/lathe/update_icon_state()
	if(!isnull(active_icon_state) && queue_active)
		icon_state = active_icon_state
	else if(length(queue) && !isnull(paused_icon_state))
		icon_state = paused_icon_state
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
	var/new_reagentcap = 0
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		manips_rating += manip.rating
		manips_total++
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		bins_rating += bin.rating
		bins_total++
	for(var/obj/item/reagent_containers/R in component_parts)
		if(R.reagents)
			new_reagentcap += R.reagents.maximum_volume
		else //what
			new_reagentcap += R.volume
	manips_rating /= manips_total
	bins_rating /= bins_total
	speed_factor = manips_rating * 0.5 + 0.5
	efficiency_factor = MATERIAL_EFFICIENCY_LATHE_SCALE(manips_rating)
	storage_factor = bins_rating * 0.5 + 0.5
	speed_multiplier = speed_factor
	power_multiplier = 1
	storage_multiplier = storage_factor
	efficiency_multiplier = efficiency_factor
	reagents_max = new_reagentcap
	update_reagent_holder()
	update_active_power_usage(POWER_USAGE_LATHE_ACTIVE_SCALE(speed_factor))
	stored_materials.set_multiplied_capacity(materials_max, storage_factor)
	ui_controller?.update_static_data()

/obj/machinery/lathe/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(I, /obj/item/stack/material))
		var/used = stored_materials.insert_sheets(I)
		var/obj/item/stack/material/M = I
		if(used)
			user.action_feedback(SPAN_NOTICE("You insert [used] sheets of [I]."), src)
			ui_controller?.ui_materials_update()
		else
			user.action_feedback(SPAN_WARNING("[src] can't hold any more of [I]."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!isnull(insert_icon_state_specific?[M.material.id]))
			flick(insert_icon_state_specific[M.material.id], src)
		else if(!isnull(insert_icon_state))
			flick(insert_icon_state, src)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	else if(istype(I, /obj/item/reagent_containers/glass) && !isnull(stored_reagents))
		var/obj/item/reagent_containers/RC = I
		if(RC.is_open_container())
			var/amt = RC.reagents?.trans_to_holder(stored_reagents, RC.amount_per_transfer_from_this)
			if(amt)
				user.action_feedback(SPAN_NOTICE("You transfer [amt] units of the solution from \the [I] to [src]."), src)
				ui_controller?.ui_reagents_update()
			else if(!RC.reagents.total_volume)
				user.action_feedback(SPAN_WARNING("[RC] is empty!"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			else
				user.action_feedback(SPAN_WARNING("[src] can't hold any more reagents!"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	else if(isitem(I) && (user.a_intent == INTENT_HELP))
		if(!(I.item_flags & ITEM_EASY_LATHE_DECONSTRUCT))
			if(items_max)
				if(!insert_item(I, user))
					return CLICKCHAIN_DO_NOT_PROPAGATE
				return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
			return ..()
		if(recycle_item(I, user))
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/machinery/lathe/proc/insert_item(obj/item/I, mob/user)
	if(LAZYLEN(stored_items) >= items_max)
		user.action_feedback(SPAN_WARNING("[src] can't hold [items_max? "any more" : ""]items for machining."), src)
		return FALSE
	if(!isnull(user))
		if(user.is_in_inventory(I) && !user.transfer_item_to_loc(I, src))
			user.action_feedback(SPAN_WARNING("[I] is stuck to your hand!"), src)
			return FALSE
		user.action_feedback(SPAN_NOTICE("You insert [I] into [src]."), src)
	I.forceMove(src)
	LAZYADD(stored_items, I)
	ui_controller?.ui_ingredients_update()
	return TRUE

/obj/machinery/lathe/proc/eject_item(obj/item/I)
	I.forceMove(drop_location())
	LAZYREMOVE(stored_items, I)
	ui_controller?.ui_ingredients_update()

/obj/machinery/lathe/proc/recycle_item(obj/item/I, mob/user, recycle_eff = 1)
	recycle_eff *= recycle_efficiency
	var/list/materials = I?.materials_base.Copy()
	if(!isnull(user) && !user.temporarily_remove_from_inventory(I))
		user.action_feedback(SPAN_WARNING("[I] is stuck to your hand!"), src)
		return FALSE
	if(!length(materials))
		user?.action_feedback(SPAN_NOTICE("You trivially recycle \the [I] in [src]."))
		qdel(I)
		if(insert_icon_state)
			flick(insert_icon_state, src)
		return TRUE
	if(!stored_materials?.has_space(materials, recycle_eff))
		user?.action_feedback(SPAN_WARNING("[src] has no space to store the materials in [I]."), src)
		return FALSE
	stored_materials.add(materials, recycle_eff)
	user?.action_feedback(SPAN_NOTICE("You recycle [I] in [src]."), src)
	qdel(I)
	if(insert_icon_state)
		flick(insert_icon_state, src)
	return TRUE

/obj/machinery/lathe/proc/create_storages()
	if(isnull(stored_materials))
		if(materials_max != 0)
			stored_materials = new(materials_max)
	else
		stored_materials.set_multiplied_capacity(materials_max, storage_multiplier)
	update_reagent_holder()

/obj/machinery/lathe/proc/update_reagent_holder()
	if(isnull(stored_reagents))
		if(reagents_max != 0)
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

/obj/machinery/lathe/proc/has_design(datum/prototype/design/id_or_instance)
	return design_holder.has_id(istext(id_or_instance)? id_or_instance : id_or_instance.id)

/obj/machinery/lathe/proc/has_capabilities_for(datum/prototype/design/instance)
	return lathe_type & instance.lathe_type

/**
 * returns if we have resources for something
 *
 * @return number of it we can print, this can be a decimal. if design requires ingredients, this will never be above 1.
 */
/obj/machinery/lathe/proc/has_resources_for(datum/prototype/design/instance, list/material_parts, list/ingredient_parts)
	. = INFINITY
	if(length(instance.materials_base))
		var/list/materials = instance.materials_base.Copy()
		for(var/key in instance.material_costs)
			var/id = material_parts[key]
			materials[id] += instance.material_costs[key]
		. = stored_materials.has_multiple(materials) / efficiency_multiplier
	if(!.)
		return
	if(length(instance.reagents))
		. = min(., stored_reagents?.has_multiple(instance.reagents) / efficiency_multiplier)
	if(!.)
		return
	// ingredients? return 1 at most.
	if(length(instance.ingredients))
		. = min(., check_ingredients(instance.ingredients, ingredient_parts, stored_items))

/**
 * uses materials with a multiplier
 * efficiency multiplier var on /lathe is *not* applied in this proc.
 * ingredients will ignore multiplier. you have been warned.
 */
/obj/machinery/lathe/proc/use_resources(list/materials, list/reagents, list/ingredients, list/ingredient_parts, multiplier = 1)
	stored_materials.use(materials, multiplier)
	for(var/key in reagents)
		stored_reagents.remove_reagent(key, reagents[key] * multiplier)
	use_ingredients(ingredients, ingredient_parts, stored_items)

/obj/machinery/lathe/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(isitem(AM) && (AM in stored_items))
		stored_items -= AM

/**
 * returns if we can print something
 *
 * @return number of it we can print if so, null if we can't print at all and it isn't a resource issue
 */
/obj/machinery/lathe/proc/can_print(datum/prototype/design/instance, list/material_parts, list/ingredient_parts)
	if(!has_design(instance))
		return FALSE
	if(!has_capabilities_for(instance))
		return FALSE
	return has_resources_for(instance, material_parts, ingredient_parts)

/**
 * returns why we can't print something
 */
/obj/machinery/lathe/proc/why_cant_print(datum/prototype/design/instance, list/material_parts, list/ingredient_parts)
	if(!has_design(instance))
		return "Unknown design detected"
	if(!has_capabilities_for(instance))
		return "Design is unsupported"
	if(!round(has_resources_for(instance, material_parts, ingredient_parts)))
		return "Out of resources"

/**
 * prints a design
 *
 * @return an object, or a list of objects.
 */
/obj/machinery/lathe/proc/do_print(datum/prototype/design/instance, amount = 1, list/material_parts, list/ingredient_parts, efficiency = efficiency_multiplier)
	if(!amount)
		return
	var/list/materials_used = instance.materials_base?.Copy() || list()
	for(var/key in material_parts)
		materials_used[material_parts[key]] += instance.material_costs[key]
	use_resources(materials_used, instance.reagents, instance.ingredients, ingredient_parts, amount * efficiency)
	. = instance.lathe_print(drop_location(), amount, material_parts, ingredient_parts, null, src, efficiency_multiplier)
	if(!isnull(print_icon_state))
		flick(print_icon_state, src)
	ui_controller?.ui_materials_update()

/obj/machinery/lathe/process(delta_time)
	if(!queue_active)
		return
	progress_queue(delta_time * 10, 1)

/**
 * progresses queue by time deciseconds and mult multiplier
 */
/obj/machinery/lathe/proc/progress_queue(time, mult = 1)
	if(!check_queue_head())
		return
	var/total = time * (mult + speed_multiplier)
	progress += total
	var/datum/lathe_queue_entry/head = queue[1]
	var/datum/prototype/design/D
	var/left_this_tick = max_items_per_tick
	while(!isnull(head))
		D = RSdesigns.fetch(head.design_id)
		var/resource_limited = has_resources_for(D, head.material_parts, head.ingredient_parts)
		if(!resource_limited)
			if(queue_active)
				atom_say("Print queue interrupted - out of resources.")
			stop_printing()
			break
		var/printed = min(head.amount, D.is_stack? (D.max_stack * left_this_tick) : left_this_tick, round(progress / D.work), resource_limited)
		if(!printed)
			break
		left_this_tick -= D.is_stack? CEILING(D.max_stack / printed, 1) : printed
		progress -= printed * D.work
		head.amount -= printed
		do_print(D, printed, head.material_parts, head.ingredient_parts)
		if(!head.amount)
			queue.Cut(1, 2)
			if(!check_queue_head(check_resources = FALSE))
				ui_controller?.ui_queue_update()
				return
			head = queue[1]
		if(left_this_tick <= 0)
			break

/obj/machinery/lathe/proc/reconsider_queue(autostart, silent)
	if(!length(queue))
		stop_printing()
	else if(length(queue) && autostart)
		start_printing(silent)

/obj/machinery/lathe/proc/queue_head_design()
	RETURN_TYPE(/datum/prototype/design)
	return length(queue)? (RSdesigns.fetch(queue[1].design_id)) : null

/obj/machinery/lathe/proc/check_queue_head(silent, check_resources = TRUE)
	if(!length(queue))
		if(!silent && queue_active)
			atom_say("Print queue complete.")
		stop_printing()
		return FALSE
	var/datum/lathe_queue_entry/head = queue[1]
	var/datum/prototype/design/D = RSdesigns.fetch(head.design_id)
	if(isnull(D))
		if(!silent && queue_active)
			atom_say("Print queue interrupted - unknown entry in queue.")
		stop_printing()
		return FALSE
	if(!has_design(D))
		if(!silent && queue_active)
			atom_say("Print queue interrupted - unknown entry in queue.")
		stop_printing()
		return FALSE
	if(!has_capabilities_for(D))
		if(!silent && queue_active)
			atom_say("Print queue interrupted - incompatible design in queue.")
		stop_printing()
		return FALSE
	if(check_resources && !round(has_resources_for(D, head.material_parts, head.ingredient_parts)))
		if(!silent && queue_active)
			atom_say("Print queue interrupted - out of resources.")
		stop_printing()
		return FALSE
	return TRUE

/obj/machinery/lathe/proc/start_printing(silent)
	if(queue_active)
		return
	if(!check_queue_head(silent))
		return
	ui_controller?.update_ui_data()
	queue_active = TRUE
	update_use_power(USE_POWER_ACTIVE)
	update_icon()

/obj/machinery/lathe/proc/stop_printing()
	if(!queue_active)
		return
	queue_active = FALSE
	ui_controller?.update_ui_data()
	update_use_power(USE_POWER_IDLE)
	update_icon()

/**
 * returns a list of names associated to "off" | "on" | "disabled" | null
 *
 * if "off", renders as toggle button that isn't selected
 * if "on",  renders as toggle button that is selected
 * if "disabled", renders as a click button that's greyed out
 * if null,       renders as a click button that isn't
 */
/obj/machinery/lathe/proc/ui_custom_options()
	return list()

/**
 * called when custom buttons are pressed
 *
 * @params
 * * user - user doing it
 * * name - name of button
 *
 * @return TRUE / FALSE, TRUE to update buttons.
 */
/obj/machinery/lathe/proc/ui_custom_act(mob/user, name)
	return FALSE

/**
 * enqueues an instance with given material_parts
 *
 * amount variable is reserved but unused at this given time.
 */
/obj/machinery/lathe/proc/enqueue(datum/prototype/design/instance, amount = 1, list/material_parts, list/ingredient_parts, start_immediately)
	if(!isnull(instance.material_costs))
		for(var/key in instance.material_costs)
			if(!material_parts[key])
				return FALSE
	var/datum/lathe_queue_entry/last = length(queue)? queue[length(queue)] : null
	if(!isnull(last) && last.design_id == instance.id && last.material_parts ~= material_parts && last.ingredient_parts ~= ingredient_parts)
		var/adding
		if(instance.is_stack)
			adding = amount // no limit on stacks
		else
			adding = clamp(amount, 0, queue_max_entry - last.amount)
		last.amount += adding
		amount -= adding
		reconsider_queue(start_immediately)
		ui_controller?.ui_queue_update()
		if(!amount)
			return TRUE
	if(length(queue) >= queue_max)
		return FALSE
	var/datum/lathe_queue_entry/inserting = new
	inserting.design_id = instance.id
	inserting.material_parts = material_parts
	inserting.ingredient_parts = ingredient_parts
	inserting.amount = amount
	LAZYINITLIST(queue)
	queue += inserting
	reconsider_queue(start_immediately)
	ui_controller?.ui_queue_update()
	return TRUE

/**
 * dequeues the instance with the given position
 */
/obj/machinery/lathe/proc/dequeue(position)
	if(position > 0 && position < length(queue))
		queue.Cut(position, position + 1)
	else
		return FALSE
	reconsider_queue()
	ui_controller?.ui_queue_update()
	return TRUE

/obj/machinery/lathe/proc/clear_queue()
	if(!length(queue))
		return FALSE
	queue = null
	reconsider_queue()
	return TRUE

/obj/machinery/lathe/proc/tgui_controller()
	RETURN_TYPE(/datum/tgui_module)
	return ui_controller || (ui_controller = new(src))

/obj/machinery/lathe/proc/available_design_ids()
	return design_holder.available_ids()

/obj/machinery/lathe/proc/available_designs()
	return design_holder.available_designs()

/obj/machinery/lathe/proc/eject_sheets(id, amount)
	return stored_materials.dump(drop_location(), id, amount)

/obj/machinery/lathe/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!has_interface && !parent_ui) //We assume parent = contacting us remotely.
		return
	tgui_controller().ui_interact(user, ui, parent_ui)

/obj/machinery/lathe/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!user.Adjacent(src))
		return ..()
	if(!isitem(dropping))
		return ..()
	var/obj/item/I = dropping
	if(!user.is_holding(I) && !user.Reachability(I))
		return ..()
	if(I.item_flags & ITEM_NO_LATHE_DECONSTRUCT)
		user.action_feedback(SPAN_WARNING("[I] cannot be deconstructed."), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	recycle_item(I, user)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

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
	/// items to use for design - order matters! uses weakref's.
	var/list/ingredient_parts

/datum/lathe_queue_entry/ui_data(mob/user, datum/tgui/ui)
	return list(
		"design" = design_id,
		"amount" = amount,
		"materials" = length(material_parts)? material_parts : null,
		"ingredients" = length(ingredient_parts)? ingredient_parts : null,
	)
