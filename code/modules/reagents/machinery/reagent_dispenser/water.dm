/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "watertank"
	starting_reagents = list(
		/datum/reagent/water = 1000,
	)
	starting_capacity = 1000
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/watertank/high
	name = "high-capacity water tank"
	desc = "A highly-pressurized water tank made to hold vast amounts of water.."
	icon_state = "watertank_high"
	starting_reagents = list(
		/datum/reagent/water = 5000,
	)
	starting_capacity = 5000
