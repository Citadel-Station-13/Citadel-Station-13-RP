/obj/structure/reagent_dispensers/h
	name = "Hydrogen Dispenser"
	desc = "A dispenser of hydrogen for fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 50
	anchored = TRUE
	density = FALSE
	starting_reagents = list(
		/datum/reagent/hydrogen = 10000, // You'll hate me for this but, fuck waiting for medical
	)
	starting_capacity = 10000
