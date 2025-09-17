/obj/item/reagent_containers/food/drinks/glue
	name = "Glue"
	desc = "A small bottle full of glue. The orange tip calls to you, and the fluid inside is non-toxic... Should you?"
	icon_state = "glue"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
	start_with_single_reagent = /datum/reagent/drink/glue

/obj/item/reagent_containers/food/drinks/glue/on_reagent_change()
	..()
	if(reagents.total_volume)
		icon_state = "glue"
	else
		icon_state = "glue_e"
