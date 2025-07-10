SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 300

	//* static legacy shit *//

	/// amount of money for correctly approving / denying paperwork
	//  todo: faction specific
	var/money_reward_per_correct_manifest = 25
	/// amount of money deducted for incorrectly approved or denied paperwork
	//  todo: faction specific
	var/money_penalty_per_incorrect_manifest = 150
	/// amount of money given to the station per **second**
	//  todo: faction specific, drive with SSeconomy?
	var/money_passive_generation_per_second = 2.5
	/// world faction id to resolve account from
	var/cargo_account_faction_id = /datum/world_faction/core/station::id
	/// static account id to bind to withi nfaction
	var/cargo_account_bind_id = /datum/department/station/cargo::id
	/// export handlers
	var/list/datum/supply_export_handler/export_handlers = list(
		new /datum/supply_export_handler/auto_stacks,
	)
	/// default export faction
	var/datum/supply_faction/export_faction = new

	//* actual legacy stuff below *//

	// Control
	var/ordernum
	var/list/shoppinglist = list()			// Approved orders
	var/list/legacy_supply_packs = list()			// All supply packs
	var/static/list/legacy_supply_categories = list()
	var/list/legacy_exported_crates = list()		// Crates sent from the station
	var/list/order_history = list()			// History of orders, showing edits made by users
	// todo: replace with using a proper event logging api
	var/list/adm_order_history = list()		// Complete history of all orders, for admin use
	// todo: replace with using a proper event logging api
	var/list/adm_export_history = list()	// Complete history of all crates sent back on the shuttle, for admin use
	// Shuttle Movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle

/datum/controller/subsystem/supply/Initialize()
	ordernum = rand(1,9000)

	for(var/typepath in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new typepath()
		if(!P.legacy)
			continue
		legacy_supply_packs[P.name] = P
		legacy_supply_categories[P.category] = TRUE
		P.initialize()
	var/list/flattened = list()
	for(var/key in legacy_supply_categories)
		flattened += key
	legacy_supply_categories = flattened
	return SS_INIT_SUCCESS

// Supply shuttle SSticker - handles supply point regeneration
// This is called by the process scheduler every thirty seconds
/datum/controller/subsystem/supply/fire(resumed)
	var/datum/economy_account/cargo_account = resolve_station_cargo_account()
	// lag compensation
	var/elapsed_time_in_seconds = (world.time - last_fire) * 0.1
	cargo_account?.adjust_balance_without_logging(money_passive_generation_per_second)

// To stop things being sent to CentCom which should not be sent to centcom. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/radio/beacon))
		return 1
	if(istype(A,/obj/item/perfect_tele_beacon))
		return 1

	for(var/atom/B in A.contents)
		if(.(B))
			return 1

// Selling
/datum/controller/subsystem/supply/proc/sell()
	// todo: better way to grab eerything
	var/list/atom/movable/loose_entities = list()
	var/list/atom/movable/container_entities = list()
	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/entity in subarea)
			if(entity.anchored)
				continue
			if(entity.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
				continue
			if(entity.supply_export_is_container())
				container_entities += entity
			else
				loose_entities += entity

	legacy_supply_demand_supply_sell_hook(loose_entities + container_entities)

	var/datum/economy_account/account_to_fund = resolve_station_cargo_account()

	// handle loose
	if(length(loose_entities))
		legacy_supply_demand_supply_sell_hook(loose_entities)
		var/datum/supply_export/export = new(loose_entities)
		export.run(export_handlers, export_faction)

		#warn fund account
		var/datum/legacy_exported_crate/legacy_report = export.generate_legacy_exported_crate()
		adm_export_history += legacy_report.clone()
		legacy_exported_crates += legacy_report
	// handle containers
	if(length(container_entities))
		for(var/datum/supply_export/export_result as anything in recursively_sell_container_entities(container_entities))
			#warn fund account
			var/datum/legacy_exported_crate/legacy_report = export_result.generate_legacy_exported_crate()
			adm_export_history += legacy_report.clone()
			legacy_exported_crates += legacy_report
			#warn impl

	#warn handle returned / stamped manifests
	#warn this

/**
 * @return list(/datum/supply_export's)
 */
/datum/controller/subsystem/supply/proc/recursively_sell_container_entities(list/atom/movable/container_entities, datum/supply_export/parent_export, safety = 128) as /list
	RETURN_TYPE(/list)

	safety = min(128, safety)
	if(safety < 0)
		CRASH("hit safety on recursive container sell")

	. = list()
	for(var/atom/movable/container_entity as anything in container_entities)
		var/list/atom/movable/container_contents = list(container_entity)
		var/list/atom/movable/processing = container_entity.contents.Copy()
		var/list/atom/movable/nested_containers = list()
		for(var/i = 1, i <= length(processing), i++)
			var/atom/movable/inside = processing[i]
			if(inside.supply_export_is_container())
				nested_containers += inside
				continue
			container_contents += inside
			var/list/maybe_nested = inside.supply_export_recurse()
			if(maybe_nested)
				processing += maybe_nested

		var/datum/supply_export/container_export = new(container_contents)
		container_export.run(export_handlers, export_faction)
		. += container_export
		. += recursively_sell_container_entities(nested_containers, container_export, safety - 1)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if((A.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD)))
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T

	return clear_turfs

