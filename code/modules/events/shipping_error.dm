/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = SSsupply.ordernum
	O.object = SSsupply.legacy_supply_packs[pick(SSsupply.legacy_supply_packs)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	SSsupply.shoppinglist += O
