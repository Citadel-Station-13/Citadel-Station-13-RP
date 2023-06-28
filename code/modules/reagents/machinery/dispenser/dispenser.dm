/obj/item/circuitboard/machine/chemical_dispenser
	name = T_BOARD("chemical dispenser")
	build_path = /obj/machinery/chemical_dispenser
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/cell = 1,
		/obj/item/stock_parts/console_screen = 1,
	)

#define MAX_MACROS 20
#define MAX_MACRO_STEPS 50

/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "dispenser"
	circuit = /obj/item/circuitboard/machine/chemical_dispenser

	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	anchored = TRUE
	allow_unanchor = TRUE
	allow_deconstruct = TRUE

	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE_SILICON

	/// reagent synthesizers in us - set to list of typepaths to init on Initialize().
	var/list/obj/item/reagent_synth/synthesizers
	/// synthesizers are swappable
	var/synthesizers_swappable = TRUE
	/// cartridges in us, usable for dispensing with.
	var/list/obj/item/reagent_containers/cartridge/dispenser/cartridges
	/// max cartridges
	var/cartridges_max = 50
	/// our cell - this is in component_parts too.
	//  todo: component_parts supporting "use this and don't keep this in component_parts".
	var/obj/item/cell/cell
	/// initial cell type
	var/cell_type = /obj/item/cell/high
	/// recharge rate in KW
	var/recharge_rate = 10
	/// inserted beaker / whatever
	var/obj/item/reagent_containers/inserted
	/// allow drinking glasses
	var/allow_drinking = FALSE
	/// current dispense amount
	var/dispense_amount = 10
	/// max dispense amount - this is relatively important to prevent *easy* maxcaps.
	var/dispense_amount_max = 60
	/// power in kilojoules per unit synthesized
	var/kj_per_unit = 4
	/// is recharging active?
	var/charging = TRUE
	/// macros: list of list("name" = name, "index" = number, "data" = list("id" = amount, ...))
	//  todo: macros utilizing cartridges
	var/list/macros

/obj/machinery/chemical_dispenser/Initialize(mapload)
	. = ..()
	// default_apply_parts runs in ..()
	component_parts -= cell
	if(cell)
		qdel(cell)
	if(cell_type)
		cell = new cell_type(src)
		component_parts |= cell
	if(islist(synthesizers))
		var/list/created = list()
		for(var/path in synthesizers)
			if(!ispath(path, /obj/item/reagent_synth))
				if(istype(path, /obj/item/reagent_synth))
					created += path
				continue
			created += new path(src)
		synthesizers = created

/obj/machinery/chemical_dispenser/Destroy()
	QDEL_LIST_NULL(cartridges)
	QDEL_LIST_NULL(synthesizers)
	if(inserted)
		QDEL_NULL(inserted)
	macros = null
	if(cell)
		QDEL_NULL(cell)
		component_parts -= cell
	return ..()

/obj/machinery/chemical_dispenser/RefreshParts()
	var/total_capacitor_rating = 0
	var/total_capacitors = 0
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		total_capacitors++
		total_capacitor_rating += cap.rating
	recharge_rate = initial(recharge_rate) * (0.5 + (total_capacitor_rating / (total_capacitors || 1)) * 0.5)
	var/total_manip_rating = 0
	var/total_manips = 0
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		total_manips++
		total_manip_rating += manip.rating
	kj_per_unit = max(0, initial(kj_per_unit) - 0.25 * ((total_manip_rating / (total_manips || 1)) - 1))
	var/obj/item/cell/comp_cell = locate() in component_parts
	cell = comp_cell

/obj/machinery/chemical_dispenser/examine(mob/user, dist)
	. = ..()
	. += "It has [length(cartridges)] cartridges installed, and has space for [cartridges_max - length(cartridges)] more."

/obj/machinery/chemical_dispenser/process(delta_time)
	// todo: rework power handling
	if(machine_stat & NOPOWER)
		return
	if(!cell || !charging)
		return
	var/wanted = max(0, DYNAMIC_CELL_UNITS_TO_KW(cell.maxcharge - cell.charge, delta_time))
	if(!wanted)
		return
	// todo: this is shit, it doesn't update area power because our power code is primitive.
	var/kw_used = use_burst_power(min(recharge_rate * delta_time, wanted))
	if(!kw_used)
		return
	cell.give(DYNAMIC_KW_TO_CELL_UNITS(kw_used, delta_time))
	SStgui.update_uis(src)

// todo: refactor ai
/obj/machinery/chemical_dispenser/attack_ai(mob/user)
	ui_interact(user)
	return TRUE

