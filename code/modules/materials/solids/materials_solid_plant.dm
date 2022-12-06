/datum/material/solid/cotton
	name = "cotton"
	uid = "solid_cotton"
	display_name ="cotton"
	color = "#FFFFFF"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/solid/algae
	name = "algae"
	uid = "solid_algae"
	stack_type = /obj/item/stack/material/algae
	color = "#557722"
	shard_type = SHARD_STONE_PIECE
	weight = 10
	hardness = 10
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/obj/item/stack/material/algae
	name = "algae sheet"
	icon_state = "sheet-uranium"
	color = "#557722"
	default_type = /datum/material/solid/algae

/obj/item/stack/material/algae/ten
	amount = 10
