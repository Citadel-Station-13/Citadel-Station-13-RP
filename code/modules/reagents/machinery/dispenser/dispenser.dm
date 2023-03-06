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
	/// allow beakers
	var/allow_beakers = TRUE
	/// allow drinking glasses
	var/allow_drinking = TRUE
	/// allow all other opencontainer reagent containers
	var/allow_other = FALSE
	/// current dispense amount
	var/dispense_amount = 10
	/// power in kilojoules per unit synthesized
	var/kj_per_unit = 4 // ~5k units on 10k cell

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

/obj/machinery/chemical_dispenser/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Alt-click while the panel is open to remove cartridges.")

/obj/machinery/chemical_dispenser/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/list/carts_built = list()
	for(var/obj/item/reagent_containers/cartridge/dispenser/cart as anything in cartridges)
		carts_built[++carts_built.len] = list(
			"label" = cart.label,
			"amount" = cart.reagents?.total_volume || 0,
		)
	.["cartridges"] = carts_built

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	. = ..()
	.["has_cell"] = !!cell
	.["cell_charge"] = cell.charge
	.["cell_capacity"] = cell.maxcharge

/obj/machinery/chemical_dispenser/ui_act(action, params)
	. = ..()

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

/obj/machinery/chemical_dispenser/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	. = ..()
	if(.)
		return

	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		if(istype(I, /obj/item/reagent_containers/cartridge/dispenser))
			var/obj/item/reagent_containers/cartridge/dispenser/cart = I
			if(!panel_open)
				user.action_feedback(SPAN_WARNING("How are you going to insert that while [src] is closed?"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!cart.label)
				user.action_feedback(SPAN_WARNING("[I] has no label!"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(length(cartridges) >= cartridges_max)
				user.action_feedback(SPAN_WARNING("[src] has no more room for cartridges."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.transfer_item_to_loc(I, src))
				user.action_feedback(SPAN_WARNING("[I] is stuck to your hand."), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!add_cartridge(I))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			user.visible_message(SPAN_NOTICE("[user] inserts [I] into [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// trying to insert

		#warn impl

/obj/machinery/chemical_dispenser/proc/remove_cartridge(obj/item/reagent_containers/cartridge/dispenser/cart, atom/where = drop_location())
	ASSERT(cart in cartridges)
	cartrdiges -= cart
	cart.forceMove(where)
	update_static_data()

/obj/machinery/chemical_dispenser/proc/insert_cartridge(obj/item/reagent_containers/cartridge/dispenser/cart)
	ASSERT(cart.label)
	cartridges += cart
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
