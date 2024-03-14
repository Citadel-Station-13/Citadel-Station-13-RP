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
	reagents = list("water" = 60)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/plant
	)
	result = null
	result_reagents = list("vegstock" = 60)
