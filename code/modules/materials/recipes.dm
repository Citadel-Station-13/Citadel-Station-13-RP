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

/datum/material/plastic/generate_recipes()
	..()


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

	recipes += new/datum/stack_recipe_list("wooden fencing", list( \
		new/datum/stack_recipe("fence", /obj/structure/fence/wooden, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fence end", /obj/structure/fence/wooden/end, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fencepost", /obj/structure/fence/wooden/post, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fence corner", /obj/structure/fence/wooden/corner, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("gate", /obj/structure/fence/door/wooden, 5, one_per_turf = 1, on_floor = 1), \
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


/datum/material/cardboard/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("folders",list( \
		new/datum/stack_recipe("blue folder", /obj/item/folder/blue), \
		new/datum/stack_recipe("grey folder", /obj/item/folder), \
		new/datum/stack_recipe("red folder", /obj/item/folder/red), \
		new/datum/stack_recipe("white folder", /obj/item/folder/white), \
		new/datum/stack_recipe("yellow folder", /obj/item/folder/yellow), \
		))

/datum/material/cloth/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("bedsheet", /obj/item/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe_list("colored bedsheets", list( \
		new/datum/stack_recipe("red bedsheet", /obj/item/bedsheet/red, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("orange bedsheet", /obj/item/bedsheet/orange, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("yellow bedsheet", /obj/item/bedsheet/yellow, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("green bedsheet", /obj/item/bedsheet/green, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("blue bedsheet", /obj/item/bedsheet/blue, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("purple bedsheet", /obj/item/bedsheet/purple, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("brown bedsheet", /obj/item/bedsheet/brown, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("rainbow bedsheet", /obj/item/bedsheet/rainbow, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		))
	recipes += new/datum/stack_recipe("double bedsheet", /obj/item/bedsheet/double, 10, time = 30 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe_list("colored double bedsheets", list( \
		new/datum/stack_recipe("red double bedsheet", /obj/item/bedsheet/reddouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("orange doudble bedsheet", /obj/item/bedsheet/orangedouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("yellow double bedsheet", /obj/item/bedsheet/yellowdouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("green double bedsheet", /obj/item/bedsheet/greendouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("blue double bedsheet", /obj/item/bedsheet/bluedouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("purple double bedsheet", /obj/item/bedsheet/purpledouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("brown double bedsheet", /obj/item/bedsheet/browndouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("rainbow double bedsheet", /obj/item/bedsheet/rainbowdouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		))
