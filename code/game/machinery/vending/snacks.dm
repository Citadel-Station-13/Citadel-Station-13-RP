
/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(
		/obj/item/reagent_containers/food/snacks/wrapped/candy = 6,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 6,
		/obj/item/reagent_containers/food/snacks/bagged/chips = 6,
		/obj/item/reagent_containers/food/snacks/bagged/sosjerky = 6,
		/obj/item/reagent_containers/food/snacks/boxed/no_raisin = 6,
		/obj/item/reagent_containers/food/snacks/wrapped/spacetwinkie = 6,
		/obj/item/reagent_containers/food/snacks/bagged/cheesiehonkers = 6,
		/obj/item/reagent_containers/food/snacks/bagged/hotcheesiehonkers = 3,
		/obj/item/reagent_containers/food/snacks/tastybread = 6,
		/obj/item/reagent_containers/food/snacks/wrapped/skrellsnacks = 3,
		/obj/item/reagent_containers/food/snacks/baschbeans = 6,
		/obj/item/reagent_containers/food/snacks/creamcorn = 6,
		/obj/item/reagent_containers/hard_candy/lollipop = 6,
		/obj/item/reagent_containers/food/snacks/wrapped/spunow = 6,
		/obj/item/reagent_containers/food/snacks/wrapped/glad2nut = 6,
		/obj/item/reagent_containers/food/snacks/wrapped/natkat = 6
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/syndicake = 6,
		/obj/item/reagent_containers/food/snacks/boxed/unajerky = 6,
	)
	prices = list(
		/obj/item/reagent_containers/food/snacks/wrapped/candy = 2,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 5,
		/obj/item/reagent_containers/food/snacks/bagged/chips = 3,
		/obj/item/reagent_containers/food/snacks/bagged/sosjerky = 3,
		/obj/item/reagent_containers/food/snacks/boxed/no_raisin = 2,
		/obj/item/reagent_containers/food/snacks/wrapped/spacetwinkie = 2,
		/obj/item/reagent_containers/food/snacks/bagged/cheesiehonkers = 3,
		/obj/item/reagent_containers/food/snacks/bagged/hotcheesiehonkers = 6,
		/obj/item/reagent_containers/food/snacks/tastybread = 3,
		/obj/item/reagent_containers/food/snacks/wrapped/skrellsnacks = 4,
		/obj/item/reagent_containers/food/snacks/baschbeans = 6,
		/obj/item/reagent_containers/food/snacks/creamcorn = 6,
		/obj/item/reagent_containers/hard_candy/lollipop = 2,
		/obj/item/reagent_containers/food/snacks/wrapped/spunow = 4,
		/obj/item/reagent_containers/food/snacks/wrapped/glad2nut = 4,
		/obj/item/reagent_containers/food/snacks/wrapped/natkat = 4,
		/obj/item/reagent_containers/food/snacks/syndicake = 7,
		/obj/item/reagent_containers/food/snacks/boxed/unajerky = 6,
	)

/obj/machinery/vending/fitness // Added Liquid Protein and slightly adjusted price of liquid food items due to buff.
	name = "SweatMAX"
	desc = "Fueled by your inner inadequacy!"
	icon_state = "fitness"
	products = list(
		/obj/item/reagent_containers/food/drinks/smallmilk = 8,
		/obj/item/reagent_containers/food/drinks/smallchocmilk = 8,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 8,
		/obj/item/reagent_containers/food/snacks/wrapped/proteinbar = 8,
		/obj/item/reagent_containers/food/snacks/liquid = 10,
		/obj/item/reagent_containers/food/snacks/liquid/protein = 10,
		/obj/item/reagent_containers/pill/diet = 8,
		/obj/item/towel/random = 8,
		/obj/item/reagent_containers/food/snacks/brainsnax = 5,
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/steroid = 4
	)
	// yes, it's a ripoff, much like real sports food.
	prices = list(
		/obj/item/reagent_containers/food/drinks/smallmilk = 3,
		/obj/item/reagent_containers/food/drinks/smallchocmilk = 3,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 15,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 5,
		/obj/item/reagent_containers/food/snacks/wrapped/proteinbar = 10,
		/obj/item/reagent_containers/food/snacks/liquid = 15,
		/obj/item/reagent_containers/food/snacks/liquid/protein = 15,
		/obj/item/reagent_containers/pill/diet = 10,
		/obj/item/towel/random = 15,
		/obj/item/reagent_containers/food/snacks/brainsnax = 10,
		/obj/item/reagent_containers/syringe/steroid = 12,
	)

