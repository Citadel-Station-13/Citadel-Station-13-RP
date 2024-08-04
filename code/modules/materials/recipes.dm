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
