// default behaviour to be overridden
/obj/machinery/recipe_lookup
	var/list/recipe_list
	var/result_type_name

/obj/machinery/recipe_lookup/proc/display_recipe_instructions(var/result_name, var/recipe)
	return

/obj/machinery/recipe_lookup/proc/display_options()
	return tgui_input_list(usr, "Pick a [result_type_name] to view its recipe.", "Select [result_type_name]", recipe_list)

/obj/machinery/recipe_lookup/attack_hand(mob/user)
	// regular use checks
	if (!isliving(user))
		return FALSE
	if (!user.IsAdvancedToolUser())
		to_chat(user, "You lack the dexterity to do that!")
		return FALSE
	if (user.stat || user.restrained() || user.incapacitated())
		return FALSE
	if (!Adjacent(user) && !issilicon(user))
		to_chat(user, "You can't reach [src] from here.")
		return FALSE

	var/result_name = display_options()
	if(!result_name)
		return
	var/recipe = recipe_list[result_name]
	display_recipe_instructions(result_name, recipe)

// bartending version
/obj/machinery/recipe_lookup/drinks
	recipe_list = GLOB.drink_recipes
	result_type_name = "drink"

/obj/machinery/recipe_lookup/drinks/display_recipe_instructions(var/result_name, var/datum/chemical_reaction/recipe)
	return

// cook version TBD due to food rework
