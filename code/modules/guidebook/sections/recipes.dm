/datum/prototype/guidebook_section/recipes
	title = "Cooking Recipes"
	id = "recipes"
	tgui_module = "TGUIGuidebookCookingRecipes"

/datum/prototype/guidebook_section/recipes/section_data()
	. = ..()
	.["recipes"] = GLOB.cooking_recipes_tgui_guidebook_data
