/datum/cooking_recipe/humanburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human,
		/obj/item/reagent_containers/food/snacks/ingredient/bun
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger

/datum/cooking_recipe/plainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat //do not place this recipe before /datum/cooking_recipe/humanburger
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/cooking_recipe/syntiburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/cooking_recipe/brainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger

/datum/cooking_recipe/roburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger

/datum/cooking_recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger

/datum/cooking_recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger

/datum/cooking_recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/cooking_recipe/ghostburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/reagent_containers/food/snacks/ghostburger

/datum/cooking_recipe/clownburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger

/datum/cooking_recipe/mimeburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger

/datum/cooking_recipe/mouseburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/mouse
	)
	result = /obj/item/reagent_containers/food/snacks/mouseburger

/datum/cooking_recipe/lizardburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/micro
	)
	result = /obj/item/reagent_containers/food/snacks/lizardburger

/datum/cooking_recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/datum/cooking_recipe/waffles
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough = 2
	)
	result = /obj/item/reagent_containers/food/snacks/waffles

/datum/cooking_recipe/donkpocket
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough,
		/obj/item/reagent_containers/food/snacks/ingredient/meatball
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



/datum/cooking_recipe/omelette
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 2,
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/datum/cooking_recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

/datum/cooking_recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 2
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/cooking_recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soylenviridians

/datum/cooking_recipe/soylentgreen
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human = 2
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen

/datum/cooking_recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/datum/cooking_recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/datum/cooking_recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human = 2
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob

/datum/cooking_recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/monkey = 2
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/cooking_recipe/meatkabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 2
	)
	result = /obj/item/reagent_containers/food/snacks/meatkabob

/datum/cooking_recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh = 2
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/cooking_recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob



/datum/cooking_recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/cooking_recipe/microchips
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/microchips

/datum/cooking_recipe/cheesyfries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries



/datum/cooking_recipe/popcorn
	fruit = list("corn" = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn



/datum/cooking_recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/cooking_recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak



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

/datum/cooking_recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
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



/datum/cooking_recipe/spellburger
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard
	)
	result = /obj/item/reagent_containers/food/snacks/spellburger

