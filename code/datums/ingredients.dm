/**
 * holds needed *item* ingredients, including sheets
 *
 * this does not support 1/nth of a sheet, due to this being optimized for
 * getting number of paths available!
 *
 * material sheets *must* be material ids!
 */
/datum/ingredients

/datum/ingredients/proc/ui_ingredients_needed()

/proc/ui_ingredients_available(list/obj/item/items)
	var/list/built = list()

