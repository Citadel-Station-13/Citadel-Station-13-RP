/* commented recipes will be annihilated once 100% sure that culinary_construct is a complete replacement for them
/datum/cooking_recipe/humanburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger

/datum/cooking_recipe/plainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meat = 100 //do not place this recipe before /datum/cooking_recipe/humanburger
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/cooking_recipe/syntiburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/synthflesh = 100
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/cooking_recipe/brainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger

/datum/cooking_recipe/roburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger

/datum/cooking_recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/xenomeat = 100
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger

/datum/cooking_recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/carp = 100
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger

/datum/cooking_recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu = 100
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/cooking_recipe/ghostburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/reagent_containers/food/snacks/ghostburger

/datum/cooking_recipe/clownburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger

/datum/cooking_recipe/mimeburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger

/datum/cooking_recipe/mouseburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/mouse
	)
	result = /obj/item/reagent_containers/food/snacks/mouseburger

/datum/cooking_recipe/lizardburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100,
		/obj/item/holder/micro
	)
	result = /obj/item/reagent_containers/food/snacks/lizardburger

/datum/cooking_recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/human = 200
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob

/datum/cooking_recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/monkey = 200
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
		/obj/item/reagent_containers/food/snacks/ingredient/meat/synthflesh = 2
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/cooking_recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu,
		/obj/item/reagent_containers/food/snacks/ingredient/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob



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

/datum/cooking_recipe/bearburger
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/bun,
		/obj/item/reagent_containers/food/snacks/ingredient/bearmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bearburger

/datum/cooking_recipe/chickenfilletsandwich //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/reagent_containers/food/snacks/ingredient/bun = 100
	)
	result = /obj/item/reagent_containers/food/snacks/chickenfilletsandwich

/datum/cooking_recipe/taconew
	items = list(
		/obj/item/reagent_containers/food/snacks/ingredient/tortilla,
		/obj/item/reagent_containers/food/snacks/ingredient/cutlet,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

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

/datum/cooking_recipe/cheese_cracker
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/ingredient/slice/bread,
		/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/reagent_containers/food/snacks/cheese_cracker
	result_quantity = 4

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

//sushi in the microwave

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

*/
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
