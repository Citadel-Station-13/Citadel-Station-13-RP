/datum/prototype/material/snow
	id = "snow"
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#FFFFFF"
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile

	relative_integrity = 0.25
	weight_multiplier = 1
	density = 8 * 0.2
	relative_conductivity = 0.7
	relative_permeability = 0.8
	relative_reactivity = 0.6
	hardness = MATERIAL_RESISTANCE_VULNERABLE
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_VERY_VULNERABLE

/datum/prototype/material/snow/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "snowball",
		product = /obj/item/material/snow/snowball,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "snow brick",
		product = /obj/item/stack/material/snowbrick,
		cost = 2,
	)
	. += create_stack_recipe_datum(
		name = "snowman",
		product = /obj/structure/snowman,
		cost = 2,
	)
	. += create_stack_recipe_datum(
		name = "snow robot",
		product = /obj/structure/snowman/borg,
		cost = 2,
	)
	. += create_stack_recipe_datum(
		name = "snow spider",
		product = /obj/structure/snowman/spider,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "snowman head",
		product = /obj/item/clothing/head/snowman,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "snowman suit",
		product = /obj/item/clothing/suit/snowman,
		cost = 10,
	)

/datum/prototype/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	id = "snow_packed"
	name = "packed snow"
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D8FDFF"
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

	relative_integrity = 0.5
	weight_multiplier = 1
	density = 8 * 0.2
	relative_conductivity = 0.5
	relative_permeability = 0.4
	relative_reactivity = 0.3
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_VULNERABLE
