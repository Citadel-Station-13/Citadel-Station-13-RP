/datum/material/plastic
	name = "plastic"
	id = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/plastic/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "plastic crate",
		product = /obj/structure/closet/crate/plastic,
		cost = 5,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "plastic bag",
		product = /obj/item/storage/bag/plasticbag,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "blood pack",
		product = /obj/item/reagent_containers/blood/empty,
		cost = 4,
	)
	. += create_stack_recipe_datum(
		name = "reagent dispenser cartridge (large)",
		product = /obj/item/reagent_containers/cartridge/dispenser/large,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "reagent dispenser cartridge (med)",
		product = /obj/item/reagent_containers/cartridge/dispenser/medium,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "reagent dispenser cartridge (small)",
		product = /obj/item/reagent_containers/cartridge/dispenser/small,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "shower curtain",
		product = /obj/structure/curtain,
		cost = 4,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "plastic flaps",
		product = /obj/structure/plasticflaps,
		cost = 4,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "airtight plastic flaps",
		product = /obj/structure/plasticflaps/mining,
		cost = 5,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "water-cooler",
		product = /obj/structure/reagent_dispensers/water_cooler,
		cost = 4,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "lampshade",
		product = /obj/item/lampshade,
		cost = 1,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "rubberized wheels",
		product = /obj/item/skate_wheels,
		cost = 12,
	)
	. += create_stack_recipe_datum(
		name = "plastic raincoat",
		product = /obj/item/clothing/suit/storage/hooded/rainponcho,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "white floor tile",
		product = /obj/item/stack/tile/floor/white,
		cost = 20,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "freezer floor tile",
		product = /obj/item/stack/tile/floor/freezer,
		cost = 20,
		amount = 4,
	)

/datum/material/plastic/holographic
	name = "holoplastic"
	id = "plastic_holo"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE
