/datum/recipe/stuffing
	required_method = METHOD_STOVE
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing


#warn todo improve spaghetti?
/datum/recipe/boiledspaghetti
	required_method = METHOD_STOVE
	reagents = list("water" = 30)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspaghetti //ingredient this??

/datum/recipe/veggiestock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 5)
	fruit = list("carrot" = 1, "onion" = 1)
	result = null
	result_reagents = list("vegbroth" = 60)

/datum/recipe/chickenstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken
	)
	result = null
	result_reagents = list("chickenbroth" = 60)

/datum/recipe/meatstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat
	)
	result = null
	result_reagents = list("meatbroth" = 60)

/datum/recipe/fishstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = null
	result_reagents = list("fishbroth" = 60)


//temporary recipes until we get reagent temperature
//so you can crack an egg in a skillet and then fry it
/datum/recipe/friedegg
	required_method = METHOD_STOVE
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/datum/recipe/boiledegg
	required_method = METHOD_STOVE
	reagents = list("water" = 15)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg


