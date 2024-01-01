/datum/cooking_recipe

	var/list/recipe_reagents // example: = list("berryjuice" = 5) // do not list same reagent twice
	var/list/recipe_items    // example: = list(/obj/item/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/recipe_fruit    // example: = list("fruit" = 3)

	var/result // example: = /obj/item/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.

	var/required_method = METHOD_OVEN //Which method is required for this recipe
