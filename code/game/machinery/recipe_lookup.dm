// default behaviour to be overridden
/obj/machinery/recipe_lookup
	var/list/recipe_list
	var/result_type_name

/obj/machinery/recipe_lookup/proc/display_recipe_instructions(var/recipe)
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
	display_recipe_instructions(recipe)

/obj/item/frame/recipe_lookup
	icon = 'icons/obj/stationobjs.dmi'
	refund_amt = 1

// bartending version
/obj/machinery/recipe_lookup/drinks
	result_type_name = "drink"
	icon_state = "barpad_dark"
	desc = "A display used for displaying information on drink recipes. \n <center>It can be Alt-Clicked to toggle the theme.</center>"

/obj/machinery/recipe_lookup/drinks/Initialize()
	. = ..()
	recipe_list = GLOB.drink_recipes

/obj/machinery/recipe_lookup/drinks/display_recipe_instructions(var/datum/chemical_reaction/recipe)
	var/instructions = "Reagents required:\n"
	for(var/item in recipe.required_reagents)
		instructions += "[recipe.required_reagents[item]] parts <b>[item]</b>\n"
	instructions += "\n"
	var/catalyst_count = length(recipe.catalysts)
	if(catalyst_count == 1)
		var/catalyst = recipe.catalysts[1]
		instructions += "Catalyst: [recipe.catalysts[catalyst]] units of <b>[catalyst]</b>\n"
	else
		instructions += "Catalysts;"
		for(var/item in recipe.catalysts)
			instructions += "[recipe.catalysts[item]] units of <b>[item]</b>"
	instructions += "\n"
	instructions += "Result: [recipe.result_amount] parts <b>[recipe.result]</b>"
	to_chat(usr, instructions)

/obj/machinery/recipe_lookup/drinks/AltClick(mob/living/carbon/user)
	if(icon_state == "barpad_dark")
		icon_state = "barpad_light"
		to_chat(user, "You set the display to light theme.")
	else
		icon_state = "barpad_dark"
		to_chat(user, "You set the display to dark theme.")

/obj/item/frame/recipe_lookup/drinks
	icon_state = "barpad_dark"
	build_machine_type = /obj/machinery/recipe_lookup/drinks

// cook version TBD due to food rework
