/datum/cooking_recipe/ovenchips
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/rawsticks = 100
	)
	result = /obj/item/reagent_containers/food/snacks/ovenchips

/datum/cooking_recipe/ribplate
	required_method = METHOD_OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat = 200)

	result = /obj/item/reagent_containers/food/snacks/ribplate

/datum/cooking_recipe/ribplate_bear
	required_method = METHOD_OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/bearmeat = 200)

	result = /obj/item/reagent_containers/food/snacks/ribplate_bear

/datum/cooking_recipe/teshariroast
	required_method = METHOD_OVEN
	fruit = list("lemon" = 20)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken/teshari = 100)
	result = /obj/item/reagent_containers/food/snacks/teshariroast


/datum/cooking_recipe/baguette
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 200
	)
	result = /obj/item/reagent_containers/food/snacks/baguette

//Predesigned pies
//=======================

/datum/cooking_recipe/meatpie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/datum/cooking_recipe/tofupie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu = 100
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/datum/cooking_recipe/xemeatpie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/cooking_recipe/pie
	required_method = METHOD_OVEN
	fruit = list("banana" = 100)
	reagents = list("sugar" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/cooking_recipe/cherrypie
	required_method = METHOD_OVEN
	fruit = list("cherries" = 100)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie


/datum/cooking_recipe/amanita_pie
	required_method = METHOD_OVEN
	reagents = list("amatoxin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/cooking_recipe/plump_pie
	required_method = METHOD_OVEN
	fruit = list("plumphelmet" = 100)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100)
	result = /obj/item/reagent_containers/food/snacks/plump_pie


/datum/cooking_recipe/pumpkinpie
	required_method = METHOD_OVEN
	fruit = list("pumpkin" = 100)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	 //We dont want raw egg in the result

/datum/cooking_recipe/appletart
	required_method = METHOD_OVEN
	fruit = list("goldapple" = 100)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10, "egg" = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart


/datum/cooking_recipe/keylimepie
	required_method = METHOD_OVEN
	fruit = list("lime" = 200)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	 //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/cooking_recipe/quiche
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "egg" = 9, "flour" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	 //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/cooking_recipe/cookie
	required_method = METHOD_OVEN
	reagents = list("milk" = 10, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4


/datum/cooking_recipe/fortunecookie
	required_method = METHOD_OVEN
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 20,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie
	/* make_food(var/obj/container as obj) -- Commented out because it breaks the recipe, causing fortune cookies to be made with *just* 5 sugar, which conflicted with other recipes

		var/obj/item/paper/paper

		//Fuck fortune cookies. This is a quick hack
		//Duplicate the item searching code with a special case for paper
		for (var/i in items)
			var/obj/item/I = locate(i) in container
			if (!paper  && istype(I, /obj/item/paper))
				paper = I
				continue

			if (I)
				qdel(I)

		//Then store and null out the items list so it wont delete any paper
		var/list/L = items.Copy()
		items = null
		. = ..(container)

		//Restore items list, so that making fortune cookies once doesnt break the oven
		items = L


		for (var/obj/item/reagent_containers/food/snacks/fortunecookie/being_cooked in .)
			paper.forceMove(being_cooked)
			being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
			return


	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			var/obj/item/paper/paper = locate() in container
			if (!paper || !istype(paper))
				return 0
			if (!paper.info)
				return 0
		return . */

/datum/cooking_recipe/pretzel
	required_method = METHOD_OVEN
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100)
	reagents = list("water" = 5, "sodiumchloride" = 2)
	result = /obj/item/reagent_containers/food/snacks/pretzel
	result_quantity = 2

/datum/cooking_recipe/poppypretzel
	required_method = METHOD_OVEN
	fruit = list("poppy" = 20)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/datum/cooking_recipe/cracker
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 100
	)
	result = /obj/item/reagent_containers/food/snacks/cracker

/datum/cooking_recipe/brownies
	required_method = METHOD_OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	 //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies


/datum/cooking_recipe/cosmicbrownies
	required_method = METHOD_OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	fruit = list("ambrosia" = 10)
	 //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies


/datum/cooking_recipe/muffin
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

