/**
 * an instance of a supply system
 *
 * holds its own:
 *
 * * orders
 * * exports
 * * stored currency (real or virtual)
 * * handler
 */
/datum/supply_system
	/// registered?
	var/registered = FALSE
	/// unique id
	var/id
	/// the handler used by default
	var/datum/supply_handler/default_handler

	/// markup on crates as multiplier
	var/mult_packs = 1
	/// markup on small orders as multiplier
	var/mult_goodies = 1
	/// price of exports as multiplier - 2 = exports sell twice as high
	var/mult_exports = 1

	/// pending orders
	var/list/datum/supply_order/pending
	/// accepted orders
	var/list/datum/supply_order/accepted
	/// finished orders
	var/list/datum/supply_order/delivered

	/// completed outgoing shipments
	var/list/datum/supply_shipment/shipped


/datum/supply_system/New(id, datum/supply_handler/default_handler)
	src.default_handler = default_handler
	src.id = id
	register()

/datum/supply_system/Destroy()
	if(registered)
		unregister()
	return ..()

/datum/supply_system/proc/register()
	#warn impl

/datum/supply_system/proc/unregister()
	#warn impl

/datum/supply_system/proc/credits()
	CRASH("abstract credits called")

/datum/supply_system/proc/pay(amt, obfuscate, datum/supply_export/export)
	CRASH("abstract add credits called")

/datum/supply_system/proc/spend(amt, obfuscate, datum/supply_order/order)
	CRASH("abstract remove credits called")