// Buying
/datum/controller/subsystem/supply/proc/buy()
	var/list/shoppinglist = list()
	for(var/datum/supply_order/SO in order_history)
		if(SO.status == SUP_ORDER_APPROVED)
			shoppinglist += SO

	if(!shoppinglist.len)
		return

	var/orderedamount = shoppinglist.len
	var/list/clear_turfs = get_clear_turfs()
	for(var/datum/supply_order/SO in shoppinglist)
		// if there's no space left don't cram in the rest
		var/turf/T = pick_n_take(clear_turfs)
		if(!T)
			break

		SO.status = SUP_ORDER_SHIPPED
		var/datum/supply_pack/SP = SO.object
		var/atom/movable/container = SP.instantiate_pack_at(T)
		// todo: containerless support
		if(!container)
			continue
		if(SO.comment)
			container.name += " ([SO.comment])"

		// Supply manifest generation begin
		var/obj/item/paper/manifest/slip
		if(!SP.legacy_contraband)
			slip = new /obj/item/paper/manifest(container)
			slip.is_copy = 0
			// save the trip to the string tree
			var/list/info = list()
			info += "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [station_name()]<br>"
			info +="[orderedamount] PACKAGES IN THIS SHIPMENT<br>"
			info += "<hr>"
			info += SP.get_html_manifest(container)
			info += "<hr>"
			info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS"
			info += "<hr>"
			slip.info += info.Join("")

// Will attempt to purchase the specified order, returning TRUE on success, FALSE on failure
/datum/controller/subsystem/supply/proc/approve_order(var/datum/supply_order/O, var/mob/user)
	// do not double purchase!!
	if(O.status != SUP_ORDER_REQUESTED)
		return FALSE
	var/datum/economy_account/cargo_account = resolve_station_cargo_account()
	// Not enough points to purchase the crate
	if(cargo_account.balance <= O.object.worth)
		return FALSE

	// Based on the current model, there shouldn't be any entries in order_history, requestlist, or shoppinglist, that aren't matched in adm_order_history
	var/datum/supply_order/adm_order
	for(var/datum/supply_order/temp in adm_order_history)
		if(temp.ordernum == O.ordernum)
			adm_order = temp
			break

	var/idname = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	// Update order status
	O.status = SUP_ORDER_APPROVED
	O.approved_by = idname
	O.approved_at = stationdate2text() + " - " + stationtime2text()
	// Update admin-side mirror
	adm_order.status = SUP_ORDER_APPROVED
	adm_order.approved_by = idname
	adm_order.approved_at = stationdate2text() + " - " + stationtime2text()

	// Deduct cost
	var/datum/economy_transaction/buy_transaction = new(O.object.worth)
	buy_transaction.audit_purpose_as_unsafe_html = "Cargo Purchase - [O.object.name]"
	buy_transaction.audit_terminal_as_unsafe_html = "Cargo Console"
	buy_transaction.execute_system_transaction(cargo_account)
	return TRUE

// Will deny the specified order. Only useful if the order is currently requested, but available at any status
/datum/controller/subsystem/supply/proc/deny_order(var/datum/supply_order/O, var/mob/user)
	// Based on the current model, there shouldn't be any entries in order_history, requestlist, or shoppinglist, that aren't matched in adm_order_history
	var/datum/supply_order/adm_order
	for(var/datum/supply_order/temp in adm_order_history)
		if(temp.ordernum == O.ordernum)
			adm_order = temp
			break

	var/idname = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	// Update order status
	O.status = SUP_ORDER_DENIED
	O.approved_by = idname
	O.approved_at = stationdate2text() + " - " + stationtime2text()
	// Update admin-side mirror
	adm_order.status = SUP_ORDER_DENIED
	adm_order.approved_by = idname
	adm_order.approved_at = stationdate2text() + " - " + stationtime2text()
	return

