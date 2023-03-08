/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "dispenser"

	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	anchored = TRUE
	allow_unanchor = TRUE
	allow_deconstruct = TRUE

	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OPEN_SILICON

	#warn circuitboard
	#warn stock parts + cell

	/// reagent synthesizers in us - set to list of typepaths to init on Initialize().
	var/list/obj/item/reagent_synth/synthesizers
	/// synthesizers are swappable
	var/synthesizers_swappable = TRUE
	/// cartridges in us, usable for dispensing with.
	var/list/obj/item/reagent_containers/cartridge/dispenser/cartridges
	/// max cartridges
	var/cartridges_max = 50
	/// our cell
	var/obj/item/cell/cell
	/// initial cell type
	var/cell_type = /obj/item/cell/high
	/// recharge rate in KW
	var/recharge_rate = 5
	/// inserted beaker / whatever
	var/obj/item/reagent_containers/inserted
	/// allow drinking glasses
	var/allow_drinking = TRUE
	/// current dispense amount
	var/dispense_amount = 10
	/// max dispense amount - this is relatively important to prevent *easy* maxcaps.
	var/dispense_amount_max = 60
	/// power in kilojoules per unit synthesized
	var/kj_per_unit = 4 // ~5k units on 10k cell
	/// is recharging active?
	var/charging = TRUE
	/// macros: list of list("name" = name, "data" = list("id" = amount, ...))
	var/list/macros

/obj/machinery/chemical_dispenser/Initialize(mapload)
	. = ..()
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
	return ..()

/obj/machinery/chemical_dispenser/examine(mob/user)
	. = ..()
	. += "It has [length(cartridges)] cartridges installed, and has space for [cartridges_max - length(cartridges)] more."

/obj/machinery/chemical_dispenser/process(delta_time)
	// todo: rework power handling
	if(machine_stat & NOPOWER)
		return
	if(!cell)
		return
	var/wanted = max(0, DYNAMIC_CELL_UNITS_TO_KW(cell.maxcharge - cell.charge, delta_time))
	if(!wanted)
		return
	var/kw_used = use_power_oneoff(min(recharge_rate * delta_time, wanted))
	if(!kw_used)
		return
	cell.give(DYNAMIC_KW_TO_CELL_UNITS(kw_used, delta_time))
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser")
		ui.open()

/obj/machinery/chemical_dispenser/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/list/carts_built = list()
	for(var/obj/item/reagent_containers/cartridge/dispenser/cart as anything in cartridges)
		carts_built[++carts_built.len] = list(
			"label" = cart.label,
			"amount" = cart.reagents?.total_volume || 0,
		)
	.["cartridges"] = carts_built
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
	.["reagents"] = chems_built
	.["macros"] = macros || list()

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	. = ..()
	.["amount"] = dispense_amount
	.["amount_max"] = dispense_amount_max
	.["has_cell"] = !!cell
	.["cell_charge"] = cell.charge
	.["cell_capacity"] = cell.maxcharge
	.["panel_open"] = panel_open
	.["has_beaker"] = !!inserted
	.["beaker"] = inserted?.reagents? list(
		"volume" = inserted.reagents.total_volume,
		"capacity" = inserted.reagents.maximum_volume,
		"data" = inserted.reagents.tgui_reagent_contents(),
	) : null

/obj/machinery/chemical_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	switch(action)
		if("reagent")
			if(isnull(inserted?.reagents))
				return TRUE
			var/id = params["id"]
			if(!check_reagent_id(id))
				return TRUE
			var/amount = round(text2num(params["amount"]))
			if(!amount)
				return TRUE
			playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
			inserted.reagents.add_reagent(id, amount)
			return TRUE
		if("cartridge")
			if(isnull(inserted?.reagents))
				return TRUE
			var/id = params["id"]
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
			return TRUE
		if("amount")
			var/target = text2num(params["set"])
			if(isnull(target))
				return TRUE
			target = round(target)
			dispense_amount = clamp(target, 0, dispense_amount_max)
			return TRUE
		if("isolate")
			var/id = params["reagent"]
			if(isnull(id))
				return TRUE
			inserted?.reagents?.isolate_reagent(id)
			return TRUE
		if("purge")
			var/id = params["reagent"]
			if(isnull(id))
				return TRUE
			var/amount = round(text2num(params["amount"]))
			if(!amount)
				return TRUE
			inserted?.reagents?.remove_reagent(id, amount)
			return TRUE
		if("eject")
			#warn impl
		if("eject_cart")
			#warn impl
		if("add_macro")
			#warn validate
			return TRUE
		if("del_macro")
			var/index = text2num(params["index"])
			if(isnull(index) || (length(macros) < index))
				return TRUE
			macros.Cut(index, index + 1)
			update_static_data()
			return TRUE

/obj/machinery/chemical_dispenser/AltClick(mob/user)
	. = ..()
	if(.)
		return
	if(!panel_open)
		return
	. = TRUE
	if(INTERACTING_WITH_FOR(user, src, INTERACTING_FOR_ALT_CLICK))
		return
	START_INTERACTING_WITH(user, src, INTERACTING_FOR_ALT_CLICK)
	var/obj/item/reagent_containers/cartridge/dispenser/target = show_radial_menu(user, src, cartridges)
	STOP_INTERACTING_WITH(user, src, INTERACTING_FOR_ALT_CLICK)
	if(!(target in cartridges))
		return
	user.visible_message(SPAN_NOTICE("[user] removes [target] from src."), range = MESSAGE_RANGE_CONSTRUCTION)
	remove_cartridge(target, user)
	user.put_in_hands_or_drop(target)
	update_static_data()
	#warn move to tgui

/obj/machinery/chemical_dispenser/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

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
			user.visible_message(SPAN_NOTICE("[user] inserts [I] into [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
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
			synthesizers += synth
			update_static_data()
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
			user.action_feedback(SPAN_WARNING("[src] doesn't accept beakers."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// insert
		if(!user.transfer_item_to_loc(I, src))
			user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// process swap?
		if(inserted)
			user.visible_action_feedback(SPAN_NOTICE("[user] quickly swaps [src]'s [inserted] for [I]."), src, range = MESSAGE_RANGE_INVENTORY_SOFT)
		else
			user.visible_action_feedback(SPAN_NOTICE("[user] inserts [I] into [src]."), src, range = MESSAGE_RANGE_INVENTORY_SOFT)
			user.put_in_hand_or_drop(inserted)
		inserted = I
		SStgui.update_uis(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE

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
	ASSERT(cart.label)
	for(var/obj/item/reagent_containers/cartridge/dispenser/other as anything in cartridges)
		if(other.label == cart.label)
			CRASH("collision on label.")
	LAZYADD(cartridges, cart)
	cart.forceMove(src)
	update_static_data()

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
	for(var/obj/item/I as anything in (synthesizers | cartridges))
		I.forceMove(drop_location())
	synthesizers = null
	cartridges = null
	inserted.forceMove(drop_location())

/obj/machinery/chemical_dispenser/unanchored
	anchored = FALSE
