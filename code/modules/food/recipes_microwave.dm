
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_containers/food/snacks/telebacon

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_containers/food/snacks/telebacon
*/

/datum/recipe/friedegg
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/datum/recipe/boiledegg
	reagents = list("water" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/datum/recipe/humanburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger

/datum/recipe/plainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat //do not place this recipe before /datum/recipe/humanburger
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/recipe/syntiburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/recipe/brainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger

/datum/recipe/roburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger

/datum/recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger

/datum/recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger

/datum/recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/recipe/ghostburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/reagent_containers/food/snacks/ghostburger

/datum/recipe/clownburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger

/datum/recipe/mimeburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger

/datum/recipe/mouseburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/mouse
	)
	result = /obj/item/reagent_containers/food/snacks/mouseburger

/datum/recipe/lizardburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/micro
	)
	result = /obj/item/reagent_containers/food/snacks/lizardburger

/datum/recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/datum/recipe/waffles
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/waffles

/datum/recipe/donkpocket
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL

/datum/recipe/donkpocket/proc/warm_up(obj/item/reagent_containers/food/snacks/donkpocket/being_cooked)
		being_cooked.heat()

/datum/recipe/donkpocket/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/donkpocket/D in .)
		if (!D.warm)
			warm_up(D)

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL



/datum/recipe/omelette
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/datum/recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

/datum/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soylenviridians

/datum/recipe/soylentgreen
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen

/datum/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/datum/recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/datum/recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob

/datum/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/monkey,
		/obj/item/reagent_containers/food/snacks/meat/monkey
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/recipe/meatkabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/reagent_containers/food/snacks/meatkabob

/datum/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob



/datum/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/microchips
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/microchips

/datum/recipe/cheesyfries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries



/datum/recipe/popcorn
	fruit = list("corn" = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn



/datum/recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak



/datum/recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5, "psilocybin" = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5, "amatoxin" = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly

/datum/recipe/amanitajelly/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent("amatoxin")

/datum/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/meatballsoup

/datum/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/vegetablesoup

/datum/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list("water" = 10, "egg" = 3)
	result = /obj/item/reagent_containers/food/snacks/nettlesoup

/datum/recipe/wishsoup
	reagents = list("water" = 20)
	result= /obj/item/reagent_containers/food/snacks/wishsoup

/datum/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/datum/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili



/datum/recipe/spellburger
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard
	)
	result = /obj/item/reagent_containers/food/snacks/spellburger

