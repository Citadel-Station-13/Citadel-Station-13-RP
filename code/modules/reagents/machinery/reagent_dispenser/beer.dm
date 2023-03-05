/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	starting_reagents = list(
		/datum/reagent/ethanol/beer = 1000,
	)
	starting_capacity = 1000

/obj/structure/reagent_dispensers/beerkeg/fakenuke
	name = "nuclear beer keg"
	desc = "A beer keg in the form of a nuclear bomb! An absolute blast at parties!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
