/datum/cooking_recipe

	var/list/recipe_reagents // example: = list("berryjuice" = 5) // do not list same reagent twice
	var/list/recipe_items    // example: = list(/obj/item/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/recipe_fruit    // example: = list("fruit" = 3)

	var/result // example: = /obj/item/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.

	var/required_method = METHOD_OVEN //Which method is required for this recipe

/datum/cooking_recipe/test_soup

	recipe_reagents = list("water" = 10) // example: = list("berryjuice" = 5) // do not list same reagent twice
	recipe_items = list(/obj/item/reagent_containers/food/snacks/ingredient/plant = 1) // example: = list(/obj/item/reagent_containers/food/snacks/ingredient/meat = 1, /obj/item/reagent_containers/food/snacks/ingredient/sludge = 1) // place /foo/bar before /foo

	result = /obj/item/reagent_containers/food/snacks/wishsoup // example: = /obj/item/reagent_containers/food/snacks/donut/normal

/datum/cooking_recipe/ultrameat

	recipe_items = list(/obj/item/reagent_containers/food/snacks/ingredient = 1) // example: = list(/obj/item/reagent_containers/food/snacks/ingredient/meat = 1, /obj/item/reagent_containers/food/snacks/ingredient/sludge = 1) // place /foo/bar before /foo

	result = /obj/item/reagent_containers/food/snacks/meatpie // example: = /obj/item/reagent_containers/food/snacks/donut/normal
