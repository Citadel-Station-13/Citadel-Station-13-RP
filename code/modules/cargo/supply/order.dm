/datum/supply_order
	/// status
	var/status = SUPPLY_ORDER_ERRORED
	/// using handler; defaults to the supply system's default handler
	var/datum/supply_handler/handler
	/// is a private order?
	var/private = FALSE


#warn impl

/datum/supply_order/proc/ui_data_list()
	. = list(
		"id" = id,
		"status" = status,
	)

/datum/supply_order/pack
	/// pack datum
	var/datum/supply_pack/pack

/datum/supply_order/items
	/// item datums associated to amount
	var/list/datum/supply_item/items
