/datum/supply_order
	/// status
	var/status = SUPPLY_ORDER_ERRORED

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

