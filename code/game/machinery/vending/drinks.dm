/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 25,
		/obj/item/reagent_containers/food/drinks/tea = 25,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 25,
		/obj/item/reagent_containers/food/drinks/cans/robustexpress = 10,
		/obj/item/reagent_containers/food/drinks/cans/robustexpresslatte = 10
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/ice = 10
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/coffee = 3,
		/obj/item/reagent_containers/food/drinks/tea = 3,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 3,
		/obj/item/reagent_containers/food/drinks/cans/robustexpress = 2,
		/obj/item/reagent_containers/food/drinks/cans/robustexpresslatte = 2,
		/obj/item/reagent_containers/food/drinks/ice = 1
	)

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	icon_vend = "Cola_Machine-purchase"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/battery = 10,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,
		/obj/item/reagent_containers/food/drinks/cans/coconutwater = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 10,
		/obj/item/reagent_containers/food/drinks/cans/gingerale = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_fire = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura = 10,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_blue = 10,
		/obj/item/reagent_containers/food/drinks/cans/crystalgibb = 10,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb_cherry = 10,
		/obj/item/reagent_containers/food/drinks/cans/ochamidori = 10,
		/obj/item/reagent_containers/food/drinks/cans/ramune = 10,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/reagent_containers/food/drinks/cans/cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/cola_cherry = 10,
		/obj/item/reagent_containers/food/drinks/cans/cola_coffee = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10,
		/obj/item/reagent_containers/food/drinks/cans/gondola_energy = 10,
		/obj/item/reagent_containers/food/drinks/cans/robustexpressiced = 10,
		/obj/item/reagent_containers/food/drinks/bludbox = 5,
		/obj/item/reagent_containers/food/drinks/bludboxlight = 5,
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5,
		/obj/item/reagent_containers/food/snacks/liquid = 6,
		/obj/item/reagent_containers/food/drinks/cans/dumbjuice = 4,
		/obj/item/reagent_containers/food/drinks/cans/geometer = 2
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 2,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 2,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 2,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 2,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 2,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 2,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 2,
		/obj/item/reagent_containers/food/drinks/cans/gingerale = 2,
		/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 2,
		/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 2,
		/obj/item/reagent_containers/food/drinks/cans/ochamidori = 3,
		/obj/item/reagent_containers/food/drinks/cans/ramune = 2,
		/obj/item/reagent_containers/food/drinks/cans/battery = 5,
		/obj/item/reagent_containers/food/drinks/cans/crystalgibb = 2,
		/obj/item/reagent_containers/food/drinks/cans/gondola_energy = 5,
		/obj/item/reagent_containers/food/drinks/bludbox = 10, //vetalan care package costs 30 in Cargo.
		/obj/item/reagent_containers/food/drinks/bludboxlight = 15,
		/obj/item/reagent_containers/food/drinks/cans/coconutwater = 6,
		/obj/item/reagent_containers/food/drinks/cans/kyocola = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_fire = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura = 2,
		/obj/item/reagent_containers/food/drinks/cans/kyocola_blue = 2,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb_cherry = 2,
		/obj/item/reagent_containers/food/drinks/cans/cola_cherry = 2,
		/obj/item/reagent_containers/food/drinks/cans/cola_coffee = 2,
		/obj/item/reagent_containers/food/drinks/cans/robustexpressiced = 2,
		/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 8,
		/obj/item/reagent_containers/food/snacks/liquid = 8, //SweatMAX LiquidFood costs 15. Making the contraband version cheaper can be rewarding.
		/obj/item/reagent_containers/food/drinks/cans/dumbjuice = 1,
		/obj/item/reagent_containers/food/drinks/cans/geometer = 15, //Geometer Energy contains actual blood.
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine. How did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/space_up = 30,
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/bottle/cola = 20,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
