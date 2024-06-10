/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	w_class = WEIGHT_CLASS_HUGE
	storage_datum_path = /datum/object_system/storage/stock_parts
	insertion_whitelist = list(
		/obj/item/stock_parts,
		/obj/item/cell,
		/obj/item/reagent_containers/glass/beaker,
	)
	allow_mass_gather = TRUE
	allow_quick_empty = TRUE
	allow_quick_empty_via_attack_self = TRUE
	ui_numerical_mode = TRUE
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_items = 100
	max_combined_volume = 100
	ui_expand_when_needed = TRUE
	materials_base = list(
		MAT_STEEL = 8000,
		MAT_GLASS = 2500,
	)
	var/panel_req = TRUE

/obj/item/storage/part_replacer/basic
	name = "basic part exchanger"
	desc = "A basic part exchanger. It can't seem to store much."
	materials_base = list(
		MAT_STEEL = 4000,
		MAT_GLASS = 1500,
	)

/obj/item/storage/part_replacer/adv
	name = "advanced rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity"
	icon_state = "RPED"
	max_items = 200
	max_combined_volume = 200
	materials_base = list(
		MAT_STEEL = 12000,
		MAT_GLASS = 4000,
	)

/obj/item/storage/part_replacer/adv/discount_bluespace
	name = "discount bluespace rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts.  This one has a further increased storage capacity, \
	and the ability to work on machines with closed maintenance panels."
	max_items = 400
	max_combined_volume = 800
	panel_req = FALSE