// Will deny all requested orders
/datum/controller/subsystem/supply/proc/deny_all_pending(var/mob/user)
	for(var/datum/supply_order/O in order_history)
		if(O.status == SUP_ORDER_REQUESTED)
			deny_order(O, user)

// Will delete the specified order from the user-side list
/datum/controller/subsystem/supply/proc/delete_order(var/datum/supply_order/O, var/mob/user)
	// Making sure they know what they're doing
	if(alert(user, "Are you sure you want to delete this record? If it has been approved, cargo points will NOT be refunded!", "Delete Record","No","Yes") == "Yes")
		if(alert(user, "Are you really sure? There is no way to recover the order once deleted.", "Delete Record", "No", "Yes") == "Yes")
			log_admin("[key_name(user)] has deleted supply order \ref[O] [O] from the user-side order history.")
			SSsupply.order_history -= O
	return

// Will generate a new, requested order, for the given supply pack type
/datum/controller/subsystem/supply/proc/create_order(var/datum/supply_pack/S, var/mob/user, var/reason)
	var/datum/supply_order/new_order = new()
	var/datum/supply_order/adm_order = new()	// Admin-recorded order must be a separate copy in memory, or user-made edits will corrupt it

	var/idname = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	new_order.ordernum = ++ordernum		// Ordernum is used to track the order between the playerside list of orders and the adminside list
	new_order.index = new_order.ordernum	// Index can be fabricated, or falsified. Ordernum is a permanent marker used to track the order
	new_order.object = S
	new_order.name = S.name
	new_order.cost = S.worth
	new_order.ordered_by = idname
	new_order.comment = reason
	new_order.ordered_at = stationdate2text() + " - " + stationtime2text()
	new_order.status = SUP_ORDER_REQUESTED

	adm_order.ordernum = new_order.ordernum
	adm_order.index = new_order.index
	adm_order.object = new_order.object
	adm_order.name = new_order.name
	adm_order.cost = new_order.cost
	adm_order.ordered_by = new_order.ordered_by
	adm_order.comment = new_order.comment
	adm_order.ordered_at = new_order.ordered_at
	adm_order.status = new_order.status

	order_history += new_order
	adm_order_history += adm_order

// Will delete the specified export receipt from the user-side list
/datum/controller/subsystem/supply/proc/delete_export(var/datum/legacy_exported_crate/E, var/mob/user)
	// Making sure they know what they're doing
	if(alert(user, "Are you sure you want to delete this record?", "Delete Record","No","Yes") == "Yes")
		if(alert(user, "Are you really sure? There is no way to recover the receipt once deleted.", "Delete Record", "No", "Yes") == "Yes")
			log_admin("[key_name(user)] has deleted export receipt \ref[E] [E] from the user-side export history.")
			SSsupply.legacy_exported_crates -= E

// Will add an item entry to the specified export receipt on the user-side list
/datum/controller/subsystem/supply/proc/add_export_item(var/datum/legacy_exported_crate/E, var/mob/user)
	var/new_name = input(user, "Name", "Please enter the name of the item.") as null|text
	if(!new_name)
		return

	var/new_quantity = input(user, "Name", "Please enter the quantity of the item.") as null|num
	if(!new_quantity)
		return

	var/new_value = input(user, "Name", "Please enter the value of the item.") as null|num
	if(!new_value)
		return

	E.contents[++E.contents.len] = list(
			"object" = new_name,
			"quantity" = new_quantity,
			"value" = new_value
		)

//* Economy *//

/**
 * gets the station's cargo account
 */
/datum/controller/subsystem/supply/proc/resolve_station_cargo_account() as /datum/economy_account
	return SSeconomy.resolve_keyed_account(/datum/department/station/cargo::id, /datum/world_faction/corporation/nanotrasen::id)

//* Entity Descriptors *//