/datum/cooking_recipe/bigbiteburger
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 3
	)
	reagents = list("egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bigbiteburger

/datum/cooking_recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/cooking_recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 2,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich

/datum/cooking_recipe/toastedsandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/datum/cooking_recipe/grilledcheese
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread,
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/datum/cooking_recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/tomatosoup

/datum/cooking_recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough,
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/datum/cooking_recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/datum/cooking_recipe/dishostew
	fruit = list("disho" = 3, "mushroom" = 2, "chili" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/dishostew

/datum/cooking_recipe/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/datum/cooking_recipe/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/datum/cooking_recipe/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope, //what the fuck is a soy dope
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/milosoup

/datum/cooking_recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/*/datum/cooking_recipe/spaghetti We have the processor now
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	)
	result= /obj/item/reagent_containers/food/snacks/ingredient/spaghetti*/


/datum/cooking_recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/cooking_recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/cooking_recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list("water" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/spaghetti)
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

/datum/cooking_recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/superbiteburger
#warn todo boil eggs? stove recipe.
/datum/cooking_recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list("water" = 5, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/cooking_recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/cooking_recipe/slimeburger
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/slime

/datum/cooking_recipe/jellyburger
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/cherry

/datum/cooking_recipe/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 2
	)
	result = /obj/item/reagent_containers/food/snacks/twobread

/datum/cooking_recipe/slimesandwich
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 2
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime

/datum/cooking_recipe/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 2
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry

/datum/cooking_recipe/bloodsoup
	reagents = list("blood" = 30)
	result = /obj/item/reagent_containers/food/snacks/bloodsoup

/datum/cooking_recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/slimesoup

/datum/cooking_recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract
	)
	result = /obj/item/reagent_containers/food/snacks/boiledslimecore

/datum/cooking_recipe/chocolateegg
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg

/datum/cooking_recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/ingredient/sausage
	result_quantity = 2

/datum/cooking_recipe/fishfingers
	reagents = list("flour" = 10,"egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/cooking_recipe/mysterysoup
	reagents = list("water" = 10, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mysterysoup



/datum/cooking_recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list("water" = 5, "flour" = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/cooking_recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mushroomsoup

/datum/cooking_recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5, "egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

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

/datum/cooking_recipe/tofurkey
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/cooking_recipe/mashedpotato
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter // to prevent conflicts with yellow curry
	)
	fruit = list("potato" = 1)
	result = /obj/item/reagent_containers/food/snacks/mashedpotato

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


/////////////////////////////////////////////////////////////
//Synnono Meme Foods
//
//Most recipes replace reagents with RECIPE_REAGENT_REPLACE
//to simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.
/////////////////////////////////////////////////////////////


/datum/cooking_recipe/redcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet = 2
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/datum/cooking_recipe/greencurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/datum/cooking_recipe/yellowcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/datum/cooking_recipe/bearburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/bearmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bearburger

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

/datum/cooking_recipe/bibimbap
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list("rice" = 5, "spacespice" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/cooking_recipe/friedrice
	reagents = list("water" = 5, "rice" = 10, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/datum/cooking_recipe/lomein
	reagents = list("water" = 5, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein

/datum/cooking_recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenkatsu, //wtf do we do with the katsu here? no fucking clue
		/obj/item/reagent_containers/food/snacks/ingredient/bun
	)
	result = /obj/item/reagent_containers/food/snacks/chickenfillet

/datum/cooking_recipe/chilicheesefries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge,
		/obj/item/reagent_containers/food/snacks/hotchili //lol.
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chilicheesefries

/datum/cooking_recipe/meatbun
	reagents = list("spacespice" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/datum/cooking_recipe/custardbun
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/datum/cooking_recipe/chickenmomo
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 3,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/cooking_recipe/veggiemomo
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice = 3
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo

/datum/cooking_recipe/risotto
	reagents = list("wine" = 5, "rice" = 10, "spacespice" = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/datum/cooking_recipe/poachedegg
	reagents = list("spacespice" = 1, "sodiumchloride" = 1, "blackpepper" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/datum/cooking_recipe/honeytoast
	reagents = list("honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast


/datum/cooking_recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab


/datum/cooking_recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi


/datum/cooking_recipe/nugget
	reagents = list("flour" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget

// Chip update
/datum/cooking_recipe/tortila
	reagents = list("flour" = 5,"water" = 5)
	result = /obj/item/reagent_containers/food/snacks/ingredient/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

/datum/cooking_recipe/taconew
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

/datum/cooking_recipe/chips
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/datum/cooking_recipe/nachos
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

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

/datum/cooking_recipe/cheesesauce
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/cooking_recipe/breakfast_wrap
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon,
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge,
		/obj/item/reagent_containers/food/snacks/ingredient/egg
	)
	result = /obj/item/reagent_containers/food/snacks/breakfast_wrap

/datum/cooking_recipe/burrito_mystery
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/mysterysoup
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_mystery


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

/datum/cooking_recipe/cheese_cracker
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/reagent_containers/food/snacks/cheese_cracker
	result_quantity = 4

/datum/cooking_recipe/bacon_and_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/datum/cooking_recipe/baconburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 2
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bacon

/datum/cooking_recipe/ntmuffin
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/ingredient/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/nt_muffin

/datum/cooking_recipe/fish_taco
	fruit = list("chili" = 1, "lemon" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp,
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/fish_taco

/datum/cooking_recipe/blt
	fruit = list("tomato" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread = 2,
		/obj/item/reagent_containers/food/snacks/ingredient/bacon = 2
	)
	result = /obj/item/reagent_containers/food/snacks/blt

/datum/cooking_recipe/onionrings
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings

/datum/cooking_recipe/berrymuffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/reagent_containers/food/snacks/muffin

/datum/cooking_recipe/onionsoup
	fruit = list("onion" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/datum/cooking_recipe/porkbowl
	reagents = list("water" = 5, "rice" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

//BEGIN CITADEL CHANGES

/datum/cooking_recipe/sushi_gen
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/cooking_recipe/sushi // Changed to take fish and not steak meat OMEGALUL
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp/fish
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/cooking_recipe/sushi_sif
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/carp/fish
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/cooking_recipe/sushi/crab
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/crab
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/crab

/datum/cooking_recipe/sushi/horse
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/horsemeat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/horse

/datum/cooking_recipe/sushi/mystery
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/mystery

/datum/cooking_recipe/goulash
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet,
		/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	)
	result = /obj/item/reagent_containers/food/snacks/goulash

/datum/cooking_recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab

/datum/cooking_recipe/roastbeef
	fruit = list("carrot" = 2, "potato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat
	)
	result = /obj/item/reagent_containers/food/snacks/roastbeef

/datum/cooking_recipe/reishicup
	reagents = list("psilocybin" = 3, "sugar" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/reishicup

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

/datum/cooking_recipe/pillbugball
	reagents = list(MAT_CARBON = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bugball

/datum/cooking_recipe/mammi
	fruit = list("orange" = 1)
	reagents = list("water" = 10, "flour" = 10, "milk" = 5, "sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/mammi

/datum/cooking_recipe/makaroni
	reagents = list("flour" = 15, "milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/ingredient/egg,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge = 2
	)
	result = /obj/item/reagent_containers/food/snacks/makaroni

/datum/cooking_recipe/crayonburger_red
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/red
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_red

/datum/cooking_recipe/crayonburger_org
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/orange
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_org

/datum/cooking_recipe/crayonburger_yel
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/yellow
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_yel

/datum/cooking_recipe/crayonburger_grn
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/green
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_grn

/datum/cooking_recipe/crayonburger_blu
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/blue
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_blu

/datum/cooking_recipe/crayonburger_prp
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/purple
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_prp

/datum/cooking_recipe/crayonburger_rbw
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/meat,
		/obj/item/pen/crayon/rainbow
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_rbw

/datum/cooking_recipe/rkibble
	reagents = list("milk" = 5, "tallow" = 10)
	items = list(
		/obj/item/robot_parts/head,
		/obj/item/stack/rods
	)
	result = /obj/item/trash/rkibble

//Goblin Food Goblin Food
/datum/cooking_recipe/cavenuggets
	fruit = list("mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meatball,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/cavenuggets

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

/datum/cooking_recipe/greenham
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/cooking_recipe/greenhamandeggs
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 2,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/bait/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/cooking_recipe/roach_burger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/roach
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger

/datum/cooking_recipe/roach_burger/armored
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/panzer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/armored

/datum/cooking_recipe/roach_burger/pale
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/jager
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/pale

/datum/cooking_recipe/roach_burger/purple
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/purple

/datum/cooking_recipe/roach_burger/big
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/roach,
		/obj/item/holder/roach,
		/obj/item/holder/jager,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/big

/datum/cooking_recipe/roach_burger/reich
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/holder/fuhrer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/reich

/datum/cooking_recipe/fruitsalad
	fruit = list("apple" = 1, "berries" = 1, "banana" = 1, "cherries" = 1)
	reagents = list("milk" = 10, "cream" = 5)
	result = /obj/item/reagent_containers/food/snacks/fruitsalad

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

/datum/cooking_recipe/sauerkraut
	fruit = list("cabbage" = 1)
	reagents = list("brine" = 5)
	result = /obj/item/reagent_containers/food/snacks/sauerkraut

/datum/cooking_recipe/kimchi
	fruit = list("cabbage" = 1, "whitebeet" = 1)
	reagents = list("brine" = 5, "blackpepper" = 2)
	result = /obj/item/reagent_containers/food/snacks/kimchi

/datum/cooking_recipe/chickensatay
	fruit = list("peanut" = 1, "lime" = 1)
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken,
		/obj/item/reagent_containers/food/snacks/yellowcurry
	)
	reagents = list("water" = 5, "milk" = 5, "soysauce" = 5, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/chickensatay

/datum/cooking_recipe/frenchonionsoup
	fruit = list("onion" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge)
	reagents = list("water" = 10, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/frenchonionsoup

/datum/cooking_recipe/bananasplit
	fruit = list("banana" = 1, "cherries" = 1)
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/ice_cream,
		/obj/item/reagent_containers/food/snacks/ice_cream,
	)
	result = /obj/item/reagent_containers/food/snacks/bananasplit

/datum/cooking_recipe/wormburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/ingredient/meat
	)
	result = /obj/item/reagent_containers/food/snacks/wormburger

/datum/cooking_recipe/spider_wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat/spidermeat
	)
	result = /obj/item/reagent_containers/food/snacks/spider_wingfangchu

/datum/cooking_recipe/steamedspider
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat/spidermeat
	)
	result = /obj/item/reagent_containers/food/snacks/steamedspider

/datum/cooking_recipe/saplingsdelight
	items = list(
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/bait/worm,
		/obj/item/reagent_containers/food/snacks/badrecipe
	)
	result = /obj/item/reagent_containers/food/snacks/saplingsdelight


/datum/cooking_recipe/shrimpcocktail
	fruit = list("tomato" = 2, "chili" = 2, "lemon" = 2)
	reagents = list("water" = 5, "sodiumchloride" = 5, "pepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
		/obj/item/reagent_containers/food/snacks/ingredient/shrimp,
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpcocktail

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

/datum/cooking_recipe/puddi
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 3,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi

/datum/cooking_recipe/puddi_happy
	reagents = list("milk" = 10, "sugar" = 5, "honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 3,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/happy

/datum/cooking_recipe/puddi_angry
	fruit = list("chili" = 2)
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 3,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/angry

//all recipes that require holders are now microwave-only. NOT sorry at all.
/datum/cooking_recipe/dionaroast
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/holder/diona)
	result = /obj/item/reagent_containers/food/snacks/dionaroast
	 //No eating polyacid
