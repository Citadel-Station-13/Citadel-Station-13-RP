/obj/item/reagent_containers/food/snacks/ingredient/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	cookstage_information = list(list(0, 0.5, "raw meat"), list(45 SECONDS, 1.2, "cooked meat"), list(60 SECONDS, 0.9, "rubbery meat"), list(75 SECONDS, 0.1, "a lump of char with some rubbery parts"))
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/rawcutlet
	slices_num = 3

/obj/item/reagent_containers/food/snacks/ingredient/meat/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	src.bitesize = 1.5

/obj/item/reagent_containers/food/snacks/ingredient/meat/on_cooked(reached_stage, cook_method)
	if(reached_stage = COOKED && !isnull(cooked_icon))
		icon_state = cooked_icon


/obj/item/reagent_containers/food/snacks/ingredient/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/reagent_containers/food/snacks/ingredient/bearmeat // Buff 12 >> 17
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"

/obj/item/reagent_containers/food/snacks/ingredient/horsemeat
	name = "horse meat"
	desc = "No no, I said it came from something fast."

/obj/item/reagent_containers/food/snacks/xenomeat // Buff 6 >> 10
	name = "xenomeat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xenomeat/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("pacid",6)
	src.bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat // Substitute for recipes requiring xeno meat.
	name = "spider meat"
	desc = "A slab of green meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat/Initialize(mapload)
	. = ..()
	reagents.add_reagent("spidertoxin",6)
	reagents.remove_reagent("pacid",6)
	src.bitesize = 6

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/ingredient/meat/human
	name = "suspicious meat"
	desc = "Tastes vaguely like pork."

/obj/item/reagent_containers/food/snacks/ingredient/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/ingredient/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken
	icon = 'icons/obj/food.dmi'
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken/Initialize(mapload)
	..()
	reagents.remove_reagent("triglyceride", INFINITY)
	//Chicken is low fat. Less total calories than other meats

/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken/penguin
	name = "meat"
	desc = "Tastes like chicken? Or fish? Fishy chicken? Strange."
	icon = 'icons/obj/food.dmi'
	icon_state = "penguinmeat"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/ingredient/meat/chicken/teshari
	name = "meat"
	desc = "Tastes like a really fast chicken. Who'd have guessed?"

/obj/item/reagent_containers/food/snacks/ingredient/meat/vox
	name = "vox meat"
	desc = "Tough and sinewy. Don't eat it raw."
	cookstage_information = list(list(0, 0.5, "impossibly tough, spicy meat with hints of phoron"), list(2 MINUTES, 1.2, "tough, spicy meat with hints of phoron"), list(4 MINUTES , 0.9, "rubbery meat with hints of phoron"), list(10 MINUTES, 0.1, "phoron-enriched charcoal"))
	icon = 'icons/obj/food.dmi'
	icon_state = "voxmeat"
	cooked_icon = "voxmeat_cooked"

/obj/item/reagent_containers/food/snacks/ingredient/meat/vox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("phoron", 3)
	src.bitesize = 1.5


/obj/item/reagent_containers/food/snacks/ingredient/cutlet
	name = "cutlet"
	desc = "A thin piece of meat."
	cookstage_information = list(list(0, 0.5, "raw meat"), list(30 SECONDS, 1.2, "cooked meat"), list(45 SECONDS, 0.9, "rubbery meat"), list(60 SECONDS, 0.1, "a lump of char with some rubbery parts"))
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/ingredient/cutlet/on_cooked(reached_stage, cook_method)
	if(reached_stage = COOKED)
		icon_state = "cutlet"
		reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/ingredient/meatball
	name = "meatball"
	desc = "A meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	cookstage_information = list(list(0, 0.5, "raw meatball"), list(30 SECONDS, 1.2, "meatballs"), list(45 SECONDS, 0.9, "rubbery meat"), list(60 SECONDS, 0.1, "a sphere of char with some rubbery parts"))
	icon_state = "rawmeatball"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ingredient/cutlet/on_cooked(reached_stage, cook_method)
	if(reached_stage = COOKED)
		icon_state = "meatball"
		reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/ingredient/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	cookstage_information = list(list(0, 0.5, "raw meat and sausage casing"), list(30 SECONDS, 1.2, "hotdog"), list(45 SECONDS, 0.9, "rubbery hotdog"), list(60 SECONDS, 0.1, "squishy, ovecooked sausage casing and charred meat"))
	icon_state = "hotdog"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage // Buff 6 >> 9
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"

/obj/item/reagent_containers/food/snacks/sausage/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 9)
	bitesize = 3


/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin piece of raw meat."
	cookstage_information = list(list(0, 0.5, "raw bacon"), list(25 SECONDS, 1.2, "bacon"), list(35 SECONDS, 0.9, "rubbery, tough bacon"), list(45 SECONDS, 0.1, "bacon, burnt to unpalatability"))
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawbacon"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/rawbacon/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 0.33)

/obj/item/reagent_containers/food/snacks/ingredient/bacon/on_cooked(reached_stage, cook_method)
	if(reached_stage = COOKED)
		icon_state = "bacon"
		reagents.add_reagent("protein", 0.6)




//seafoods
/obj/item/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "A shifty lobster. You can try eating it, but its shell is extremely tough."
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "It's an adorable squid! you can't possible be thinking about eating this right?"
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/shrimp
	name = "raw shrimp"
	desc = "An old-Earth sea creature. Formerly a luxury item, shrimp are commonly farmed as an easy source of protein."
	icon_state = "shrimp_raw"
	nutriment_amt = 5


//non-vegan plant-based meats
/obj/item/reagent_containers/food/snacks/hugemushroomslice // Buff 3 >> 5
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"
	nutriment_amt = 5
	nutriment_desc = list("raw" = 2, "mushroom" = 2)

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