/**
 * Resolves an entity descriptor, and instantiates it
 *
 * directly instantiated:
 * * typepath
 * * ~~anonymous typepath~~ Waiting on BYOND fix.
 *
 * clone()'d
 * * an /atom/movable
 *
 * instantiated with special handling
 * * /datum/prototype/material typepath or instance
 * * /obj/item/stack typepath or instance
 * * /datum/gas typepath or instance - container_hint can be:
 * ** /obj/machinery/portable_atmospherics/canister
 * ** /obj/item/tank
 *
 * translated, when `descriptor_hint` is specified.
 * * material id
 * * gas id - container_hint can be:
 * ** /obj/machinery/portable_atmospherics/canister
 * ** /obj/item/tank
 * * entity id as string (SSpersistence entity IDs)
 *
 * @params
 * * location - where to spawn it. null is valid!
 * * descriptor - the descriptor
 * * amount - amount to spawn
 * * descriptor_hint - SUPPLY_DESCRIPTOR_HINT_* to tell us what to translate the descriptor as; this forces the descriptor to be processed as text id lookup!
 * * container_hint - container hint, if allowed; using an invalid one will runtime.
 */
/datum/controller/subsystem/supply/proc/instantiate_entity_via_descriptor(descriptor, amount = 1, descriptor_hint, container_hint, atom/location)
	RETURN_TYPE(/atom/movable)
	if(!location || isarea(location))
		CRASH("invalid location")
	// todo: byond cannot introspect anonymous typepaths so just ignore it
	if(IS_ANONYMOUS_TYPEPATH(descriptor))
		return
	// handle instance
	if(istype(descriptor, /atom/movable))
		var/atom/movable/cloning_instance = descriptor
		if(istype(cloning_instance, /obj/item/stack))
			// lol no
			descriptor = cloning_instance.type
		else
			// actually clone
			for(var/i in 1 to min(amount, 50))
				cloning_instance.clone(location, TRUE)
			return
	// handle material stack
	if(ispath(descriptor, /obj/item/stack/material))
		var/obj/item/stack/material/casted_material_stack = descriptor
		descriptor = initial(casted_material_stack.material)
	// handle material
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_MATERIAL || ispath(descriptor, /datum/prototype/material))
		var/datum/prototype/material/resolved_material = RSmaterials.fetch(descriptor)
		resolved_material.place_sheet(location, amount)
		return
	// handle gas
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_GAS || ispath(descriptor, /datum/gas))
		var/datum/gas/resolved_gas
		if(ispath(descriptor))
			var/datum/gas/casted_gas = descriptor
			resolved_gas = global.gas_data.gases[initial(casted_gas.id)]
		else
			resolved_gas = global.gas_data.gases[resolved_gas]
		// todo: temperature support, for now everything ships at 273.15K
		switch(container_hint)
			if(/obj/item/tank)
				// tank, if possible
				var/obj/item/tank/tank_type = /obj/item/tank/shipment
				var/tank_pressure = initial(tank_type.volume)
				var/estimated_pressure = (R_IDEAL_GAS_EQUATION * 273.15 * amount) / tank_pressure
				if(estimated_pressure > TANK_LEAK_PRESSURE)
					stack_trace("tried to shove [amount] mols of [resolved_gas] into a shipment tank, which would result in a detonation")
				else
					var/obj/item/tank/created_tank = new /obj/item/tank/shipment(location)
					created_tank.air_contents.adjust_gas_temp(resolved_gas.id, amount, 273.15)
					return
		var/obj/machinery/portable_atmospherics/canister/created_canister = new(location)
		created_canister.air_contents.adjust_gas_temp(resolved_gas.id, amount, 273.15)
		return
	// translate to path
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_PROTOTYPE)
		var/entity_type = SSpersistence.prototype_id_to_path[descriptor]
		descriptor = entity_type
	// this point onwards: handle path
	if(ispath(descriptor, /obj/item/stack))
		var/obj/item/stack/casted_stack_path = descriptor
		var/stack_safety = 50
		var/amount_per_stack = initial(casted_stack_path.max_amount)
		while(amount > 0)
			var/amount_to_make = min(amount_per_stack, amount)
			new casted_stack_path(location, amount_to_make)
			amount -= amount_to_make
			if(--stack_safety < 0)
				break
		return
	for(var/i in 1 to min(amount, 50))
		new descriptor(location)

/**
 * Resolves an entity descriptor, and describes it with a string
 *
 * @return string
 */
