/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	w_class = ITEMSIZE_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 100
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	display_contents_with_number = 1
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 200
	materials_base = list(
		MAT_STEEL = 8000,
		MAT_GLASS = 2500,
	)
	var/panel_req = TRUE

/obj/item/storage/part_replacer/basic
	name = "basic part exchanger"
	desc = "A basic part exchanger. It can't seem to store much."
	storage_slots = 35
	materials_base = list(
		MAT_STEEL = 4000,
		MAT_GLASS = 1500,
	)

/obj/item/storage/part_replacer/adv
	name = "advanced rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity"
	icon_state = "RPED"
	w_class = ITEMSIZE_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 200
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	display_contents_with_number = 1
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 400
	materials_base = list(
		MAT_STEEL = 12000,
		MAT_GLASS = 4000,
	)

/obj/item/storage/part_replacer/adv/discount_bluespace
	name = "discount bluespace rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts.  This one has a further increased storage capacity, \
	and the ability to work on machines with closed maintenance panels."
	storage_slots = 400
	max_storage_space = 800
	panel_req = FALSE

/obj/item/storage/part_replacer/drop_contents() // hacky-feeling tier-based drop system
	hide_from(usr)
	var/turf/T = get_turf(src)
	var/lowest_rating = INFINITY // We want the lowest-part tier rating in the RPED so we only drop the lowest-tier parts.
	/*
	* Why not just use the stock part's rating variable?
	* Future-proofing for a potential future where stock parts aren't the only thing that can fit in an RPED.
	* see: /tg/ and /vg/'s RPEDs fitting power cells, beakers, etc.
	*/
	for(var/obj/item/B in contents)
		if(B.rped_rating() < lowest_rating)
			lowest_rating = B.rped_rating()
	for(var/obj/item/B in contents)
		if(B.rped_rating() > lowest_rating)
			continue
		remove_from_storage(B, T)
