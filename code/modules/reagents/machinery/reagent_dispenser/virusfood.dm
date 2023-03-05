/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food. Yum."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	density = FALSE
	starting_reagents = list(
		/datum/reagent/nutriment/virus_food = 1000,
	)
	starting_capacity = 1000