// todo: refactor robot
/obj/machinery/chemical_dispenser/attack_robot(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/chemical_dispenser/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", name)
		ui.open()

/obj/machinery/chemical_dispenser/proc/ui_cartridge_data()
	var/list/carts_built = list()
	for(var/obj/item/reagent_containers/cartridge/dispenser/cart as anything in cartridges)
		carts_built[++carts_built.len] = list(
			"label" = cart.label,
			"amount" = cart.reagents?.total_volume || 0,
		)
	return carts_built

/obj/machinery/chemical_dispenser/proc/ui_macro_data()
	var/list/macros_built = list()
	var/index = 0
	for(var/list/L as anything in macros)
		macros_built[++macros_built.len] = L | list("index" = ++index)
	return macros_built

/obj/machinery/chemical_dispenser/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["cartridges"] = ui_cartridge_data()
	var/list/chems_built = list()
	// gather
	for(var/obj/item/reagent_synth/synth as anything in synthesizers)
		for(var/id in synth.reagents_provided)
			if(chems_built[id])
				continue
			var/datum/reagent/R = SSchemistry.get_reagent(id)
			if(!R)
				continue
			chems_built[id] = list(
				"id" = id,
				"name" = R.name,
			)
	// build
	var/list/chems_final = list()
	for(var/id in chems_built)
		chems_final += list(chems_built[id])
	.["reagents"] = chems_final
	.["macros"] = ui_macro_data()
	.["macros_full"] = length(macros) >= MAX_MACROS
	.["macros_max_steps"] = MAX_MACRO_STEPS

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	. = ..()
	.["amount"] = dispense_amount
	.["amount_max"] = dispense_amount_max
	.["has_cell"] = !!cell
	.["cell_charge"] = cell?.charge
	.["cell_capacity"] = cell?.maxcharge
	.["panel_open"] = panel_open
	.["has_beaker"] = !!inserted
	.["beaker"] = inserted?.reagents? list(
		"volume" = inserted.reagents.total_volume,
		"capacity" = inserted.reagents.maximum_volume,
		"data" = inserted.reagents.tgui_reagent_contents(),
		"name" = inserted.name,
	) : null
	.["recharging"] = charging
	.["recharge_rate"] = recharge_rate

/obj/machinery/chemical_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	switch(action)
		if("toggle_charge")
			charging = !charging
			return TRUE
		if("reagent")
			if(isnull(inserted?.reagents))
				return TRUE
			var/id = params["id"]
			if(!check_reagent_id(id))
				return TRUE
			var/amount = round(dispense_amount)
			if(!amount)
				return TRUE
			playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
			var/wanted = clamp(amount, 0, inserted.reagents.maximum_volume - inserted.reagents.total_volume)
			var/avail = min(wanted, cell.use(DYNAMIC_KJ_TO_CELL_UNITS(wanted * kj_per_unit)))
			inserted.reagents.add_reagent(id, avail)
			investigate_log("[key_name(usr)] dispensed [avail] of [id]", INVESTIGATE_REAGENTS)
			return TRUE
		if("cartridge")
			if(isnull(inserted?.reagents))
				return TRUE
			var/id = params["label"]
			if(!id)
				return TRUE
			var/obj/item/reagent_containers/cartridge/dispenser/cart
			for(cart as anything in cartridges)
				if(cart.label == id)
					break
			if(cart?.label != id)
				return TRUE
			playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
			cart.reagents.trans_to(inserted, dispense_amount)
			push_ui_data(data = list("cartridges" = ui_cartridge_data()))
			return TRUE
		if("amount")
			var/target = text2num(params["set"])
			if(isnull(target))
				return TRUE
			target = round(target)
			dispense_amount = clamp(target, 0, dispense_amount_max)
			return TRUE
		if("isolate")
			var/id = params["id"]
			if(isnull(id))
				return TRUE
			investigate_log("[key_name(usr)] isolated [id]", INVESTIGATE_REAGENTS)
			inserted?.reagents?.isolate_reagent(id)
			return TRUE
		if("purge")
			var/id = params["id"]
			if(isnull(id))
				return TRUE
			var/amount = isnull(params["amount"])? INFINITY : round(text2num(params["amount"]))
			if(!amount)
				return TRUE
			investigate_log("[key_name(usr)] purged[amount == INFINITY? "" : " [amount] of"] [id]", INVESTIGATE_REAGENTS)
			inserted?.reagents?.remove_reagent(id, amount)
			return TRUE
		if("eject")
			if(!inserted)
				return TRUE
			usr.grab_item_from_interacted_with(inserted, src)
			usr.visible_action_feedback(SPAN_NOTICE("[usr] ejects [inserted] from [src]."), src, range = MESSAGE_RANGE_INVENTORY_SOFT)
			investigate_log("[key_name(usr)] ejected [ref_name_path(inserted)]", INVESTIGATE_REAGENTS)
			inserted = null
			return TRUE
		if("eject_cart")
			if(!panel_open)
				return TRUE
			var/label = params["label"]
			if(isnull(label))
				return TRUE
			var/obj/item/reagent_containers/cartridge/dispenser/cart
			for(cart as anything in cartridges)
				if(cart.label == label)
					break
			if(cart?.label != label)
				return TRUE
			remove_cartridge(cart, usr)
			usr.grab_item_from_interacted_with(cart, src)
			usr.visible_action_feedback(SPAN_NOTICE("[usr] removes [cart] from [src]."), src, range = MESSAGE_RANGE_CONSTRUCTION)
			update_static_data()
			return TRUE
		if("eject_cell")
			if(!panel_open)
				return TRUE
			if(!cell)
				return TRUE
			usr.grab_item_from_interacted_with(cell, src)
			usr.visible_action_feedback(SPAN_NOTICE("[usr] removes [cell] from [src]."), src, range = MESSAGE_RANGE_CONSTRUCTION)
			component_parts -= cell
			cell = null
			return TRUE
		if("macro")
			var/index = text2num(params["index"])
			if(isnull(index) || (length(macros) < index))
				return TRUE
			playsound(src, 'sound/machines/reagent_dispense.ogg')
			var/list/the_list = macros[index]["data"]
			if(!length(the_list))
				return TRUE
			var/list/logstr = list()
			var/sound_lim = 4
			for(var/list/L as anything in the_list)
				var/id = L[1]
				if(!check_reagent_id(id))
					logstr += "[id]: skipped"
					break
				var/amount = L[2]
				amount = min(amount, dispense_amount_max)
				if(!amount)
					continue
				var/wanted = min(inserted.reagents.available_volume(), amount)
				if(!wanted)
					logstr += "interrupt-nospace"
					break
				wanted = min(wanted, cell.use(DYNAMIC_KJ_TO_CELL_UNITS(wanted * kj_per_unit)))
				if(!wanted)
					logstr += "interrupt-nopower"
					break
				logstr += "[id]: [wanted]"
				inserted.reagents.add_reagent(id, wanted)
				if(sound_lim)
					sound_lim--
					playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
			investigate_log("[key_name(usr)] dispensed macro [jointext(logstr, ", ")]", INVESTIGATE_REAGENTS)
			return TRUE
		if("add_macro")
			var/list/raw = params["data"]
			if(length(raw) > MAX_MACRO_STEPS)
				to_chat(usr, SPAN_WARNING("This macro is too long. Discarding. Max: [MAX_MACRO_STEPS] steps."))
				return TRUE
			var/name = params["name"]
			if(isnull(name))
				name = input(usr, "Name this macro", "Chemical Macro", "Macro") as text|null
			if(length(macros) > MAX_MACROS)
				return TRUE
			if(!length(raw) || !name)
				return TRUE
			var/list/built = list()
			for(var/list/L as anything in raw)
				built[++built.len] = list(
					L[1], round(text2num(L[2]))
				)
			raw.len = min(raw.len, MAX_MACRO_STEPS)
			LAZYINITLIST(macros)
			macros[++macros.len] = list(
				"name" = name,
				"data" = built,
			)
			update_static_data()
			return TRUE
		if("del_macro")
			var/index = text2num(params["index"])
			if(isnull(index) || (length(macros) < index))
				return TRUE
			macros.Cut(index, index + 1)
			update_static_data()
			return TRUE

/obj/machinery/chemical_dispenser/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	if(panel_open)
		if(istype(I, /obj/item/reagent_containers/cartridge/dispenser))
			var/obj/item/reagent_containers/cartridge/dispenser/cart = I
			if(!cart.label)
				user.action_feedback(SPAN_WARNING("[I] has no label!"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(length(cartridges) >= cartridges_max)
				user.action_feedback(SPAN_WARNING("[src] has no more room for cartridges."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_insert_item_for_installation(I, src))
				user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!insert_cartridge(I))
				I.forceMove(drop_location())
				return CLICKCHAIN_DO_NOT_PROPAGATE
			user.visible_action_feedback(SPAN_NOTICE("[user] inserts [I] into [src]."), src, range = MESSAGE_RANGE_CONSTRUCTION)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(istype(I, /obj/item/reagent_synth))
			var/obj/item/reagent_synth/synth = I
			if(synth.reagents_group)
				for(var/obj/item/reagent_synth/other as anything in synthesizers)
					if(other.reagents_group == synth.reagents_group)
						user.action_feedback(SPAN_WARNING("[src] already has a synthesis module of this type."), src)
						return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_insert_item_for_installation(I, src))
				user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			LAZYADD(synthesizers, synth)
			user.visible_action_feedback(SPAN_NOTICE("[user] inserts [I] into [src]."), src, range = MESSAGE_RANGE_CONSTRUCTION)
			update_static_data()
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(istype(I, /obj/item/cell))
			if(cell)
				user.action_feedback(SPAN_WARNING("[src] already has a cell."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_insert_item_for_installation(I, src))
				user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			cell = I
			component_parts |= cell
			user.visible_action_feedback(SPAN_NOTICE("[user] inserts [I] into [src]."), src, range = MESSAGE_RANGE_CONSTRUCTION)
			return CLICKCHAIN_DO_NOT_PROPAGATE

	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		// trying to insert
		if(!container.is_open_container())
			user.action_feedback(SPAN_WARNING("[I] can't be directly filled."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// check
		if(istype(container, /obj/item/reagent_containers/cartridge))
			// always fine
		else if(istype(container, /obj/item/reagent_containers/food) && !allow_drinking)
			user.action_feedback(SPAN_WARNING("[src] doesn't accept non-beakers."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// insert
		if(!user.transfer_item_to_loc(I, src))
			user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// process swap?
		if(inserted)
			investigate_log("[key_name(user)] ejected [ref_name_path(inserted)]", INVESTIGATE_REAGENTS)
			user.visible_action_feedback(SPAN_NOTICE("[user] quickly swaps [src]'s [inserted] for [I]."), src, range = MESSAGE_RANGE_INVENTORY_SOFT)
			user.put_in_hand_or_drop(inserted)
		else
			user.visible_action_feedback(SPAN_NOTICE("[user] inserts [I] into [src]."), src, range = MESSAGE_RANGE_INVENTORY_SOFT)
		investigate_log("[key_name(user)] inserted [ref_name_path(I)]", INVESTIGATE_REAGENTS)
		inserted = I
		SStgui.update_uis(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE

	return ..()

/obj/machinery/chemical_dispenser/proc/check_reagent_id(id)
	for(var/obj/item/reagent_synth/synth as anything in synthesizers)
		if(id in synth.reagents_provided)
			return TRUE
	return FALSE

/obj/machinery/chemical_dispenser/proc/remove_cartridge(obj/item/reagent_containers/cartridge/dispenser/cart, atom/where = drop_location())
	ASSERT(cart in cartridges)
	LAZYREMOVE(cartridges, cart)
	cart.forceMove(where)
	update_static_data()

/obj/machinery/chemical_dispenser/proc/insert_cartridge(obj/item/reagent_containers/cartridge/dispenser/cart)
	. = FALSE
	ASSERT(cart.label)
	for(var/obj/item/reagent_containers/cartridge/dispenser/other as anything in cartridges)
		if(other.label == cart.label)
			CRASH("collision on label.")
	LAZYADD(cartridges, cart)
	cart.forceMove(src)
	update_static_data()
	return TRUE

/obj/machinery/chemical_dispenser/crowbar_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct || !panel_open)
		return ..()
	if(default_deconstruction_crowbar(user, I))
		user.visible_message(SPAN_NOTICE("[user] dismantles [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/chemical_dispenser/screwdriver_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct)
		return ..()
	if(default_deconstruction_screwdriver(user, I))
		user.visible_message(SPAN_NOTICE("[user] [panel_open? "opens" : "closes"] the panel on [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/chemical_dispenser/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_unanchor)
		return ..()
	if(default_unfasten_wrench(user, I, 4 SECONDS))
		user.visible_message(SPAN_NOTICE("[user] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/chemical_dispenser/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	if(allow_unanchor)
		.[TOOL_WRENCH] = anchored? "anchor" : "unanchor"
	if(allow_deconstruct)
		.[TOOL_SCREWDRIVER] = panel_open? "close panel" : "open panel"
		if(panel_open)
			.[TOOL_CROWBAR] = "deconstruct"

/obj/machinery/chemical_dispenser/dynamic_tool_image(function, hint)
	switch(function)
		if(TOOL_WRENCH)
			return anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH)
		if(TOOL_SCREWDRIVER)
			return panel_open? dyntool_image_forward(TOOL_SCREWDRIVER) : dyntool_image_backward(TOOL_SCREWDRIVER)
	return ..()

/obj/machinery/chemical_dispenser/drop_products(method)
	. = ..()
	if(synthesizers && !synthesizers_swappable)
		QDEL_LIST(synthesizers) // nope
	for(var/obj/item/I as anything in (synthesizers | cartridges))
		drop_product(method, I)
	synthesizers = null
	cartridges = null
	if(inserted)
		drop_product(method, inserted)
		inserted = null
	if(cell)
		if(cell.loc == src)
			drop_product(method, cell)
		cell = null

/obj/machinery/chemical_dispenser/unanchored
	anchored = FALSE

#undef MAX_MACROS
#undef MAX_MACRO_STEPS