/obj/machinery/vending/weeb
	name = "Nippon-Tan!"
	desc = "A vendor full of asian snackfood variety!"
	icon_state = "weeb"
	icon_vend = "weeb-vend"
	products = list(
		/obj/item/reagent_containers/food/snacks/riceball = 10,
		/obj/item/reagent_containers/food/snacks/hanamidango = 10,
		/obj/item/reagent_containers/food/snacks/gomadango = 10,
		/obj/item/reagent_containers/food/snacks/mochi = 10,
		/obj/item/reagent_containers/food/snacks/dorayaki = 10,
		/obj/item/reagent_containers/food/snacks/chocobanana = 10,
		/obj/item/storage/box/pocky = 10,
		/obj/item/storage/box/gondola = 10,
		/obj/item/reagent_containers/food/snacks/bagged/wpeas = 10,
		/obj/item/reagent_containers/food/drinks/cans/ochamidori = 10,
		/obj/item/reagent_containers/food/drinks/cans/ramune = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_fire = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_blue = 10,
		/obj/item/clothing/under/kimono = 5,
		/obj/item/clothing/under/kimono/yellow = 5,
		/obj/item/clothing/under/kimono/blue = 5,
		/obj/item/clothing/under/bsing = 5,
		/obj/item/clothing/shoes/boots/bsing = 5,
		/obj/item/clothing/under/ysing = 5,
		/obj/item/clothing/shoes/boots/ysing = 5,
		/obj/item/storage/daki = 10,
		/obj/item/toy/katana = 10
	)
	prices = list(
		/obj/item/reagent_containers/food/snacks/riceball = 5,
		/obj/item/reagent_containers/food/snacks/hanamidango = 5,
		/obj/item/reagent_containers/food/snacks/gomadango = 5,
		/obj/item/reagent_containers/food/snacks/mochi = 5,
		/obj/item/reagent_containers/food/snacks/dorayaki = 5,
		/obj/item/reagent_containers/food/snacks/chocobanana = 5,
		/obj/item/storage/box/pocky = 5,
		/obj/item/storage/box/gondola = 5,
		/obj/item/reagent_containers/food/snacks/bagged/wpeas = 5,
		/obj/item/reagent_containers/food/drinks/cans/ochamidori = 8,
		/obj/item/reagent_containers/food/drinks/cans/ramune = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_fire = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_blue = 2,
		/obj/item/clothing/under/kimono = 10,
		/obj/item/clothing/under/kimono/yellow = 10,
		/obj/item/clothing/under/kimono/blue = 10,
		/obj/item/clothing/under/bsing = 10,
		/obj/item/clothing/shoes/boots/bsing = 10,
		/obj/item/clothing/under/ysing = 10,
		/obj/item/clothing/shoes/boots/ysing = 10,
		/obj/item/storage/daki = 50,
		/obj/item/toy/katana = 15
	)


