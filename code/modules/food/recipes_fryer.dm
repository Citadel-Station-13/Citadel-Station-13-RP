/datum/cooking_recipe/fries
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/rawsticks = 100
	)
	result = /obj/item/reagent_containers/food/snacks/fries

/datum/cooking_recipe/dishofries
	required_method = METHOD_DEEPFRY
	fruit = list("disho" = 100)
	reagents = list("batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/dishofries

/datum/cooking_recipe/jpoppers
	required_method = METHOD_DEEPFRY
	fruit = list("chili" = 100)
	reagents = list("batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/jalapeno_poppers

/datum/cooking_recipe/risottoballs
	required_method = METHOD_DEEPFRY
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "batter" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/risotto)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/risottoballs


//Meaty Recipes
//====================
/datum/cooking_recipe/cubancarp
	required_method = METHOD_DEEPFRY
	fruit = list("chili" = 50)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/datum/cooking_recipe/batteredsausage
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/sausage = 100
	)
	result = /obj/item/reagent_containers/food/snacks/sausage/battered
	reagents = list("batter" = 5)


/datum/cooking_recipe/katsu
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken = 100
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	reagents = list("beerbatter" = 5)


/datum/cooking_recipe/pizzacrunch_1
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	reagents = list("batter" = 5)

//Alternate pizza crunch recipe for combination pizzas made in oven
/datum/cooking_recipe/pizzacrunch_2
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/variable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	reagents = list("batter" = 5)

/datum/cooking_recipe/friedmushroom
	required_method = METHOD_DEEPFRY
	fruit = list("plumphelmet" = 100)
	reagents = list("beerbatter" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

/datum/cooking_recipe/shrimptempura
	required_method = METHOD_DEEPFRY
	reagents = list("sodiumchloride" = 2, "batter" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/shrimptempura

//Sweet Recipes.
//==================
/datum/cooking_recipe/jellydonut
	required_method = METHOD_DEEPFRY
	reagents = list("berryjuice" = 10, "sugar" = 10, "batter" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 20
	)
	result = /obj/item/reagent_containers/food/snacks/donut/jelly
	result_quantity = 2

/datum/cooking_recipe/jellydonut/slime
	required_method = METHOD_DEEPFRY
	reagents = list("slimejelly" = 10, "sugar" = 10, "batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/donut/slimejelly

/datum/cooking_recipe/jellydonut/cherry
	required_method = METHOD_DEEPFRY
	reagents = list("cherryjelly" = 10, "sugar" = 10, "batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/donut/cherryjelly

/datum/cooking_recipe/donut
	required_method = METHOD_DEEPFRY
	reagents = list("sugar" = 10, "batter" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 20
	)
	result = /obj/item/reagent_containers/food/snacks/donut/normal
	result_quantity = 2

/datum/cooking_recipe/chaosdonut
	required_method = METHOD_DEEPFRY
	reagents = list("frostoil" = 10, "capsaicin" = 10, "sugar" = 10, "batter" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //This creates its own reagents
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 40
	)
	result = /obj/item/reagent_containers/food/snacks/donut/chaos
	result_quantity = 2

/datum/cooking_recipe/funnelcake
	required_method = METHOD_DEEPFRY
	reagents = list("sugar" = 5, "batter" = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake

/datum/cooking_recipe/pisanggoreng
	required_method = METHOD_DEEPFRY
	fruit = list("banana" = 200)
	reagents = list("batter" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng


/datum/cooking_recipe/corn_dog
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/sausage = 100
	)
	fruit = list("corn" = 100)
	reagents = list("batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/datum/cooking_recipe/sweet_and_sour
	required_method = METHOD_DEEPFRY
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 100
	)
	reagents = list("soysauce" = 5, "batter" = 10)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour

/datum/cooking_recipe/generalschicken
	required_method = METHOD_DEEPFRY
	reagents = list("capsaicin" = 2, "sugar" = 2, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 200
	)
	result = /obj/item/reagent_containers/food/snacks/generalschicken

/datum/cooking_recipe/chickenwings
	required_method = METHOD_DEEPFRY
	reagents = list("capsaicin" = 5, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 400
	)
	result = /obj/item/storage/box/wings //This is kinda like the donut box.

/datum/cooking_recipe/schnitzel
	required_method = METHOD_DEEPFRY
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "batter" = 10)
	fruit = list("onion" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 200
	)
	result = /obj/item/reagent_containers/food/snacks/schnitzel

/datum/cooking_recipe/churro
	required_method = METHOD_DEEPFRY
	reagents = list("sugar" = 5, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100
	)
	result = /obj/item/reagent_containers/food/snacks/churro

/datum/cooking_recipe/nugget
	required_method = METHOD_DEEPFRY
	reagents = list("flour" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken = 10
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget

/datum/cooking_recipe/onionrings
	required_method = METHOD_DEEPFRY
	fruit = list("onion" = 100)
	reagents = list("batter" = 5)
	result = /obj/item/reagent_containers/food/snacks/onionrings

//Goblin Food Goblin Food
/datum/cooking_recipe/cavenuggets
	required_method = METHOD_DEEPFRY
	fruit = list("mushroom" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat = 100,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/cavenuggets
