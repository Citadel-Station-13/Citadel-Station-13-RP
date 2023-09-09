/datum/material/cloth //todo
	id = "cloth"
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	stack_type = /obj/item/stack/material/cloth
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	flags = MATERIAL_PADDING
	conductive = 0
	pass_stack_colors = TRUE

/datum/material/cloth/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "uniform",
		product = /obj/item/clothing/under/color/white,
		cost = 8,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "foot wraps",
		product = /obj/item/clothing/shoes/footwraps,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "gloves",
		product = /obj/item/clothing/gloves/white,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "wig",
		product = /obj/item/clothing/head/powdered_wig,
		cost = 4,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "philosopher's wig",
		product = /obj/item/clothing/head/philosopher_wig,
		cost = 5,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "taqiyah",
		product = /obj/item/clothing/head/taqiyah,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "turban",
		product = /obj/item/clothing/head/turban,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "hijab",
		product = /obj/item/clothing/head/hijab,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "kippa",
		product = /obj/item/clothing/head/kippa,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "kippa",
		product = /obj/item/clothing/head/traveller,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "scarf",
		product = /obj/item/clothing/accessory/scarf/white,
		cost = 4,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "baggy pants",
		product = /obj/item/clothing/under/pants/baggy/white,
		cost = 8,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "belt pouch",
		product = /obj/item/storage/belt/fannypack/white,
		cost = 8,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "crude bandage",
		product = /obj/item/stack/medical/crude_pack,
		cost = 1,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "empty sandbag",
		product = /obj/item/stack/emptysandbag,
		cost = 2,
		amount = 5,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "shrine seal",
		product = /obj/structure/shrine_seal,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "cloth rag",
		product = /obj/item/reagent_containers/glass/rag,
		cost = 1,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "woven string",
		product = /obj/item/weaponcrafting/string,
		cost = 1,
		time = 2 SECONDS,
	)

/datum/material/carpet
	id = "carpet"
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/datum/material/cloth_teal
	id = "cloth_teal"
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_black
	id = "cloth_black"
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_green
	id = "cloth_green"
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_puple
	id = "cloth_purple"
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_blue
	id = "cloth_blue"
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_beige
	id = "cloth_beige"
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_lime
	id = "cloth_lime"
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0