/datum/recipe/bigbiteburger
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagents = list("egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bigbiteburger

/datum/recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich

/datum/recipe/toastedsandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/grilledcheese
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/datum/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/tomatosoup

/datum/recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/datum/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/datum/recipe/dishostew
	fruit = list("disho" = 3, "mushroom" = 2, "chili" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/dishostew

/datum/recipe/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/datum/recipe/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/datum/recipe/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/milosoup

/datum/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/*/datum/recipe/spagetti We have the processor now
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result= /obj/item/reagent_containers/food/snacks/spagetti*/

/datum/recipe/boiledspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspagetti

/datum/recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list("water" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/spagetti)
	result = /obj/item/reagent_containers/food/snacks/pastatomato

/datum/recipe/meatballspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspagetti

/datum/recipe/spesslaw
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw

/datum/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/superbiteburger

/datum/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list("water" = 5, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/recipe/slimeburger
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/slime

/datum/recipe/jellyburger
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/cherry

/datum/recipe/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/twobread

/datum/recipe/slimesandwich
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime

/datum/recipe/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry

/datum/recipe/bloodsoup
	reagents = list("blood" = 30)
	result = /obj/item/reagent_containers/food/snacks/bloodsoup

/datum/recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/slimesoup

/datum/recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract
	)
	result = /obj/item/reagent_containers/food/snacks/boiledslimecore

/datum/recipe/chocolateegg
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg

/datum/recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/sausage
	result_quantity = 2

/datum/recipe/fishfingers
	reagents = list("flour" = 10,"egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/mysterysoup
	reagents = list("water" = 10, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mysterysoup



/datum/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list("water" = 5, "flour" = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mushroomsoup

/datum/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5, "egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/datum/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/beetsoup

/datum/recipe/dishosoup
	fruit = list("disho" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/dishosoup

/datum/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/tossedsalad

/datum/recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)
	result = /obj/item/reagent_containers/food/snacks/aesirsalad

/datum/recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/validsalad

/datum/recipe/validsalad/make_food(obj/container)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent("toxin")


/datum/recipe/stuffing
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing

/datum/recipe/tofurkey
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/recipe/mashedpotato
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter // to prevent conflicts with yellow curry
	)
	fruit = list("potato" = 1)
	result = /obj/item/reagent_containers/food/snacks/mashedpotato

/datum/recipe/icecreamsandwich
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/icecreamsandwich

// Fuck Science!
/datum/recipe/ruinedvirusdish
	items = list(
		/obj/item/virusdish
	)
	result = /obj/item/ruinedvirusdish

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco


/datum/recipe/meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball

/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/datum/recipe/mint
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


/datum/recipe/redcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/datum/recipe/greencurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/datum/recipe/yellowcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/datum/recipe/bearburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bearmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bearburger

/datum/recipe/bearchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/datum/recipe/bearstew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearstew

/datum/recipe/bibimbap
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list("rice" = 5, "spacespice" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/recipe/friedrice
	reagents = list("water" = 5, "rice" = 10, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/datum/recipe/lomein
	reagents = list("water" = 5, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/chickenfillet

/datum/recipe/chilicheesefries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chilicheesefries

/datum/recipe/meatbun
	reagents = list("spacespice" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/datum/recipe/custardbun
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/datum/recipe/chickenmomo
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/recipe/veggiemomo
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo

/datum/recipe/risotto
	reagents = list("wine" = 5, "rice" = 10, "spacespice" = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/datum/recipe/poachedegg
	reagents = list("spacespice" = 1, "sodiumchloride" = 1, "blackpepper" = 1, "water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/datum/recipe/honeytoast
	reagents = list("honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast


/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab


/datum/recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi


/datum/recipe/nugget
	reagents = list("flour" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget

// Chip update
/datum/recipe/tortila
	reagents = list("flour" = 5,"water" = 5)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

/datum/recipe/taconew
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

/datum/recipe/chips
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/datum/recipe/nachos
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

/datum/recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/cheesesauce
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/burrito
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/reagent_containers/food/snacks/burrito

/datum/recipe/burrito_vegan
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_vegan

/datum/recipe/burrito_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_spicy

/datum/recipe/burrito_cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese

/datum/recipe/burrito_cheese_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese_spicy

/datum/recipe/burrito_hell
	fruit = list("chili" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito_spicy
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/datum/recipe/breakfast_wrap
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/breakfast_wrap

/datum/recipe/burrito_mystery
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/mysterysoup
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_mystery

//Ligger food, and also bacon.

/datum/recipe/bacon
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon

/datum/recipe/chilied_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/hotchili,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/chilied_eggs

/datum/recipe/red_sun_special
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/cheesewedge

	)
	result = /obj/item/reagent_containers/food/snacks/red_sun_special

/datum/recipe/hatchling_suprise
	items = list(
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon

	)
	result = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/datum/recipe/riztizkzi_sea
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagents = list("blood" = 15)
	result = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/datum/recipe/father_breakfast
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/omelette,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/reagent_containers/food/snacks/father_breakfast

/datum/recipe/stuffed_meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/stuffed_meatball

/datum/recipe/egg_pancake
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/omelette
	)
	result = /obj/item/reagent_containers/food/snacks/egg_pancake

/datum/recipe/grilled_carp
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	reagents = list("spacespice" = 1)
	fruit = list("cabbage" = 1, "lime" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/recipe/bacon_stick
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_stick

/datum/recipe/cheese_cracker
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/reagent_containers/food/snacks/cheese_cracker
	result_quantity = 4

/datum/recipe/bacon_and_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/datum/recipe/baconburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bacon

/datum/recipe/ntmuffin
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/nt_muffin

/datum/recipe/fish_taco
	fruit = list("chili" = 1, "lemon" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/fish_taco

/datum/recipe/blt
	fruit = list("tomato" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/blt

/datum/recipe/onionrings
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings

/datum/recipe/berrymuffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/reagent_containers/food/snacks/muffin

/datum/recipe/onionsoup
	fruit = list("onion" = 1)
	reagents = list("water" = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/datum/recipe/porkbowl
	reagents = list("water" = 5, "rice" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

//BEGIN CITADEL CHANGES

/datum/recipe/sushi_gen
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/sushi // Changed to take fish and not steak meat OMEGALUL
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat/fish
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/sushi_sif
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat/fish
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/sushi/crab
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/crab,
		/obj/item/reagent_containers/food/snacks/meat/crab
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/crab

/datum/recipe/sushi/horse
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/horsemeat,
		/obj/item/reagent_containers/food/snacks/horsemeat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/horse

/datum/recipe/sushi/mystery
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi/mystery

/datum/recipe/goulash
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/reagent_containers/food/snacks/goulash

/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab

/datum/recipe/roastbeef
	fruit = list("carrot" = 2, "potato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/roastbeef

/datum/recipe/reishicup
	reagents = list("psilocybin" = 3, "sugar" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/reishicup

/datum/recipe/hotandsoursoup
	fruit = list("cabbage" = 1, "mushroom" = 1)
	reagents = list("sodiumchloride" = 2, "blackpepper" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/hotandsoursoup

/datum/recipe/kitsuneudon
	reagents = list("egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/kitsuneudon

/datum/recipe/pillbugball
	reagents = list(MAT_CARBON = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/grubmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bugball

/datum/recipe/mammi
	fruit = list("orange" = 1)
	reagents = list("water" = 10, "flour" = 10, "milk" = 5, "sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/mammi

/datum/recipe/makaroni
	reagents = list("flour" = 15, "milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/makaroni

/datum/recipe/crayonburger_red
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/red
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_red

/datum/recipe/crayonburger_org
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/orange
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_org

/datum/recipe/crayonburger_yel
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/yellow
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_yel

/datum/recipe/crayonburger_grn
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/green
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_grn

/datum/recipe/crayonburger_blu
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/blue
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_blu

/datum/recipe/crayonburger_prp
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/purple
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_prp

/datum/recipe/crayonburger_rbw
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/pen/crayon/rainbow
	)
	result = /obj/item/reagent_containers/food/snacks/crayonburger_rbw

/datum/recipe/rkibble
	reagents = list("milk" = 5, "cooking_oil" = 10)
	items = list(
		/obj/item/robot_parts/head,
		/obj/item/stack/rods
	)
	result = /obj/item/trash/rkibble

//Goblin Food Goblin Food
/datum/recipe/cavenuggets
	fruit = list("mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/cavenuggets

/datum/recipe/diggerstew
	fruit = list("carrot" = 1, "mushroom" = 1)
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm
	)
	result = /obj/item/reagent_containers/food/snacks/diggerstew

/datum/recipe/diggerstew_pot
	fruit = list("carrot" = 1, "potato" = 1, "mushroom" = 1)
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm
	)
	result = /obj/item/reagent_containers/food/snacks/diggerstew_pot

/datum/recipe/full_goss
	fruit = list("carrot" = 1, "mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/meat/grubmeat
	)
	result = /obj/item/reagent_containers/food/snacks/full_goss

/datum/recipe/greenham
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/recipe/greenhamandeggs
	reagents = list("spacespice" = 2, "water" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/worm
	)
	result = /obj/item/reagent_containers/food/snacks/greenham

/datum/recipe/voxjerky
	reagents = list("sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/vox
	)
	result = /obj/item/reagent_containers/food/snacks/voxjerky

/datum/recipe/roach_burger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/roach
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger

/datum/recipe/roach_burger/armored
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/panzer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/armored

/datum/recipe/roach_burger/pale
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/jager
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/pale

/datum/recipe/roach_burger/purple
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/purple

/datum/recipe/roach_burger/big
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/roach,
		/obj/item/holder/roach,
		/obj/item/holder/jager,
		/obj/item/holder/seuche
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/big

/datum/recipe/roach_burger/reich
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/fuhrer
	)
	result = /obj/item/reagent_containers/food/snacks/roach_burger/reich

/datum/recipe/fruitsalad
	fruit = list("apple" = 1, "berries" = 1, "banana" = 1, "cherries" = 1)
	reagents = list("milk" = 10, "cream" = 5)
	result = /obj/item/reagent_containers/food/snacks/fruitsalad

/datum/recipe/mushroompasta
	fruit = list("mushroom" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/spagetti)
	reagents = list("water" = 5)
	result = /obj/item/reagent_containers/food/snacks/mushroompasta

/datum/recipe/carbonara
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	result = /obj/item/reagent_containers/food/snacks/carbonara

/datum/recipe/bloodsausage
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	reagents = list("blood" = 15)
	result = /obj/item/reagent_containers/food/snacks/bloodsausage

/datum/recipe/weisswurst
	fruit = list("onion" = 1, "lemon" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sausage)
	reagents = list("water" = 15, "sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/weisswurst

/datum/recipe/sauerkraut
	fruit = list("cabbage" = 1)
	reagents = list("brine" = 5)
	result = /obj/item/reagent_containers/food/snacks/sauerkraut

/datum/recipe/kimchi
	fruit = list("cabbage" = 1, "whitebeet" = 1)
	reagents = list("brine" = 5, "blackpepper" = 2)
	result = /obj/item/reagent_containers/food/snacks/kimchi

/datum/recipe/chickensatay
	fruit = list("peanut" = 1, "lime" = 1)
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/yellowcurry
	)
	reagents = list("water" = 5, "milk" = 5, "soysauce" = 5, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/chickensatay

/datum/recipe/frenchonionsoup
	fruit = list("onion" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	reagents = list("water" = 10, "sodiumchloride" = 1, "sugar" = 1)
	result = /obj/item/reagent_containers/food/snacks/frenchonionsoup

/datum/recipe/bananasplit
	fruit = list("banana" = 1, "cherries" = 1)
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/icecream,
		/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/bananasplit

/datum/recipe/wormburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/wormburger

/datum/recipe/spider_wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat
	)
	result = /obj/item/reagent_containers/food/snacks/spider_wingfangchu

/datum/recipe/steamedspider
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat
	)
	result = /obj/item/reagent_containers/food/snacks/steamedspider

/datum/recipe/saplingsdelight
	items = list(
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/badrecipe
	)
	result = /obj/item/reagent_containers/food/snacks/saplingsdelight

/datum/recipe/lobster
	fruit = list("lemon" = 1, "cabbage" = 1)
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/lobster,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/lobstercooked

/datum/recipe/shrimp
	reagents = list("water" = 2, "sodiumchloride" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpcooked

/datum/recipe/shrimpcocktail
	fruit = list("tomato" = 2, "chili" = 2, "lemon" = 2)
	reagents = list("water" = 5, "sodiumchloride" = 5, "pepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/shrimp,
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpcocktail

/datum/recipe/shrimpfriedrice
	fruit = list("corn" = 1, "carrot" = 1, "peas" = 1)
	reagents = list("water" = 5, "sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/shrimp,
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	result = /obj/item/reagent_containers/food/snacks/shrimpfriedrice

/datum/recipe/bowl_peas
	fruit = list("peas" = 4)
	reagents = list("water" = 5, "sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/bowl_peas

/datum/recipe/puddi
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi

/datum/recipe/puddi_happy
	reagents = list("milk" = 10, "sugar" = 5, "honey" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/happy

/datum/recipe/puddi_angry
	fruit = list("chili" = 2)
	reagents = list("milk" = 10, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/puddi/angry
