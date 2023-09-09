//TODO PLACEHOLDERS:
// todo: wtf are these they need to be subtyped properly and uhh yea
/datum/material/leather
	id = "leather"
	name = "leather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0

/datum/material/leather/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "wallet",
		product = /obj/item/storage/wallet,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "muzzle",
		product = /obj/item/clothing/mask/muzzle,
		cost = 2,
	)
	. += create_stack_recipe_datum(
		name = "botany gloves",
		product = /obj/item/clothing/gloves/botanic_leather,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "toolbelt",
		product = /obj/item/storage/belt/utility,
		cost = 4,
	)
	. += create_stack_recipe_datum(
		name = "leather satchel",
		product = /obj/item/storage/backpack/satchel,
		cost = 4,
	)
	. += create_stack_recipe_datum(
		name = "bandolier",
		product = /obj/item/storage/belt/security/tactical/bandolier,
		cost = 4,
	)
	. += create_stack_recipe_datum(
		name = "leather jacket",
		product = /obj/item/clothing/suit/storage/toggle/leather_jacket,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "leather shoes",
		product = /obj/item/clothing/shoes/laceup,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "leather overcoat",
		product = /obj/item/clothing/suit/overcoat,
		cost = 8,
	)
	. += create_stack_recipe_datum(
		name = "voyager satchel",
		product = /obj/item/storage/backpack/satchel/voyager,
		cost = 8,
	)
	. += create_stack_recipe_datum(
		name = "voyager backpack",
		product = /obj/item/storage/backpack/voyager,
		cost = 8,
	)
	. += create_stack_recipe_datum(
		name = "voyager harness",
		product = /obj/item/clothing/accessory/storage/voyager,
		cost = 8,
	)
