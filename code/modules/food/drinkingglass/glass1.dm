/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	integrity_flags = INTEGRITY_ACIDPROOF
	center_of_mass = list("x"=16, "y"=10)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound =  'sound/items/pickup/drinkglass.ogg'
	materials_base = list(MAT_GLASS = 80)

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	/*if(reagents.reagent_list.len > 1 )
		icon_state = "glass_brown"
		name = "Glass of Hooch"
		desc = "Two or more drinks, mixed together."*/
	/*else if(reagents.reagent_list.len == 1)
		for(var/datum/reagent/R in reagents.reagent_list)
			switch(R.id)*/
	if (reagents.total_volume)
		var/datum/reagent/R = reagents.get_majority_reagent_datum()

		if(R.glass_icon_state)
			icon_state = R.glass_icon_state
		else
			icon_state = "glass_brown"

		if(R.glass_name)
			name = R.glass_name
		else
			name = "Glass of.. what?"

		if(R.glass_desc)
			desc = R.glass_desc
		else
			desc = "You can't really tell what this is."

		if(R.glass_center_of_mass)
			center_of_mass = R.glass_center_of_mass
		else
			center_of_mass = list("x"=16, "y"=10)

		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	else
		icon_state = "glass_empty"
		name = "glass"
		desc = "Your standard drinking glass."
		center_of_mass = list("x"=16, "y"=10)
		return

/obj/item/reagent_containers/food/drinks/cup
	name = "coffee cup"
	desc = "The container of oriental luxuries."
	icon_state = "cup_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	center_of_mass = list("x"=16, "y"=16)
	materials_base = list(MAT_GLASS = 60)

/obj/item/reagent_containers/food/drinks/cup/on_reagent_change()
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

		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null

	else
		icon_state = "cup_empty"
		name = "coffee cup"
		desc = "The container of oriental luxuries."
		center_of_mass = list("x"=16, "y"=16)
		return

// for /obj/machinery/vending/sovietsoda
/obj/item/reagent_containers/food/drinks/drinkingglass/soda/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sodawater", 50)
	on_reagent_change()

/obj/item/reagent_containers/food/drinks/drinkingglass/cola/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cola", 50)
	on_reagent_change()

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	name = "shot glass"
	desc = "No glasses were shot in the making of this glass."
	icon_state = "shotglass"
	amount_per_transfer_from_this = 10
	volume = 10
	materials_base = list(MAT_GLASS = 10)

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/on_reagent_change()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/medical/reagentfillings.dmi', src, "[icon_state]1")

		switch(reagents.total_volume)
			if(0 to 3)
				filling.icon_state = "[icon_state]1"
			if(4 to 7)
				filling.icon_state = "[icon_state]5"
			if(8 to INFINITY)
				filling.icon_state = "[icon_state]12"

		filling.color += reagents.get_color()
		add_overlay(filling)
		name = "shot glass of " + reagents.get_majority_reagent_name() //No matter what, the glass will tell you the reagent's name. Might be too abusable in the future.
	else
		name = "shot glass"

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask
	name = "fitness shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	volume = 100
	materials_base = list(MAT_PLASTIC = 120)

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/Initialize(mapload)
	. = ..()
	icon_state = pick("fitness-cup_black", "fitness-cup_red", "fitness-cup_black")

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/on_reagent_change()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/medical/reagentfillings.dmi', src, "fitness-cup10")

		switch(reagents.total_volume)
			if(0 to 10)
				filling.icon_state = "fitness-cup10"
			if(11 to 20)
				filling.icon_state = "fitness-cup20"
			if(21 to 29)
				filling.icon_state = "fitness-cup30"
			if(30 to 39)
				filling.icon_state = "fitness-cup40"
			if(40 to 49)
				filling.icon_state = "fitness-cup50"
			if(50 to 59)
				filling.icon_state = "fitness-cup60"
			if(60 to 69)
				filling.icon_state = "fitness-cup70"
			if(70 to 79)
				filling.icon_state = "fitness-cup80"
			if(80 to 89)
				filling.icon_state = "fitness-cup90"
			if(90 to INFINITY)
				filling.icon_state = "fitness-cup100"

		filling.color += reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake
	name = "protein shake"

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake/Initialize(mapload)
	. = ..()
	reagents.add_reagent("nutriment", 30)
	reagents.add_reagent("iron", 10)
	reagents.add_reagent("protein", 15)
	reagents.add_reagent("water", 45)
	on_reagent_change()
