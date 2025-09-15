/*
*	Here is where any supply packs related
*		to being hospitable tasks live
*/


/datum/supply_pack/nanotrasen/hospitality
	abstract_type = /datum/supply_pack/nanotrasen/hospitality
	category = "Hospitality"

/datum/supply_pack/nanotrasen/hospitality/party
	name = "Party equipment"
	contains = list(
			/obj/item/storage/box/mixedglasses = 2,
			/obj/item/storage/box/glasses/square,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/reagent_containers/food/drinks/flask/barflask,
			/obj/item/reagent_containers/food/drinks/bottle/patron,
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/item/lipstick/random,
			/obj/item/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/reagent_containers/food/drinks/bottle/small/beer = 4,
			)
	worth = 350
	container_type = /obj/structure/closet/crate/corporate/gilthari
	container_name = "Party equipment"

/datum/supply_pack/nanotrasen/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(
			/obj/item/storage/box/glasses/cocktail,
			/obj/item/storage/box/glasses/rocks,
			/obj/item/storage/box/glasses/square,
			/obj/item/storage/box/glasses/pint,
			/obj/item/storage/box/glasses/wine,
			/obj/item/storage/box/glasses/shake,
			/obj/item/storage/box/glasses/shot,
			/obj/item/storage/box/glasses/mug,
			/obj/item/storage/box/glasses/meta,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/storage/box/glass_extras/straws,
			/obj/item/storage/box/glass_extras/sticks
			)
	worth = 350
	container_type = /obj/structure/closet/crate/corporate/gilthari
	container_name = "crate of bar supplies"

/datum/supply_pack/nanotrasen/hospitality/pizza
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/pizzabox/margherita,
			/obj/item/pizzabox/mushroom,
			/obj/item/pizzabox/meat,
			/obj/item/pizzabox/vegetable,
			)
	name = "Surprise pack of five pizzas"
	worth = 250
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Pizza crate"

/datum/supply_pack/nanotrasen/hospitality/gifts
	name = "Gift crate"
	contains = list(
		/obj/item/toy/bouquet = 3,
		/obj/item/storage/fancy/heartbox = 2,
		/obj/item/paper/card/smile,
		/obj/item/paper/card/heart,
		/obj/item/paper/card/cat,
		/obj/item/paper/card/flower
		)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "crate of gifts"

/datum/supply_pack/nanotrasen/hospitality/burgers
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger,
			/obj/item/reagent_containers/food/snacks/cheeseburger,
			/obj/item/reagent_containers/food/snacks/jellyburger,
			/obj/item/reagent_containers/food/snacks/tofuburger,
			/obj/item/reagent_containers/food/snacks/fries
			)
	name = "Burger crate"
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Burger crate"

/datum/supply_pack/nanotrasen/hospitality/bakery
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/reagent_containers/food/snacks/baguette,
			/obj/item/reagent_containers/food/snacks/appletart,
			/obj/item/reagent_containers/food/snacks/berrymuffin,
			/obj/item/reagent_containers/food/snacks/bunbun,
			/obj/item/reagent_containers/food/snacks/cherrypie,
			/obj/item/reagent_containers/food/snacks/cookie,
			/obj/item/reagent_containers/food/snacks/croissant,
			/obj/item/reagent_containers/food/snacks/donut/normal,
			/obj/item/reagent_containers/food/snacks/donut/jelly,
			/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
			/obj/item/reagent_containers/food/snacks/muffin,
			/obj/item/reagent_containers/food/snacks/pie,
			/obj/item/reagent_containers/food/snacks/plump_pie,
			/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
			/obj/item/reagent_containers/food/snacks/poppypretzel,
			/obj/item/reagent_containers/food/snacks/sugarcookie,
			/obj/item/reagent_containers/food/snacks/waffles
			)
	name = "Bakery products crate"
	worth = 75
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Bakery products crate"

