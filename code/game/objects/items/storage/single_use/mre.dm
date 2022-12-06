/*
MRE Stuff
 */

/obj/item/storage/single_use/mre
	name = "standard MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 1, meat pizza."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	max_w_class = ITEMSIZE_SMALL
	starts_with = list(
	/obj/item/storage/single_use/mrebag,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu2
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 2, margherita."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu2,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu3
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 3, vegetable pizza."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu3,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu4
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 4, hamburger."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu4,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu5
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 5, taco."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu5,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu6
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 6, meatbread."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu6,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu7
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 7, salad."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu7,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu8
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 8, hot chili."
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu8,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu9
	name = "vegan MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 9, boiled rice (skrell-safe)."
	icon_state = "vegmre"
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu9,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert/menu9,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread/vegan,
	/obj/random/mre/drink,
	/obj/random/mre/sauce/vegan,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu10
	name = "protein MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 10, protein."
	icon_state = "meatmre"
	starts_with = list(
	/obj/item/storage/single_use/mrebag/menu10,
	/obj/item/storage/single_use/mrebag/menu10,
	/obj/item/reagent_containers/food/snacks/candy/proteinbar,
	/obj/item/reagent_containers/food/condiment/small/packet/protein,
	/obj/random/mre/sauce/sugarfree,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/menu11
	name = "emergency MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 11, nutriment paste. Only for emergencies."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidfood,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	)

/obj/item/storage/single_use/mre/menu12
	name = "crayon MRE"
	desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/storage/fancy/crayons,
	/obj/item/storage/single_use/mrebag/dessert/menu11,
	/obj/random/mre/sauce/crayon,
	/obj/random/mre/sauce/crayon,
	/obj/random/mre/sauce/crayon
	)

/obj/item/storage/single_use/mre/menu13
	name = "medical MRE"
	desc = "This one is menu 13, vitamin paste & dessert. Only for emergencies."
	icon_state = "crayonmre"
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidvitamin,
	/obj/item/reagent_containers/food/snacks/liquidprotein,
	/obj/random/mre/drink,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/single_use/mre/random
	desc = "The menu label is faded out."
	starts_with = list(
	/obj/random/mre/main,
	/obj/item/storage/single_use/mrebag/side,
	/obj/item/storage/single_use/mrebag/dessert,
	/obj/item/storage/fancy/crackers,
	/obj/random/mre/spread,
	/obj/random/mre/drink,
	/obj/random/mre/sauce,
	/obj/item/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/material/kitchen/utensil/spoon/plastic
	)

//Subtypes
/obj/item/storage/single_use/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	storage_slots = 1
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled)


/obj/item/storage/single_use/mrebag/menu2
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/margherita/filled)

/obj/item/storage/single_use/mrebag/menu3
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled)

/obj/item/storage/single_use/mrebag/menu4
	starts_with = list(/obj/item/reagent_containers/food/snacks/monkeyburger)

/obj/item/storage/single_use/mrebag/menu5
	starts_with = list(/obj/item/reagent_containers/food/snacks/taco)

/obj/item/storage/single_use/mrebag/menu6
	starts_with = list(/obj/item/reagent_containers/food/snacks/slice/meatbread/filled)

/obj/item/storage/single_use/mrebag/menu7
	starts_with = list(/obj/item/reagent_containers/food/snacks/tossedsalad)

/obj/item/storage/single_use/mrebag/menu8
	starts_with = list(/obj/item/reagent_containers/food/snacks/hotchili)

/obj/item/storage/single_use/mrebag/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/boiledrice)

/obj/item/storage/single_use/mrebag/menu10
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatcube)

/obj/item/storage/single_use/mrebag/side
	name = "side dish"
	desc = "A vacuum-sealed bag containing the MRE's side dish. Self-heats when opened."
	icon_state = "pouch_small"
	starts_with = list(/obj/random/mre/side)

/obj/item/storage/single_use/mrebag/side/menu10
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatcube)

/obj/item/storage/single_use/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	starts_with = list(/obj/random/mre/dessert)

/obj/item/storage/single_use/mrebag/dessert/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/item/storage/single_use/mrebag/dessert/menu11
	starts_with = list(/obj/item/pen/crayon/rainbow)
