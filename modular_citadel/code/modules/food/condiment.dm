/obj/item/weapon/reagent_containers/food/condiment/flour
	volume = 220

/obj/item/weapon/reagent_containers/food/condiment/flour/New()
	..()
	reagents.add_reagent("flour", 200)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/condiment/spacespice
	name = "space spices"
	desc = "An exotic blend of spices for cooking. Definitely not worms."
	icon_state = "spacespicebottle"
	possible_transfer_amounts = list(1,40) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 40
	New()
		..()
		reagents.add_reagent("spacespice", 40)