/datum/supply_pack/nanotrasen/hospitality/cakes
	lazy_gacha_amount = 2
	lazy_gacha_contained = list(
			/obj/item/reagent_containers/food/snacks/sliceable/applecake,
			/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake,
			/obj/item/reagent_containers/food/snacks/sliceable/carrotcake,
			/obj/item/reagent_containers/food/snacks/sliceable/cheesecake,
			/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake,
			/obj/item/reagent_containers/food/snacks/sliceable/lemoncake,
			/obj/item/reagent_containers/food/snacks/sliceable/limecake,
			/obj/item/reagent_containers/food/snacks/sliceable/orangecake,
			/obj/item/reagent_containers/food/snacks/sliceable/plaincake
			)
	name = "Cake crate"
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Cake crate"

/datum/supply_pack/nanotrasen/hospitality/mexican
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/reagent_containers/food/snacks/cheeseburrito,
			/obj/item/reagent_containers/food/snacks/enchiladas,
			/obj/item/reagent_containers/food/snacks/meatburrito,
			/obj/item/reagent_containers/food/snacks/taco
			)
	name = "Mexican takeout crate"
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Mexican takeout crate"

/datum/supply_pack/nanotrasen/hospitality/asian
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/reagent_containers/food/snacks/generalschicken,
			/obj/item/reagent_containers/food/snacks/hotandsoursoup
			)
	name = "Chinese takeout crate"
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Chinese takeout crate"

/datum/supply_pack/nanotrasen/hospitality/cookingoil
	name = "Tallow tank crate"
	contains = list(/obj/structure/reagent_dispensers/tallow)
	worth = 350
	container_type = /obj/structure/largecrate
	container_name = "Tallow tank crate"

/datum/supply_pack/nanotrasen/hospitality/vampcarepackage
	name = "Vetalan Care package"
	contains = list(/obj/item/reagent_containers/blood/prelabeled/ABPlus = 3,
					/obj/item/clothing/under/suit_jacket)
	worth = 500
	container_type = /obj/structure/closet/coffin/comfy
	container_name = "Extra comfortable coffin"

/datum/supply_pack/nanotrasen/hospitality/moghes
	name = "Moghes Foodstuffs"
	contains = list(
			/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew = 2,
			/obj/item/reagent_containers/food/snacks/boxed/unajerky = 4
			)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/unathi
	container_name = "Moghes Foodstuffs"

/datum/supply_pack/nanotrasen/hospitality/fish
	name = "Fish supply crate"
	contains = list(
			/obj/item/reagent_containers/food/snacks/lobster = 6,
			/obj/item/reagent_containers/food/snacks/shrimp = 6,
			/obj/item/reagent_containers/food/snacks/cuttlefish = 8,
			/obj/item/reagent_containers/food/snacks/sliceable/monkfish = 1
			)
	worth = 150
	container_name = "Fish crate"

/datum/supply_pack/nanotrasen/hospitality/donuts
	contains = list(
		/obj/item/storage/box/donut = 3,
	)
	name = "Donut resupply crate"
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Donut Resupply Crate"
	container_desc = "For all your emergency donut resupply needs, Centauri Provision's got you."

/datum/supply_pack/nanotrasen/hospitality/condiments
	contains = list(
		/obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/reagent_containers/food/condiment/ketchup = 2,
		/obj/item/reagent_containers/food/condiment/sugar,
		/obj/item/reagent_containers/food/condiment/hotsauce,
		/obj/item/reagent_containers/food/condiment/coldsauce,
		/obj/item/reagent_containers/food/condiment/soysauce,
		/obj/item/reagent_containers/food/condiment/small/saltshaker = 3,
		/obj/item/reagent_containers/food/condiment/small/peppermill = 3,
		/obj/item/reagent_containers/food/condiment/spacespice = 3,
	)
	worth = 50 // todo: autodetect
	name = "Condiment crate"
	container_type = /obj/structure/closet/crate/corporate/centauri
	container_name = "Condiment crate"
