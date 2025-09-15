/datum/prototype/material/uranium
	id = MAT_URANIUM
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#007A00"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	tgui_icon_key = "uranium"

	worth = 17.5

	relative_integrity = 1.2
	weight_multiplier = 1
	density = 8 * 2.25
	relative_conductivity = 1.5
	relative_permeability = 0
	relative_reactivity = 0.05
	hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

	material_constraints = MATERIAL_CONSTRAINT_RIGID

	material_traits = list(
		/datum/prototype/material_trait/radioactive = 10,
	)

/datum/prototype/material/uranium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "engineer statue", product = /obj/structure/statue/uranium/eng, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "nuke statue", product = /obj/structure/statue/uranium/nuke, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "uranium floor tiles", product = /obj/item/stack/tile/uranium, amount = 4)