//Pizzas
//=========================
/datum/cooking_recipe/pizzamargherita
	required_method = METHOD_OVEN
	fruit = list("tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 200
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/cooking_recipe/meatpizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/cooking_recipe/syntipizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/cooking_recipe/mushroompizza
	required_method = METHOD_OVEN
	fruit = list("mushroom" = 50, "tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)

	 //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/cooking_recipe/vegetablepizza
	required_method = METHOD_OVEN
	fruit = list("eggplant" = 25, "carrot" = 25, "corn" = 25, "tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/cooking_recipe/pineapplepizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100,
		/obj/item/reagent_containers/food/snacks/pineapple_ring = 2
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

//Spicy
//================
/datum/cooking_recipe/enchiladas
	required_method = METHOD_OVEN
	fruit = list("chili" = 10, "corn" = 100)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 100)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/cooking_recipe/monkeysdelight
	required_method = METHOD_OVEN
	fruit = list("banana" = 100)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight






// Cakes.
//============
/datum/cooking_recipe/cake
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/plaincake


/datum/cooking_recipe/cake/carrot
	required_method = METHOD_OVEN
	fruit = list("carrot" = 300)
	result = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/datum/cooking_recipe/cake/cheese
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 200,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/datum/cooking_recipe/cake/orange
	required_method = METHOD_OVEN
	fruit = list("orange" = 100)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "orangejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/datum/cooking_recipe/cake/lime
	required_method = METHOD_OVEN
	fruit = list("lime" = 100)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/datum/cooking_recipe/cake/lemon
	required_method = METHOD_OVEN
	fruit = list("lemon" = 100)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/datum/cooking_recipe/cake/chocolate
	required_method = METHOD_OVEN
	items = list(/obj/item/reagent_containers/food/snacks/chocolatebar)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/datum/cooking_recipe/cake/birthday
	required_method = METHOD_OVEN
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/datum/cooking_recipe/cake/apple
	required_method = METHOD_OVEN
	fruit = list("apple" = 100)
	result = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/datum/cooking_recipe/cake/brain
	required_method = METHOD_OVEN
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/datum/cooking_recipe/honeycake
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "flour" = 10, "egg" = 6, "honey" = 5)
	result = /obj/item/reagent_containers/food/snacks/honeycake

/datum/cooking_recipe/berryclafoutis
	fruit = list("berries" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/datum/cooking_recipe/lasagna
	required_method = METHOD_OVEN
	fruit = list("tomato" = 200)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 200
	)
	result = /obj/item/reagent_containers/food/snacks/lasagna

/datum/cooking_recipe/honeybun
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100
	)
	reagents = list("honey" = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/datum/cooking_recipe/enchiladas_new
	required_method = METHOD_OVEN
	fruit = list("chili" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla = 100
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/cooking_recipe/meat_pocket
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 4

/datum/cooking_recipe/bacon_flatbread
	required_method = METHOD_OVEN
	fruit = list("tomato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 200
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/cooking_recipe/truffle
	required_method = METHOD_OVEN
	reagents = list("sugar" = 5, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)

	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

/datum/cooking_recipe/eggplantparm
	required_method = METHOD_OVEN
	fruit = list("eggplant" = 400)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 200
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/cooking_recipe/croissant
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1, "water" = 5, "milk" = 5)

	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 100)
	result = /obj/item/reagent_containers/food/snacks/croissant

/* todo: fix
/datum/cooking_recipe/macncheese
	required_method = METHOD_OVEN
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/macncheese
*/

/datum/cooking_recipe/ham
	required_method = METHOD_OVEN
	reagents = list("brine" = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 300,
	)
	result = /obj/item/reagent_containers/food/snacks/ingredient/ham

/datum/cooking_recipe/rumham
	required_method = METHOD_OVEN
	reagents = list("rum" = 10)
	fruit = list("cherries" = 20, "spineapple" = 20)

	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/ham = 300
	)
	result = /obj/item/reagent_containers/food/snacks/rumham

/datum/cooking_recipe/loadedbakedpotato
	required_method = METHOD_OVEN
	fruit = list("potato" = 100)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 20)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato


/datum/cooking_recipe/fishfingers
	required_method = METHOD_OVEN
	reagents = list("flour" = 10,"egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE


/datum/cooking_recipe/tofurkey
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu = 800,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/cooking_recipe/chilicheesefries
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100,
		/obj/item/reagent_containers/food/snacks/hotchili //lol.
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chilicheesefries

/datum/cooking_recipe/meatbun
	reagents = list("sodiumchloride" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 50
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/datum/cooking_recipe/custardbun
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 100
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/datum/cooking_recipe/chips
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/datum/cooking_recipe/nachos
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 100
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

/datum/cooking_recipe/roastbeef
	fruit = list("carrot" = 100, "potato" = 100)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/roastbeef

/datum/cooking_recipe/pillbugball
	reagents = list(MAT_CARBON = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/bugball

/datum/cooking_recipe/mammi
	fruit = list("orange" = 20)
	reagents = list("water" = 10, "flour" = 10, "milk" = 5, "sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/mammi

/datum/cooking_recipe/makaroni
	reagents = list("flour" = 15, "milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 200
	)
	result = /obj/item/reagent_containers/food/snacks/makaroni

/datum/cooking_recipe/greenham
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat = 100,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/cooking_recipe/greenhamandeggs
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 200,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat = 100,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/cooking_recipe/puddi
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 300,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi

/datum/cooking_recipe/puddi_happy
	reagents = list("milk" = 10, "sugar" = 5, "honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 300,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/happy

/datum/cooking_recipe/puddi_angry
	fruit = list("chili" = 200)
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 300,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/angry


/datum/cooking_recipe/applepie
	fruit = list("apple" = 100)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat = 100)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/cooking_recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 20)
	reagents = list("water" = 5, "flour" = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
