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
	max_combined_volume = 200
	ui_expand_when_needed = 5
	materials_base = list(
		MAT_STEEL = 8000,
		MAT_GLASS = 2500,
	)
	var/panel_req = TRUE
	var/part_replacement_sound = "sound/items/rped.ogg"

/obj/item/storage/part_replacer/basic
	name = "basic part exchanger"
	desc = "A basic part exchanger. It can't seem to store much."
	materials_base = list(
		MAT_STEEL = 4000,
		MAT_GLASS = 1500,
	)

/obj/item/storage/part_replacer/adv
	name = "advanced rapid part exchange device"
	desc = "A special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity."
	icon_state = "RPED"
	max_items = 200
	max_combined_volume = 400
	materials_base = list(
		MAT_STEEL = 12000,
		MAT_GLASS = 4000,
	)

/obj/item/storage/part_replacer/experimental
	name = "experimental rapid part exchange device"
	icon_state = "BS_RPED"
	w_class = WEIGHT_CLASS_NORMAL
	desc = "A special mechanical module made to store, sort, and apply standard machine parts. This one has a further increased storage capacity, \
	has been made more compact, and has the ability to work on machines with closed maintenance panels by automatically screwing open and \
	closing a maintenance panel."
	max_items = 300
	max_combined_volume = 600
	materials_base = list(
		MAT_STEEL = 8000,
		MAT_GLASS = 2000,
		MAT_SILVER = 1000,
		MAT_URANIUM = 4000, //cost of an artificial bluespace crystal
		MAT_DIAMOND = 2000
	)
	panel_req = FALSE
