/**
 * get recipe list
 */
/datum/material/proc/get_recipes()
	return isnull(recipes)? generate_recipes() : recipes

/**
 * regenerate recipes list and return it
 */
/datum/material/proc/generate_recipes()
	recipes = list()
	recipes += special_recipes()
	return recipes

/**
 * allows for better override support, for when you want specific subtypes to have specific recipes
 *
 * returns a recipe list that's added to generate_recipes()
 */
/datum/material/proc/special_recipes()
	return list()

/datum/material/wood_plank/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/ridden/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/ridden/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)

	// Pew pew pew
	recipes += new/datum/stack_recipe_list("pews", list( \
		new/datum/stack_recipe("pew middle", /obj/structure/bed/chair/pew, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew left", /obj/structure/bed/chair/pew/left, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew right", /obj/structure/bed/chair/pew/right, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		))

/datum/material/wood_plank/hardwood/generate_recipes()
	//we're not going to ..() since we want to override the list entirely, to cut out all the stuff it'd inherit from wood - important, or else we'd have to fuss around with more subtypes to stop people turning hardwood into regular wood
	recipes = list()
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/ridden/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/ridden/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)

	// Pew pew pew
	recipes += new/datum/stack_recipe_list("pews", list( \
		new/datum/stack_recipe("pew middle", /obj/structure/bed/chair/pew, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew left", /obj/structure/bed/chair/pew/left, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew right", /obj/structure/bed/chair/pew/right, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		))

