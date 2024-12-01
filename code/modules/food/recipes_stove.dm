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

/datum/cooking_recipe/onionsoup
	fruit = list("onion" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion
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



/////////////////////////////////////////////////////////////
//Synnono Meme Foods
//
//Most recipes replace reagents with RECIPE_REAGENT_REPLACE
//to simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.
/////////////////////////////////////////////////////////////


/datum/cooking_recipe/redcurry
	required_method = METHOD_STOVE
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 200
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/datum/cooking_recipe/greencurry
	required_method = METHOD_STOVE
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("chili" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu = 200
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/datum/cooking_recipe/yellowcurry
	required_method = METHOD_STOVE
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("peanut" = 20, "potato" = 300)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry





/datum/cooking_recipe/bibimbap
	required_method = METHOD_STOVE
	fruit = list("carrot" = 100, "cabbage" = 100, "mushroom" = 100)
	reagents = list("rice" = 5, "spacespice" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 100
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/cooking_recipe/friedrice
	required_method = METHOD_STOVE
	reagents = list("water" = 5, "rice" = 10, "soysauce" = 5)
	fruit = list("carrot" = 100, "cabbage" = 100)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/datum/cooking_recipe/lomein
	required_method = METHOD_STOVE
	reagents = list("water" = 5, "soysauce" = 5)
	fruit = list("carrot" = 100, "cabbage" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 100
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein

/datum/cooking_recipe/chickenmomo
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 300,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken = 100
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/cooking_recipe/veggiemomo
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 100, "cabbage" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 300
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo

/datum/cooking_recipe/risotto
	reagents = list("wine" = 5, "rice" = 10, "spacespice" = 1)
	fruit = list("mushroom" = 100)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/risotto

/datum/cooking_recipe/poachedegg
	reagents = list("spacespice" = 1, "sodiumchloride" = 1, "blackpepper" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/datum/cooking_recipe/donerkebab
	fruit = list("tomato" = 100, "cabbage" = 100)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab

/datum/cooking_recipe/honeytoast
	reagents = list("honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast

/datum/cooking_recipe/cheesesauce
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/cooking_recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/cooking_recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/cooking_recipe/chilied_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/hotchili,
		/obj/item/reagent_containers/food/snacks/boiledegg = 3
	)
	result = /obj/item/reagent_containers/food/snacks/chilied_eggs

/datum/cooking_recipe/red_sun_special
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/sausage,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge

	)
	result = /obj/item/reagent_containers/food/snacks/red_sun_special

/datum/cooking_recipe/hatchling_suprise
	items = list(
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 3

	)
	result = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/datum/cooking_recipe/riztizkzi_sea
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 3
	)
	reagents = list("blood" = 15)
	result = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/datum/cooking_recipe/father_breakfast
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/sausage,
		/obj/item/reagent_containers/food/snacks/omelette,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/reagent_containers/food/snacks/father_breakfast

/datum/cooking_recipe/stuffed_meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/stuffed_meatball

/datum/cooking_recipe/egg_pancake
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 3,
		/obj/item/reagent_containers/food/snacks/omelette
	)
	result = /obj/item/reagent_containers/food/snacks/egg_pancake

/datum/cooking_recipe/grilled_carp
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 6
	)
	reagents = list("spacespice" = 1)
	fruit = list("cabbage" = 1, "lime" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/cooking_recipe/bacon_stick
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_stick

/datum/cooking_recipe/porkbowl
	reagents = list("water" = 5, "rice" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

/datum/cooking_recipe/goulash
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet,
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	)
	result = /obj/item/reagent_containers/food/snacks/goulash

/datum/cooking_recipe/hotandsoursoup
	fruit = list("cabbage" = 1, "mushroom" = 1)
	reagents = list("sodiumchloride" = 2, "blackpepper" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/hotandsoursoup

/datum/cooking_recipe/kitsuneudon
	reagents = list("egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/kitsuneudon

/datum/cooking_recipe/diggerstew
	fruit = list("carrot" = 1, "mushroom" = 1)
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/diggerstew

/datum/cooking_recipe/diggerstew_pot
	fruit = list("carrot" = 1, "potato" = 1, "mushroom" = 1)
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/diggerstew_pot

/datum/cooking_recipe/full_goss
	fruit = list("carrot" = 1, "mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat
	)
	result = /obj/item/reagent_containers/food/snacks/full_goss

/datum/cooking_recipe/chickensatay
	fruit = list("peanut" = 1, "lime" = 1)
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken,
		/obj/item/reagent_containers/food/snacks/yellowcurry
	)
	reagents = list("water" = 5, "milk" = 5, "soysauce" = 5, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/chickensatay

/datum/cooking_recipe/spider_wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat/spidermeat
	)
	result = /obj/item/reagent_containers/food/snacks/spider_wingfangchu


/datum/cooking_recipe/mushroompasta
	fruit = list("mushroom" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/spaghetti)
	reagents = list("water" = 5)
	result = /obj/item/reagent_containers/food/snacks/mushroompasta

/datum/cooking_recipe/carbonara
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge,
		/obj/item/reagent_containers/food/snacks/ingredient/egg,
		/obj/item/reagent_containers/food/snacks/ingredient/meat
	)
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	result = /obj/item/reagent_containers/food/snacks/carbonara

/datum/cooking_recipe/bloodsausage
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/sausage
	)
	reagents = list("blood" = 15)
	result = /obj/item/reagent_containers/food/snacks/bloodsausage

/datum/cooking_recipe/weisswurst
	fruit = list("onion" = 1, "lemon" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/sausage)
	reagents = list("water" = 15, "sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/weisswurst

/datum/cooking_recipe/shrimpfriedrice
	fruit = list("corn" = 1, "carrot" = 1, "peas" = 1)
	reagents = list("water" = 5, "sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpfriedrice

/datum/cooking_recipe/bowl_peas
	fruit = list("peas" = 4)
	reagents = list("water" = 5, "sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/bowl_peas

/datum/cooking_recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/cooking_recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/cooking_recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list("water" = 5, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/cooking_recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/ingredient/sausage
	result_quantity = 2

/datum/cooking_recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5, "egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/datum/cooking_recipe/frenchonionsoup
	fruit = list("onion" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge)
	reagents = list("water" = 10, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/frenchonionsoup
