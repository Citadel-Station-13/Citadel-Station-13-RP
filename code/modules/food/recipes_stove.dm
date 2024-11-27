/datum/cooking_recipe/stuffing
	required_method = METHOD_STOVE
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bread = 100
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing

/* potential recipes to obliterate
custom foods handle soups pretty well, so
/datum/cooking_recipe/meatballsoup
	fruit = list("carrot" = 100, "potato" = 100)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meatball)
	result = /obj/item/reagent_containers/food/snacks/meatballsoup

/datum/cooking_recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/vegetablesoup

/datum/cooking_recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list("water" = 10, "egg" = 3)
	result = /obj/item/reagent_containers/food/snacks/nettlesoup

/datum/cooking_recipe/wishsoup
	reagents = list("water" = 20)
	result= /obj/item/reagent_containers/food/snacks/wishsoup

/datum/cooking_recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/datum/cooking_recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

/datum/cooking_recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/tomatosoup

/datum/cooking_recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/datum/cooking_recipe/dishostew
	fruit = list("disho" = 3, "mushroom" = 2, "chili" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/dishostew

/datum/cooking_recipe/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope, //what the fuck is a soy dope
		/obj/item/reagent_containers/food/snacks/ingredient/tofu, //it's soy, man. and that's pretty dope.
		/obj/item/reagent_containers/food/snacks/ingredient/tofu //(it's refined soy protein isolate that's blended into a viscous, proteinaceous slurry)
	)
	result = /obj/item/reagent_containers/food/snacks/milosoup


/datum/cooking_recipe/bloodsoup
	reagents = list("blood" = 30)
	result = /obj/item/reagent_containers/food/snacks/bloodsoup

/datum/cooking_recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/slimesoup



/datum/cooking_recipe/mysterysoup
	reagents = list("water" = 10, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mysterysoup

/datum/cooking_recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mushroomsoup

/datum/cooking_recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/beetsoup

/datum/cooking_recipe/dishosoup
	fruit = list("disho" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/dishosoup

/datum/cooking_recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/tossedsalad

/datum/cooking_recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)
	result = /obj/item/reagent_containers/food/snacks/aesirsalad

/datum/cooking_recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meatball)
	result = /obj/item/reagent_containers/food/snacks/validsalad

/datum/cooking_recipe/validsalad/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent("toxin")

/datum/cooking_recipe/bearchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/datum/cooking_recipe/bearstew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearstew
	*/

/datum/cooking_recipe/boiledspaghetti
	required_method = METHOD_STOVE
	reagents = list("water" = 30)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 100
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspaghetti //ingredient this??

/datum/cooking_recipe/veggiestock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 5)
	fruit = list("carrot" = 100, "onion" = 100)
	result = null
	result_reagents = list("vegbroth" = 60)

/datum/cooking_recipe/chickenstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken = 100
	)
	result = null
	result_reagents = list("chickenbroth" = 60)

/datum/cooking_recipe/meatstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 100
	)
	result = null
	result_reagents = list("meatbroth" = 60)

/datum/cooking_recipe/fishstock
	required_method = METHOD_STOVE
	reagents = list("water" = 60, "sodiumchloride" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = null
	result_reagents = list("fishbroth" = 60)


//temporary recipes until we get reagent temperature
//so you can crack an egg in a skillet and then fry it
/datum/cooking_recipe/friedegg
	required_method = METHOD_STOVE
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/datum/cooking_recipe/boiledegg
	required_method = METHOD_STOVE
	reagents = list("water" = 15)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/datum/cooking_recipe/pancakes
	required_method = METHOD_STOVE
	fruit = list("berries" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes


/datum/cooking_recipe/waffles
	reagents = list("sugar" = 10)
	required_method = METHOD_STOVE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 200
	)
	result = /obj/item/reagent_containers/food/snacks/waffles

/datum/cooking_recipe/omelette
	required_method = METHOD_STOVE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100,
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/datum/cooking_recipe/popcorn
	required_method = METHOD_STOVE
	fruit = list("corn" = 100)
	reagents = list("cooking_oil" = 5)
	result = /obj/item/reagent_containers/food/snacks/popcorn

/datum/cooking_recipe/meatsteak
	required_method = METHOD_STOVE
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat = 100)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/cooking_recipe/syntisteak
	required_method = METHOD_STOVE
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh = 100)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/cooking_recipe/stewedsoymeat
	required_method = METHOD_STOVE
	reagents = list("vegbroth" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope = 200
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/datum/cooking_recipe/pastatomato
	fruit = list("tomato" = 40)
	reagents = list("water" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 100)
	result = /obj/item/reagent_containers/food/snacks/pastatomato

/datum/cooking_recipe/meatballspaghetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti,
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 2
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspaghetti

/datum/cooking_recipe/spesslaw
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti,
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 4
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw

/datum/cooking_recipe/mashedpotato
	required_method = METHOD_STOVE
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter = 10 // to prevent conflicts with yellow curry
	)
	fruit = list("potato" = 100)
	result = /obj/item/reagent_containers/food/snacks/mashedpotato
