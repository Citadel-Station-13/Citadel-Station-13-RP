/datum/recipe/test_cooking
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient = 1
	)
	result = /obj/item/reagent_containers/food/snacks/ribplate

/datum/recipe/ovenchips
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/ovenchips

/datum/recipe/ribplate //Putting this here for not seeing a roast section.
	required_method = METHOD_OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	
	result = /obj/item/reagent_containers/food/snacks/ribplate

/datum/recipe/ribplate_bear //Putting this here for not seeing a roast section.
	required_method = METHOD_OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	
	result = /obj/item/reagent_containers/food/snacks/ribplate_bear

/datum/recipe/teshariroast
	required_method = METHOD_OVEN
	fruit = list("lemon" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken/teshari)
	result = /obj/item/reagent_containers/food/snacks/teshariroast
	

/datum/recipe/dionaroast
	required_method = METHOD_OVEN
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/holder/diona)
	result = /obj/item/reagent_containers/food/snacks/dionaroast
	 //No eating polyacid

/datum/recipe/baguette
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough = 2
	)
	result = /obj/item/reagent_containers/food/snacks/baguette

//Predesigned pies
//=======================

/datum/recipe/meatpie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/ingredient/meat
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/datum/recipe/tofupie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/datum/recipe/xemeatpie
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/recipe/pie
	required_method = METHOD_OVEN
	fruit = list("banana" = 1)
	reagents = list("sugar" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/recipe/cherrypie
	required_method = METHOD_OVEN
	fruit = list("cherries" = 1)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie


/datum/recipe/amanita_pie
	required_method = METHOD_OVEN
	reagents = list("amatoxin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/recipe/plump_pie
	required_method = METHOD_OVEN
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/plump_pie


/datum/recipe/pumpkinpie
	required_method = METHOD_OVEN
	fruit = list("pumpkin" = 1)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	 //We dont want raw egg in the result

/datum/recipe/appletart
	required_method = METHOD_OVEN
	fruit = list("goldapple" = 1)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10, "egg" = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart
	

/datum/recipe/keylimepie
	required_method = METHOD_OVEN
	fruit = list("lime" = 2)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	 //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "egg" = 9, "flour" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	 //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/recipe/cookie
	required_method = METHOD_OVEN
	reagents = list("milk" = 10, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	

/datum/recipe/fortunecookie
	required_method = METHOD_OVEN
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
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

/datum/recipe/pretzel
	required_method = METHOD_OVEN
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	reagents = list("water" = 5, "sodiumchloride" = 2)
	result = /obj/item/reagent_containers/food/snacks/pretzel
	result_quantity = 2

/datum/recipe/poppypretzel
	required_method = METHOD_OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/datum/recipe/cracker
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker

/datum/recipe/brownies
	required_method = METHOD_OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	 //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies


/datum/recipe/cosmicbrownies
	required_method = METHOD_OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	fruit = list("ambrosia" = 1)
	 //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies




//Pizzas
//=========================
/datum/recipe/pizzamargherita
	required_method = METHOD_OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 4
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/ingredient/meat= 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	required_method = METHOD_OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	 //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	required_method = METHOD_OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	required_method = METHOD_OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring = 2
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

//Spicy
//================
/datum/recipe/enchiladas
	required_method = METHOD_OVEN
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cutlet)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/recipe/monkeysdelight
	required_method = METHOD_OVEN
	fruit = list("banana" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight
	





// Cakes.
//============
/datum/recipe/cake
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/plaincake
	

/datum/recipe/cake/carrot
	required_method = METHOD_OVEN
	fruit = list("carrot" = 3)
	result = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/datum/recipe/cake/cheese
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/datum/recipe/cake/orange
	required_method = METHOD_OVEN
	fruit = list("orange" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "orangejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/datum/recipe/cake/lime
	required_method = METHOD_OVEN
	fruit = list("lime" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/datum/recipe/cake/lemon
	required_method = METHOD_OVEN
	fruit = list("lemon" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/datum/recipe/cake/chocolate
	required_method = METHOD_OVEN
	items = list(/obj/item/reagent_containers/food/snacks/chocolatebar)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/datum/recipe/cake/birthday
	required_method = METHOD_OVEN
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/datum/recipe/cake/apple
	required_method = METHOD_OVEN
	fruit = list("apple" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/datum/recipe/cake/brain
	required_method = METHOD_OVEN
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/datum/recipe/honeycake
	required_method = METHOD_OVEN
	reagents = list("milk" = 5, "flour" = 10, "egg" = 6, "honey" = 5)
	result = /obj/item/reagent_containers/food/snacks/honeycake

/datum/recipe/pancakes
	required_method = METHOD_OVEN
	fruit = list("berries" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough = 2
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes

/datum/recipe/lasagna
	required_method = METHOD_OVEN
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough = 2,
		/obj/item/reagent_containers/food/snacks/cutlet = 2
	)
	result = /obj/item/reagent_containers/food/snacks/lasagna
	

/datum/recipe/honeybun
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list("honey" = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/datum/recipe/enchiladas_new
	required_method = METHOD_OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

//Bacon
/datum/recipe/bacon_oven
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon = 6,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/oven
	result_quantity = 6

/datum/recipe/meat_pocket
	required_method = METHOD_OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/datum/recipe/bacon_flatbread
	required_method = METHOD_OVEN
	fruit = list("tomato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon = 4
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/recipe/truffle
	required_method = METHOD_OVEN
	reagents = list("sugar" = 5, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

/datum/recipe/croissant
	required_method = METHOD_OVEN
	reagents = list("sodiumchloride" = 1, "water" = 5, "milk" = 5)
	
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant

/datum/recipe/macncheese
	required_method = METHOD_OVEN
	reagents = list("milk" = 5)
	
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/macncheese

/datum/recipe/ham
	required_method = METHOD_OVEN
	reagents = list("brine" = 15)
	
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 3,
	)
	result = /obj/item/reagent_containers/food/snacks/ham

/datum/recipe/rumham
	required_method = METHOD_OVEN
	reagents = list("rum" = 10)
	fruit = list("cherries" = 1, "spineapple" = 1)
	
	items = list(
		/obj/item/reagent_containers/food/snacks/ham
	)
	result = /obj/item/reagent_containers/food/snacks/rumham
