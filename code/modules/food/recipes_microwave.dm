/datum/cooking_recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/sausage = 100
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/datum/cooking_recipe/donkpocket
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meatball = 100
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL

/datum/cooking_recipe/donkpocket/proc/warm_up(obj/item/reagent_containers/food/snacks/donkpocket/being_cooked)
	being_cooked.heat()

/datum/cooking_recipe/donkpocket/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/donkpocket/D in .)
		if (!D.warm)
			warm_up(D)

/datum/cooking_recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL

/datum/cooking_recipe/soylenviridians
	fruit = list("soybeans" = 100)
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soylenviridians

/datum/cooking_recipe/soylentgreen
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human = 200
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen

/datum/cooking_recipe/wingfangchu //what the fuck IS wing fang chu?
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu


/datum/cooking_recipe/cheesyfries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 50
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries


/datum/cooking_recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5, "psilocybin" = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/datum/cooking_recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5, "amatoxin" = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly

/datum/cooking_recipe/amanitajelly/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent("amatoxin")

/datum/cooking_recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/cooking_recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 200
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/*/datum/cooking_recipe/spaghetti We have the processor now
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	)
	result= /obj/item/reagent_containers/food/snacks/ingredient/spaghetti*/

/datum/cooking_recipe/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 200
	)
	result = /obj/item/reagent_containers/food/snacks/twobread

/datum/cooking_recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract
	)
	result = /obj/item/reagent_containers/food/snacks/boiledslimecore

/datum/cooking_recipe/chocolateegg
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 100,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg







/datum/cooking_recipe/icecreamsandwich
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ice_cream,
	)
	result = /obj/item/reagent_containers/food/snacks/icecreamsandwich

// Fuck Science!
/datum/cooking_recipe/ruinedvirusdish
	items = list(
		/obj/item/virusdish
	)
	result = /obj/item/ruinedvirusdish

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/cooking_recipe/mint
	reagents = list("sugar" = 5, "frostoil" = 5)
	result = /obj/item/reagent_containers/food/snacks/mint

//sashimi in da microwave
/datum/cooking_recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi

/datum/cooking_recipe/bacon_and_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 100,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs



//BEGIN CITADEL CHANGES


/datum/cooking_recipe/reishicup
	reagents = list("psilocybin" = 3, "sugar" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/reishicup


/datum/cooking_recipe/rkibble
	reagents = list("milk" = 5, "tallow" = 10)
	items = list(
		/obj/item/robot_parts/head,
		/obj/item/stack/rods
	)
	result = /obj/item/trash/rkibble

/datum/cooking_recipe/roach_burger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/roach
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger

/datum/cooking_recipe/roach_burger/armored
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/panzer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/armored

/datum/cooking_recipe/roach_burger/pale
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/jager
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/pale

/datum/cooking_recipe/roach_burger/purple
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/purple

/datum/cooking_recipe/roach_burger/big
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/roach,
		/obj/item/holder/roach,
		/obj/item/holder/jager,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/big

/datum/cooking_recipe/roach_burger/reich
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/fuhrer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/reich

/datum/cooking_recipe/fruitsalad
	fruit = list("apple" = 100, "berries" = 100, "banana" = 100, "cherries" = 100)
	reagents = list("milk" = 10, "cream" = 5)
	result = /obj/item/reagent_containers/food/snacks/fruitsalad


/datum/cooking_recipe/sauerkraut
	fruit = list("cabbage" = 100)
	reagents = list("brine" = 5)
	result = /obj/item/reagent_containers/food/snacks/sauerkraut

/datum/cooking_recipe/kimchi
	fruit = list("cabbage" = 100, "whitebeet" = 100)
	reagents = list("brine" = 5, "blackpepper" = 2)
	result = /obj/item/reagent_containers/food/snacks/kimchi




/datum/cooking_recipe/bananasplit
	fruit = list("banana" = 100, "cherries" = 20)
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/ice_cream,
		/obj/item/reagent_containers/food/snacks/ice_cream,
	)
	result = /obj/item/reagent_containers/food/snacks/bananasplit

/datum/cooking_recipe/wormburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 20
	)
	result = /obj/item/reagent_containers/food/snacks/wormburger

/datum/cooking_recipe/shrimpcocktail
	fruit = list("tomato" = 20, "chili" = 20, "lemon" = 5)
	reagents = list("water" = 5, "sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp = 100 //shrimp glockenspiel
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpcocktail






//all recipes that require holders are now microwave-only. NOT sorry at all.
/datum/cooking_recipe/dionaroast
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/holder/diona)
	result = /obj/item/reagent_containers/food/snacks/dionaroast
	 //No eating polyacid
