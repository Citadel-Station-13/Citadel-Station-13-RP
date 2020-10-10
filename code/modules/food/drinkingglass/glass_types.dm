/obj/item/reagent_containers/food/drinks/glass2/square
	name = "half-pint glass"
	base_name = "glass"
	base_icon = "square"
	desc = "Your standard drinking glass."
	filling_states = list(20, 40, 60, 80, 100)
	volume = 30
	possible_transfer_amounts = list(5,10,15,30)
	rim_pos = list(23,13,20) // y, x0, x1
	matter = list("glass" = 60)

/obj/item/reagent_containers/food/drinks/glass2/rocks
	name = "rocks glass"
	base_name = "glass"
	base_icon = "rocks"
	desc = "A shorter, wider glass. Doesn't hold quite as much as a half-pint glass."
	filling_states = list(25, 50, 75, 100)
	volume = 20
	possible_transfer_amounts = list(5,10,20)
	rim_pos = list(21, 10, 23)
	matter = list("glass" = 40)

/obj/item/reagent_containers/food/drinks/glass2/shake
	name = "milkshake glass"
	base_name = "glass"
	base_icon = "shake"
	desc = "A tall, tapering milkshake glass. Holds half a pint."
	filling_states = list(25, 50, 75, 100)
	volume = 30
	possible_transfer_amounts = list(5,10,15,30)
	rim_pos = list(25, 13, 21)
	matter = list("glass" = 30)

/obj/item/reagent_containers/food/drinks/glass2/cocktail
	name = "cocktail glass"
	base_name = "glass"
	base_icon = "cocktail"
	desc = "A delicate cocktail glass. Holds a quarter of a pint."
	filling_states = list(33, 66, 100)
	volume = 15
	possible_transfer_amounts = list(5,10,15)
	rim_pos = list(22, 13, 21)
	matter = list("glass" = 30)

/obj/item/reagent_containers/food/drinks/glass2/shot
	name = "shot glass"
	base_name = "shot"
	base_icon = "shot"
	desc = "A tiny little shotglass."
	filling_states = list(33, 66, 100)
	volume = 5
	possible_transfer_amounts = list(1,2,5)
	rim_pos = list(17, 13, 21)
	matter = list("glass" = 10)

/obj/item/reagent_containers/food/drinks/glass2/pint
	name = "pint glass"
	base_name = "pint"
	base_icon = "pint"
	desc = "The biggest glass available, short of a pitcher. Holds twice as much as a half-pint glass. Who would've guessed?"
	filling_states = list(16, 33, 50, 66, 83, 100)
	volume = 60
	possible_transfer_amounts = list(5,10,15,30,60)
	rim_pos = list(25, 12, 21)
	matter = list("glass" = 120)

/obj/item/reagent_containers/food/drinks/glass2/mug
	name = "glass mug"
	base_name = "mug"
	base_icon = "mug"
	desc = "A sturdy glass mug. Holds a bit more than a half-pint glass."
	filling_states = list(25, 50, 75, 100)
	volume = 40
	possible_transfer_amounts = list(5,10,20,40)
	rim_pos = list(22, 12, 20)
	matter = list("glass" = 80)

/obj/item/reagent_containers/food/drinks/glass2/wine
	name = "wine glass"
	base_name = "glass"
	base_icon = "wine"
	desc = "A fancy wineglass."
	filling_states = list(20, 40, 60, 80, 100)
	volume = 25
	possible_transfer_amounts = list(5, 10, 15, 25)
	rim_pos = list(25, 12, 21)
	matter = list("glass" = 50)

/obj/item/reagent_containers/food/drinks/glass2/pitcher
	name = "pitcher"
	base_name = "pitcher"
	base_icon = "pitcher"
	desc = "An empty pitcher, for parties. Holds up to five pints."
	filling_states = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
	volume = 300
	amount_per_transfer_from_this = 30
	possible_transfer_amounts = list(5,10,15,30,60)
	rim_pos = list(25, 12, 21)
	matter = list("glass" = 600)