/obj/machinery/vending/food
	name = "Food-O-Mat"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "vend_food"
	icon_deny = "vend_food-deny"
	products = list(
		/obj/item/tray = 8,
		/obj/item/material/kitchen/utensil/fork = 6,
		/obj/item/material/knife/plastic = 6,
		/obj/item/material/kitchen/utensil/spoon = 6,
		/obj/item/reagent_containers/food/snacks/tomatosoup = 8,
		/obj/item/reagent_containers/food/snacks/mushroomsoup = 8,
		/obj/item/reagent_containers/food/snacks/jellysandwich = 8,
		/obj/item/reagent_containers/food/snacks/taco = 8,
		/obj/item/reagent_containers/food/snacks/cheeseburger = 8,
		/obj/item/reagent_containers/food/snacks/grilledcheese = 8,
		/obj/item/reagent_containers/food/snacks/hotdog = 8,
		/obj/item/reagent_containers/food/snacks/loadedbakedpotato = 8,
		/obj/item/reagent_containers/food/snacks/omelette = 8,
		/obj/item/reagent_containers/food/snacks/pastatomato = 8,
		/obj/item/reagent_containers/food/snacks/tofuburger = 8,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza = 2,
		/obj/item/reagent_containers/food/snacks/waffles = 4,
		/obj/item/reagent_containers/food/snacks/muffin = 4,
		/obj/item/reagent_containers/food/snacks/appletart = 4,
		/obj/item/reagent_containers/food/snacks/sliceable/applecake = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/bananabread = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread = 2,
		/obj/item/reagent_containers/food/snacks/brainsnax = 5,
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/mysterysoup = 10,
	)
	vend_delay = 15

/obj/machinery/vending/food/arojoan //Fluff vendor for the lewd houseboat.
	name = "Custom Food-O-Mat"
	desc = "Do you think Joan cooks? Of course not. Lazy squirrel!"
	icon_state = "vend_food"
	icon_deny = "vend_food-deny"
	products = list(
		/obj/item/tray = 6,
		/obj/item/material/kitchen/utensil/fork = 6,
		/obj/item/material/knife/plastic = 6,
		/obj/item/material/kitchen/utensil/spoon = 6,
		/obj/item/reagent_containers/food/snacks/hotandsoursoup = 3,
		/obj/item/reagent_containers/food/snacks/kitsuneudon = 3,
		/obj/item/reagent_containers/food/snacks/generalschicken = 3,
		/obj/item/reagent_containers/food/snacks/sliceable/sushi = 2,
		/obj/item/reagent_containers/food/snacks/jellysandwich = 3,
		/obj/item/reagent_containers/food/snacks/grilledcheese = 3,
		/obj/item/reagent_containers/food/snacks/hotdog = 3,
		/obj/item/storage/box/wings = 2,
		/obj/item/reagent_containers/food/snacks/loadedbakedpotato = 3,
		/obj/item/reagent_containers/food/snacks/omelette = 3,
		/obj/item/reagent_containers/food/snacks/waffles = 3,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 1,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 1,
		/obj/item/reagent_containers/food/snacks/appletart = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/applecake = 1,
		/obj/item/reagent_containers/food/snacks/sliceable/bananabread = 2,
		/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread = 2,
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/mysterysoup = 10,
	)
	vend_delay = 15

/obj/machinery/vending/mre
	name = "MRE Vendor"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "mre"
	icon_deny = "mre-deny"
	products = list(
		/obj/item/storage/single_use/mre = 8,
		/obj/item/storage/single_use/mre/menu2 = 8,
		/obj/item/storage/single_use/mre/menu3 = 8,
		/obj/item/storage/single_use/mre/menu4 = 8,
		/obj/item/storage/single_use/mre/menu5 = 8,
		/obj/item/storage/single_use/mre/menu6 = 8,
		/obj/item/storage/single_use/mre/menu7 = 8,
		/obj/item/storage/single_use/mre/menu8 = 8,
		/obj/item/storage/single_use/mre/menu9 = 8,
		/obj/item/storage/single_use/mre/menu10 = 8,
	)
	contraband = list(
		/obj/item/storage/single_use/mre/menu11 = 4,
		/obj/item/storage/single_use/mre/menu13 = 4,
		/obj/item/storage/single_use/mre/menu12 = 1,
	)
	price_default = 20 //You have to pay for it, as to prevent chef players from raging :)
