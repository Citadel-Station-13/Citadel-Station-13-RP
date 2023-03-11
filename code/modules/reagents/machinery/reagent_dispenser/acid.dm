/obj/structure/reagent_dispensers/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	density = FALSE
	starting_reagents = list(
		/datum/reagent/acid = 1000,
	)
	starting_capacity = 1000
