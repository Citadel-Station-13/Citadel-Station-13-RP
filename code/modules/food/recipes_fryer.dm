/datum/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries

/datum/recipe/dishofries
	appliance = FRYER
	fruit = list("disho" = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/dishofries

/datum/recipe/jpoppers
	appliance = FRYER
	fruit = list("chili" = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/jalapeno_poppers

/datum/recipe/risottoballs
	appliance = FRYER
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/risotto)
	coating = /datum/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/risottoballs


//Meaty Recipes
//====================
/datum/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/datum/recipe/batteredsausage
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/sausage/battered
	coating = /datum/reagent/nutriment/coating/batter


/datum/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	coating = /datum/reagent/nutriment/coating/beerbatter


/datum/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/datum/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/variable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter

/datum/recipe/friedmushroom
	appliance = FRYER
	fruit = list("plumphelmet" = 1)
	coating = /datum/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

/datum/recipe/shrimptempura
	appliance = FRYER
	reagents = list("sodiumchloride" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/shrimp
	)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/shrimptempura

//Sweet Recipes.
//==================
/datum/recipe/jellydonut
	appliance = FRYER
	reagents = list("berryjuice" = 10, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/jelly
	result_quantity = 2

/datum/recipe/jellydonut/slime
	appliance = FRYER
	reagents = list("slimejelly" = 10, "sugar" = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/slimejelly

/datum/recipe/jellydonut/cherry
	appliance = FRYER
	reagents = list("cherryjelly" = 10, "sugar" = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/cherryjelly

/datum/recipe/donut
	appliance = FRYER
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/normal
	result_quantity = 2

/datum/recipe/chaosdonut
	appliance = FRYER
	reagents = list("frostoil" = 10, "capsaicin" = 10, "sugar" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //This creates its own reagents
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/chaos
	result_quantity = 2

/datum/recipe/funnelcake
	appliance = FRYER
	reagents = list("sugar" = 5, "batter" = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake

/datum/recipe/pisanggoreng
	appliance = FRYER
	fruit = list("banana" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng
	coating = /datum/reagent/nutriment/coating/batter

/datum/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	fruit = list("corn" = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/datum/recipe/sweet_and_sour
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagents = list("soysauce" = 5, "batter" = 10)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour

/datum/recipe/generalschicken
	appliance = FRYER
	reagents = list("capsaicin" = 2, "sugar" = 2, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/generalschicken

/datum/recipe/chickenwings
	appliance = FRYER
	reagents = list("capsaicin" = 5, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/storage/box/wings //This is kinda like the donut box.

/datum/recipe/schnitzel
	appliance = FRYER
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "batter" = 10)
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/schnitzel

/datum/recipe/churro
	appliance = FRYER
	reagents = list("sugar" = 5, "batter" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/churro