/datum/controller/subsystem/supply/proc/describe_entity_via_descriptor(descriptor, amount = 1, descriptor_hint, container_hint)
	RETURN_TYPE(/atom/movable)
	// todo: byond cannot introspect anonymous typepaths so just ignore it
	if(IS_ANONYMOUS_TYPEPATH(descriptor))
		return
	// handle instance
	if(istype(descriptor, /atom/movable))
		var/atom/movable/cloning_instance = descriptor
		if(istype(cloning_instance, /obj/item/stack))
			// lol no
			descriptor = cloning_instance.type
		else
			return "[amount] [cloning_instance](s)"
	// handle material stack
	if(ispath(descriptor, /obj/item/stack/material))
		var/obj/item/stack/material/casted_material_stack = descriptor
		descriptor = initial(casted_material_stack.material)
	// handle material
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_MATERIAL || ispath(descriptor, /datum/prototype/material))
		var/datum/prototype/material/resolved_material = RSmaterials.fetch(descriptor)
		return "[amount] [resolved_material.sheet_plural_name] of [resolved_material.display_name]"
	// handle gas
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_GAS || ispath(descriptor, /datum/gas))
		var/datum/gas/resolved_gas
		if(ispath(descriptor))
			var/datum/gas/casted_gas = descriptor
			resolved_gas = global.gas_data.gases[initial(casted_gas.id)]
		else
			resolved_gas = global.gas_data.gases[resolved_gas]
		// todo: display_name for gas
		return "[amount] mol(s) of [resolved_gas]"
	// translate to path
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_PROTOTYPE)
		var/entity_type = SSpersistence.prototype_id_to_path[descriptor]
		descriptor = entity_type
	// this point onwards: handle path
	if(ispath(descriptor, /obj/item/stack))
		var/obj/item/stack/casted_stack_path = descriptor
		return "[amount] [initial(casted_stack_path.name)]"
	var/atom/movable/casted_movable_path = descriptor
	return "[amount] [initial(casted_movable_path.name)](s)"

/**
 * Resolves an entity descriptor, and estimates its worth
 *
 * @return number (thalers)
 */
/datum/controller/subsystem/supply/proc/value_entity_via_descriptor(descriptor, amount = 1, descriptor_hint, container_hint)
	RETURN_TYPE(/atom/movable)
	// todo: byond cannot introspect anonymous typepaths so just ignore it
	if(IS_ANONYMOUS_TYPEPATH(descriptor))
		return
	// handle instance
	if(istype(descriptor, /atom/movable))
		var/atom/movable/cloning_instance = descriptor
		if(istype(cloning_instance, /obj/item/stack))
			// lol no
			descriptor = cloning_instance.type
		else
			return amount * cloning_instance.worth(GET_WORTH_FLAGS_SUPPLY_DETECTION)
	// handle material stack
	if(ispath(descriptor, /obj/item/stack/material))
		var/obj/item/stack/material/casted_material_stack = descriptor
		descriptor = initial(casted_material_stack.material)
	// handle material
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_MATERIAL || ispath(descriptor, /datum/prototype/material))
		var/datum/prototype/material/resolved_material = RSmaterials.fetch(descriptor)
		return amount * resolved_material.worth
	// handle gas
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_GAS || ispath(descriptor, /datum/gas))
		var/datum/gas/resolved_gas
		if(ispath(descriptor))
			var/datum/gas/casted_gas = descriptor
			resolved_gas = global.gas_data.gases[initial(casted_gas.id)]
		else
			resolved_gas = global.gas_data.gases[resolved_gas]
		// todo: temperature support, for now everything ships at 273.15K
		switch(container_hint)
			if(/obj/item/tank)
				// tank, if possible
				var/obj/item/tank/tank_type = /obj/item/tank/shipment
				var/tank_pressure = initial(tank_type.volume)
				var/estimated_pressure = (R_IDEAL_GAS_EQUATION * 273.15 * amount) / tank_pressure
				if(estimated_pressure > TANK_LEAK_PRESSURE)
					stack_trace("tried to shove [amount] mols of [resolved_gas] into a shipment tank, which would result in a detonation")
		return amount * resolved_gas.worth
	// translate to path
	if(descriptor_hint == SUPPLY_DESCRIPTOR_HINT_PROTOTYPE)
		var/entity_type = SSpersistence.prototype_id_to_path[descriptor]
		descriptor = entity_type
	// this point onwards: handle path
	if(ispath(descriptor, /obj/item/stack))
		var/obj/item/stack/casted_stack_path = descriptor
		return amount * initial(casted_stack_path.worth_intrinsic)
	var/atom/movable/creating = new descriptor(null)
	. = creating.worth(GET_WORTH_FLAGS_SUPPLY_DETECTION) * amount
	qdel(creating)
