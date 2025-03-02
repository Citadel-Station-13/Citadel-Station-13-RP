//* Dairy

/obj/item/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	volume = 50
	start_with_single_reagent = /datum/reagent/drink/milk

/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	volume = 50
	start_with_single_reagent = /datum/reagent/drink/milk/soymilk

/obj/item/reagent_containers/food/drinks/smallmilk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "mini-milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	volume = 30
	start_with_single_reagent = /datum/reagent/drink/milk

/obj/item/reagent_containers/food/drinks/smallchocmilk
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."
	icon_state = "mini-milk_choco"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	volume = 30
	start_with_single_reagent = /datum/reagent/drink/milk/chocolate

//* Vetalan

/obj/item/reagent_containers/food/drinks/bludboxmax
	name = "Bludbox MAX carton"
	desc = "A vampire's best friend! This Bludbox contains only the most delicious of organic, free-range O-Negatives. For all your dietary needs!"
	volume = 30
	icon_state = "bludboxmax"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	start_with_single_reagent = /datum/reagent/blood

/obj/item/reagent_containers/food/drinks/bludboxmaxlight
	name = "Bludbox MAX Light carton"
	desc = "A bloodsucking vegan's hipster alternative to drinking the red stuff. Bludbox light is just the same as drinking straight from the source! Comes in O- flavour."
	volume = 30
	icon_state = "bludboxmaxlight"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	start_with_single_reagent = /datum/reagent/blood
	start_with_single_data_initializer = new /datum/blood_mixture/preset/single/synthblood

/obj/item/reagent_containers/food/drinks/bludbox
	name = "Bludbox carton"
	desc = "The pop alternative to drinking real, human blood! Comes in blood flavour and contains all the dietary requirements for your undead friends."
	volume = 30
	icon_state = "bludbox"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	start_with_single_reagent = /datum/reagent/drink/blud
	start_with_single_data_initializer = new /datum/blood_mixture/preset/single/synthblood

/obj/item/reagent_containers/food/drinks/bludboxlight
	name = "Bludbox Light carton"
	desc = "The pop alternative to drinking real, human blood! Comes in blood flavour and contains all the dietary requirements for your undead friends. This one has less sweeteners, gross!"
	volume = 30
	icon_state = "bludboxlight"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	start_with_single_reagent = /datum/reagent/drink/blud/bludlight
	start_with_single_data_initializer = new /datum/blood_mixture/preset/single/synthblood
