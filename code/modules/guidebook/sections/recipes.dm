/datum/prototype/guidebook_section/recipes
	title = "Cooking Recipes"
	id = "recipes"
	tgui_module = "TGUIGuidebookCookingRecipes"

/datum/prototype/guidebook_section/recipes/section_data()
	. = ..()
	init_cooking_recipes_glob()
	.["recipes"] = GLOB.cooking_recipes_tgui_guidebook_data
