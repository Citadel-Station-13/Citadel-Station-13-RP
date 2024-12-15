/datum/prototype/guidebook_section/recipes
	title = "Cooking Recipes"
	id = "recipes"
	tgui_module = "TGUIGuidebookCookingRecipes"

/datum/prototype/guidebook_section/recipes/section_data()
	. = ..()
	var/list/recipes = list()
	for(var/datum/cooking_recipe/R in GLOB.cooking_recipes)
		recipes += R.tgui_guidebook_data()
	.["recipes"] = recipes
