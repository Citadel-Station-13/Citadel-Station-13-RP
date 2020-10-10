/obj/item/reagent_containers/food/drinks/glass2/fitnessflask // Balance work
	name = "fitness shaker"
	base_name = "shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	base_icon = "fitness-cup"
	volume = 50
	matter = list("plastic" = 2000)
	filling_states = list(5,10,15,20,25,30,35,40,45,50)
	possible_transfer_amounts = list(5, 10, 15, 25)
	rim_pos = null // no fruit slices
	var/lid_color = "black"

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/Initialize()
	..()
	lid_color = pick("black", "red", "blue")
	update_icon()

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/update_icon()
	..()
	icon_state = "[base_icon]_[lid_color]"

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake
	name = "protein shake"

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake/Initialize()
	..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("iron", 10)
	reagents.add_reagent("protein", 30)
