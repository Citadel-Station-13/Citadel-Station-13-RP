/obj/item/reagent_containers/food/drinks/cup
	name = "coffee cup"
	desc = "The container of oriental luxuries."
	icon_state = "cup_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/drinks/cup/on_reagent_change()
	..()
	if (reagents.total_volume)
		var/datum/reagent/R = reagents.get_majority_reagent_datum()

		if(R.cup_icon_state)
			icon_state = R.cup_icon_state
		else
			icon_state = "cup_brown"

		if(R.cup_name)
			name = R.cup_name
		else
			name = "Cup of.. what?"

		if(R.cup_desc)
			desc = R.cup_desc
		else
			desc = "You can't really tell what this is."

		if(R.cup_center_of_mass)
			center_of_mass = R.cup_center_of_mass
		else
			center_of_mass = list("x"=16, "y"=16)

	else
		icon_state = "cup_empty"
		name = "coffee cup"
		desc = "The container of oriental luxuries."
		center_of_mass = list("x"=16, "y"=16)
		return

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = list()
	volume = 10

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change(changetype)
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	name = "small carton"
	desc = "A small carton, intended for holding drinks."
	icon_state = "juicebox"
	volume = 15 //I figure if you have to craft these it should at least be slightly better than something you can get for free from a watercooler

/obj/item/reagent_containers/food/drinks/sillycup/smallcarton/on_reagent_change(changetype)
	if (reagents.total_volume)
		switch(reagents.get_majority_reagent_id())
			if("orangejuice")
				icon_state = "orangebox"
				name = "orange juice box"
				desc = "A great source of vitamins. Stay healthy!"
			if("milk")
				icon_state = "milkbox"
				name = "carton of milk"
				desc = "An excellent source of calcium for growing space explorers."
			if("applejuice")
				icon_state = "juicebox"
				name = "apple juice box"
				desc = "Sweet apple juice. Don't be late for school!"
			if("grapejuice")
				icon_state = "grapebox"
				name = "grape juice box"
				desc = "Tasty grape juice in a fun little container. Non-alcoholic!"
			/*
			if(/datum/reagent/consumable/pineapplejuice)
				icon_state = "pineapplebox"
				name = "pineapple juice box"
				desc = "Why would you even want this?"
			*/
			if("chocolate_milk")
				icon_state = "chocolatebox"
				name = "carton of chocolate milk"
				desc = "Milk for cool kids!"
			if("eggnog")
				icon_state = "nog2"
				name = "carton of eggnog"
				desc = "For enjoying the most wonderful time of the year."
	else
		icon_state = "juicebox"
		name = "small carton"
		desc = "A small carton, intended for holding drinks."

//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/cup/coffeepot
	name = "coffeepot"
	desc = "A large pot for dispensing that ambrosia of corporate life known to mortals only as coffee. Contains 4 standard cups."
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 40, 80, 120)

/obj/item/reagent_containers/cup/coffeepot/bluespace
	name = "bluespace coffeepot"
	desc = "The most advanced coffeepot the eggheads could cook up: sleek design; graduated lines; connection to a pocket dimension for coffee containment; yep, it's got it all. Contains 8 standard cups."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0)

// not using cup for the path here because we have some weird stuff with the icon setting
//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/coffeepot
	name = "coffeepot"
	desc = "A large pot for dispensing that ambrosia of corporate life known to mortals only as coffee. Contains 4 standard cups."
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 40, 80, 120)

/obj/item/reagent_containers/coffeepot/bluespace
	name = "bluespace coffeepot"
	desc = "The most advanced coffeepot the eggheads could cook up: sleek design; graduated lines; connection to a pocket dimension for coffee containment; yep, it's got it all. Contains 8 standard cups."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0)

/obj/item/reagent_containers/cup/glass/mug/nanotrasen
	name = "\improper Nanotrasen mug"
	desc = "A mug to display your corporate pride."
	icon_state = "mug_nt_empty"

/obj/item/reagent_containers/cup/glass/mug/nanotrasen/update_icon_state()
	icon_state = reagents.total_volume ? "mug_nt" : "mug_nt_empty"
	return ..()

/obj/item/reagent_containers/cup/glass/coffee_cup
	name = "coffee cup"
	desc = "A heat-formed plastic coffee cup. Can theoretically be used for other hot drinks, if you're feeling adventurous."
	icon_state = "coffee_cup_e"
	possible_transfer_amounts = list(10)
	volume = 30
	spillable = TRUE
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/coffee_cup/update_icon_state()
	icon_state = reagents.total_volume ? "coffee_cup" : "coffee_cup_e"
	return ..()
