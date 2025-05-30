//TODO PLACEHOLDERS:
// todo: wtf are these they need to be subtyped properly and uhh yea
/datum/prototype/material/leather
	id = "leather"
	name = "leather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2)
	ignition_point = T0C+300
	melting_point = T0C+300

	relative_integrity = 1
	density = 8 * 0.5
	weight_multiplier = 1
	relative_conductivity = 0.25
	relative_permeability = 0.2
	relative_reactivity = 0.3
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

	worth = 2.5

/datum/prototype/material/leather/generate_recipes()
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
