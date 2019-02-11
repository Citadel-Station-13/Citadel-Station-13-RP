/obj/item/weapon/reagent_containers/food/snacks/macncheese
	name = "macaroni and cheese"
	desc = "The perfect combination of noodles and dairy."
	icon = 'modular_citadel/icons/obj/food_cit.dmi'
	icon_state = "macncheese"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 9
	nutriment_desc = list("Cheese" = 5, "pasta" = 4, "happiness" = 1)

/obj/item/weapon/reagent_containers/food/snacks/macncheese/New()
	..()
	bitesize = 3
