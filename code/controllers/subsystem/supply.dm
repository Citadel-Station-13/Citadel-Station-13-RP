SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 300
	// Supply Points
	var/points = 50
	var/points_per_second = 1.5 / 30
	var/points_per_slip = 2
	var/points_per_money = 0.02 // 1 point for $50
	var/points_per_trash = 0.1 // Weighted value, tentative.
	// Control
	var/ordernum
	var/list/shoppinglist = list()			// Approved orders
	var/list/supply_pack = list()			// All supply packs
	var/list/exported_crates = list()		// Crates sent from the station
	var/list/order_history = list()			// History of orders, showing edits made by users
	var/list/adm_order_history = list()		// Complete history of all orders, for admin use
	var/list/adm_export_history = list()	// Complete history of all crates sent back on the shuttle, for admin use
	// Shuttle Movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle
	var/list/material_points_conversion = list(	// Any materials not named in this list are worth 0 points
			MAT_PHORON = 5,
			MAT_PLATINUM = 5,
			MAT_GOLD = 2,		// CIT CHANGE: Gold is now worth 2 cargo points per sheet
			MAT_SILVER = 2,	// CIT CHANGE: Silver is now worth 2 cargo points per sheet
			MAT_URANIUM = 1	// CIT CHANGE: Uranium is now worth 1 cargo point per sheet
		)

// TODO - Refactor to use the Supply Subsystem (SSsupply)

// Supply packs are in /code/datums/supplypacks
// Computers are in /code/game/machinery/computer/supply.dm

/datum/supply_order
	var/ordernum							// Unfabricatable index
	var/index								// Fabricatable index
	var/datum/supply_pack/object = null
	var/cost								// Cost of the supply pack (Fabricatable) (Changes not reflected when purchasing supply packs, this is cosmetic only)
	var/name								// Name of the supply pack datum (Fabricatable)
	var/ordered_by = null					// Who requested the order
	var/comment = null						// What reason was given for the order
	var/approved_by = null					// Who approved the order
	var/ordered_at							// Date and time the order was requested at
	var/approved_at							// Date and time the order was approved at
	var/status								// [Requested, Accepted, Denied, Shipped]

/datum/exported_crate
	var/name
	var/value
	var/list/contents

/datum/controller/subsystem/supply/Initialize()
	ordernum = rand(1,9000)

	for(var/typepath in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new typepath()
		supply_pack[P.name] = P
	return ..()

// Supply shuttle SSticker - handles supply point regeneration
// This is called by the process scheduler every thirty seconds
/datum/controller/subsystem/supply/fire(resumed)
	points += max(0, ((world.time - last_fire) / 10) * points_per_second)

// To stop things being sent to CentCom which should not be sent to centcomm. Recursively checks for these types.
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
	// Loop over each area in the supply shuttle
	for(var/area/subarea in shuttle.shuttle_area)
		callHook("sell_shuttle", list(subarea));
		for(var/atom/movable/MA in subarea)
			if(MA.anchored)
				continue

			var/datum/exported_crate/EC = new /datum/exported_crate()
			EC.name = "\proper[MA.name]"
			EC.value = 0
			EC.contents = list()
			var/base_value = 0

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = MA
				callHook("sell_crate", list(CR, subarea))

				points += CR.points_per_crate
				if(CR.points_per_crate)
					base_value = CR.points_per_crate
				var/find_slip = 1

				for(var/atom/A in CR)
					EC.contents[++EC.contents.len] = list(
							"object" = "\proper[A.name]",
							"value" = 0,
							"quantity" = 1
						)

					// Sell manifests
					if(find_slip && istype(A,/obj/item/paper/manifest))
						var/obj/item/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len)	// Yes, the clown stamp will work. clown is the highest authority on the station, it makes sense, trust me guys
							points += points_per_slip
							EC.contents[EC.contents.len]["value"] = points_per_slip
							find_slip = 0
						continue

					// Sell phoron and platinum
					if(istype(A, /obj/item/stack))
						var/obj/item/stack/P = A
						if(material_points_conversion[P.get_material_name()])
							EC.contents[EC.contents.len]["value"] = P.get_amount() * material_points_conversion[P.get_material_name()]
						EC.contents[EC.contents.len]["quantity"] = P.get_amount()
						EC.value += EC.contents[EC.contents.len]["value"]

					// Sell spacebucks
					if(istype(A, /obj/item/spacecash))
						var/obj/item/spacecash/cashmoney = A
						EC.contents[EC.contents.len]["value"] = cashmoney.worth * points_per_money
						EC.contents[EC.contents.len]["quantity"] = cashmoney.worth
						EC.value += EC.contents[EC.contents.len]["value"]

					// Sell trash
					if(istype(A, /obj/item/trash))
						EC.contents[EC.contents.len]["value"] = points_per_trash


			// Make a log of it, but it wasn't shipped properly, and so isn't worth anything
			else
				EC.contents = list(
						"error" = "Error: Product was improperly packaged. Payment rendered null under terms of agreement."
					)

			exported_crates += EC
			points += EC.value
			EC.value += base_value

			// Duplicate the receipt for the admin-side log
			var/datum/exported_crate/adm = new()
			adm.name = EC.name
			adm.value = EC.value
			adm.contents = deep_copy_list(EC.contents)
			adm_export_history += adm

			qdel(MA)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if((A.atom_flags & ATOM_ABSTRACT))
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
		var/atom/movable/container = SP.Instantiate(T)
		if(SO.comment)
			container.name += " [SO.comment]"

		// Supply manifest generation begin
		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
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
	// Not enough points to purchase the crate
	if(SSsupply.points <= O.object.cost)
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
	SSsupply.points -= O.object.cost
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
	new_order.cost = S.cost
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
/datum/controller/subsystem/supply/proc/delete_export(var/datum/exported_crate/E, var/mob/user)
	// Making sure they know what they're doing
	if(alert(user, "Are you sure you want to delete this record?", "Delete Record","No","Yes") == "Yes")
		if(alert(user, "Are you really sure? There is no way to recover the receipt once deleted.", "Delete Record", "No", "Yes") == "Yes")
			log_admin("[key_name(user)] has deleted export receipt \ref[E] [E] from the user-side export history.")
			SSsupply.exported_crates -= E
	return

// Will add an item entry to the specified export receipt on the user-side list
/datum/controller/subsystem/supply/proc/add_export_item(var/datum/exported_crate/E, var/mob/user)
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
