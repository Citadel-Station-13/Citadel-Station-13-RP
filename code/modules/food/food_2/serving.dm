

/obj/item/food_serving
	name = "bowl"
	desc = "A bowl, for serving food."
	icon = 'icons/obj/food_ingredients/custom_food.dmi'
	icon_state = "bowl"
	var/serving_type = "bowl"
	var/trash_type

	var/dirty = FALSE //are we dirty


/obj/item/food_serving/woodbowl
	name = "wooden bowl"
	desc = "A rustic wooden bowl, for serving food."
	icon_state = "woodbowl"
	serving_type = "woodbowl"

/obj/item/food_serving/plate
	name = "plate"
	desc = "A plate, for serving food."
	icon_state = "plate"
	serving_type = "plate"


/obj/item/reagent_containers/food/snacks/food_serving
	name = "generic serving of food"
	desc = "How did I get here?"
	icon = 'icons/obj/food_ingredients/custom_food.dmi'
	icon_state = "handful"
	/*
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/dried_type = null
	var/survivalfood = FALSE
	var/nutriment_amt = 0
	var/list/nutriment_desc = list("food" = 1)
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1 //If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name
	*/
